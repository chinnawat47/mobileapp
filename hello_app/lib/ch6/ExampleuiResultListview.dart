import 'package:flutter/material.dart';
import 'data/RegisterData.dart';
import 'widgets/register_ui_widgets.dart';

class ExampleuiResultListview extends StatelessWidget {
  final List<RegisterData> registerList;

  const ExampleuiResultListview({super.key, required this.registerList});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Chip(
              avatar: Icon(
                Icons.people_outline_rounded,
                size: 18,
                color: colorScheme.onPrimaryContainer,
              ),
              label: Text('${registerList.length} records'),
              backgroundColor: colorScheme.onPrimary.withValues(alpha: 0.15),
              labelStyle: TextStyle(color: colorScheme.onPrimary),
              side: BorderSide.none,
            ),
          ),
        ],
      ),
      body: registerList.isEmpty
          ? const EmptyResultState()
          : LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 600;
                final horizontalPadding = isWide ? 32.0 : 16.0;

                return ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    16,
                    horizontalPadding,
                    24,
                  ),
                  itemCount: registerList.length,
                  itemBuilder: (context, index) {
                    final data = registerList[index];
                    return _RegisterResultCard(
                      index: index + 1,
                      data: data,
                    );
                  },
                );
              },
            ),
    );
  }
}

/// Card แสดงข้อมูลแต่ละรายการในหน้า Result
class _RegisterResultCard extends StatelessWidget {
  final int index;
  final RegisterData data;

  const _RegisterResultCard({
    required this.index,
    required this.data,
  });

  String get _birthdayText {
    if (data.birthday == null) return 'No date selected';
    return '${data.birthday!.day}/${data.birthday!.month}/${data.birthday!.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 50).clamp(0, 200)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 14),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      '$index',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'Record #$index',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.verified_rounded,
                    color: data.acceptTerm
                        ? colorScheme.secondary
                        : colorScheme.outline,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1),
              ),
              ResultInfoRow(
                icon: Icons.apartment_outlined,
                label: 'Department',
                value: data.department,
              ),
              ResultInfoRow(
                icon: Icons.wc_outlined,
                label: 'Gender',
                value: data.gender,
              ),
              ResultInfoRow(
                icon: Icons.cake_outlined,
                label: 'Birthday',
                value: _birthdayText,
              ),
              ResultInfoRow(
                icon: Icons.check_circle_outline_rounded,
                label: 'Accept Terms',
                value: data.acceptTerm ? 'Yes' : 'No',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

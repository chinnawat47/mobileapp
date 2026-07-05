import 'package:flutter/material.dart';
import 'ExampleuiResultListview.dart';
import 'data/RegisterData.dart';
import 'widgets/register_ui_widgets.dart';

class ExampleuiSTD extends StatefulWidget {
  const ExampleuiSTD({super.key});

  @override
  State<ExampleuiSTD> createState() => _ExampleuiSTDState();
}

class _ExampleuiSTDState extends State<ExampleuiSTD> {
  final TextEditingController _nameController = TextEditingController();

  String _result = '';
  String _selectedOption = 'IT'; // ค่า default dropdown
  String _gender = 'Male';
  bool _acceptTerm = false;
  DateTime? _selectedDate;

  final List<String> _options = ['IT', 'Digital', 'Network'];
  final List<RegisterData> _registerList = [];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addData() {
    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _result = 'Please enter your name';
      });
      return;
    }

    if (_selectedDate == null) {
      setState(() {
        _result = 'Please select birthday';
      });
      return;
    }

    if (!_acceptTerm) {
      setState(() {
        _result = 'Please accept the terms and conditions';
      });
      return;
    }

    final data = RegisterData(
      name: _nameController.text.trim(),
      department: _selectedOption,
      gender: _gender,
      birthday: _selectedDate,
      acceptTerm: _acceptTerm,
    );

    setState(() {
      _registerList.add(data);
      _result = 'Data added successfully';
    });
  }

  void _viewALL() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ExampleuiResultListview(registerList: _registerList),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: Curves.easeInOutCubic),
          );
          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  void _cancel() {
    setState(() {
      _nameController.clear();
      _selectedOption = _options[0];
      _gender = 'Male';
      _acceptTerm = false;
      _selectedDate = null;
      _result = '';
    });
  }

  String get _birthdayLabel {
    if (_selectedDate == null) return 'No date selected';
    return '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';
  }

  Widget _buildActionButtons(BuildContext context, bool isWide) {
    final cancelButton = RegisterActionButton(
      label: 'Cancel',
      icon: Icons.close_rounded,
      outlined: true,
      onPressed: _cancel,
    );
    final addButton = RegisterActionButton(
      label: 'Add',
      icon: Icons.add_circle_outline_rounded,
      backgroundColor: Colors.green.shade600,
      onPressed: _addData,
    );
    final viewButton = RegisterActionButton(
      label: 'View ALL',
      icon: Icons.list_alt_rounded,
      backgroundColor: Theme.of(context).colorScheme.primary,
      onPressed: _viewALL,
    );

    if (isWide) {
      return Row(
        children: [
          Expanded(child: cancelButton),
          const SizedBox(width: 12),
          Expanded(child: addButton),
          const SizedBox(width: 12),
          Expanded(child: viewButton),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        cancelButton,
        const SizedBox(height: 10),
        addButton,
        const SizedBox(height: 10),
        viewButton,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 520;
          final horizontalPadding = isWide ? 32.0 : 20.0;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              20,
              horizontalPadding,
              32,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.app_registration_rounded,
                            color: colorScheme.primary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Student Registration',
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Fill in your details below',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FormSectionHeader(
                              icon: Icons.person_outline_rounded,
                              title: 'Name',
                            ),
                            TextField(
                              controller: _nameController,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                hintText: 'Enter your name',
                                prefixIcon: Icon(Icons.badge_outlined),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const FormSectionHeader(
                              icon: Icons.business_center_outlined,
                              title: 'Department',
                            ),
                            DropdownButtonFormField<String>(
                              value: _selectedOption,
                              isExpanded: true,
                              decoration: const InputDecoration(
                                labelText: 'Select Department',
                                prefixIcon: Icon(Icons.apartment_outlined),
                              ),
                              borderRadius: BorderRadius.circular(16),
                              items: _options.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedOption = newValue!;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            const FormSectionHeader(
                              icon: Icons.wc_outlined,
                              title: 'Gender',
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest
                                    .withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: colorScheme.outlineVariant,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: const Text('Male'),
                                      value: 'Male',
                                      groupValue: _gender,
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      onChanged: (value) {
                                        setState(() {
                                          _gender = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<String>(
                                      title: const Text('Female'),
                                      value: 'Female',
                                      groupValue: _gender,
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      onChanged: (value) {
                                        setState(() {
                                          _gender = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const FormSectionHeader(
                              icon: Icons.cake_outlined,
                              title: 'Birthday',
                            ),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: colorScheme.outlineVariant,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: 20,
                                    color: colorScheme.primary,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _birthdayLabel,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: _selectedDate == null
                                            ? colorScheme.onSurfaceVariant
                                            : colorScheme.onSurface,
                                        fontWeight: _selectedDate == null
                                            ? FontWeight.normal
                                            : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  FilledButton.tonalIcon(
                                    onPressed: _pickDate,
                                    icon: const Icon(Icons.event_rounded, size: 18),
                                    label: const Text('Select Date'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Material(
                              color: colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(16),
                              child: CheckboxListTile(
                                title: const Text(
                                  'I accept the terms and conditions',
                                ),
                                subtitle: Text(
                                  'Required to complete registration',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                value: _acceptTerm,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _acceptTerm = value!;
                                  });
                                },
                                controlAffinity: ListTileControlAffinity.leading,
                                secondary: Icon(
                                  Icons.verified_user_outlined,
                                  color: colorScheme.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildActionButtons(context, isWide),
                    const SizedBox(height: 20),
                    ResultMessageBanner(message: _result),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

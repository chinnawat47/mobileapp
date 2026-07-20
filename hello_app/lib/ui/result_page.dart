import 'package:flutter/material.dart';
import '../models/register_data.dart';
import '../services/registration_storage.dart';
import 'detail_page.dart';

class ResultPage extends StatefulWidget {
  final List<RegisterData> registrations;

  const ResultPage({super.key, required this.registrations});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late List<RegisterData> _registrations;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _registrations = List<RegisterData>.from(widget.registrations);
  }

  Future<void> _deleteItem(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete registration?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _registrations.removeAt(index);
    });
    await RegistrationStorage.save(_registrations);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration deleted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _registrations.where((item) {
      final query = _query.toLowerCase();
      return item.studentId.toLowerCase().contains(query) ||
          '${item.name} ${item.surname}'.toLowerCase().contains(query) ||
          item.major.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: theme.brightness == Brightness.dark
                ? [Colors.indigo.shade900, Colors.black]
                : [Colors.indigo.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person_search_outlined, color: Colors.indigo.shade700),
                            const SizedBox(width: 8),
                            const Text('Registered Students', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Search by ID, name, or major',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                            filled: true,
                            fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
                          ),
                          onChanged: (value) => setState(() => _query = value),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox_outlined, size: 72, color: Colors.blueGrey),
                            const SizedBox(height: 12),
                            const Text('No registration data', style: TextStyle(fontSize: 18, color: Colors.blueGrey)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.only(bottom: 14),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.indigo.shade50,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.person, color: Colors.indigo),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${index + 1}. ${item.studentId}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                          const SizedBox(height: 6),
                                          Text('${item.name} ${item.surname}'),
                                          const SizedBox(height: 4),
                                          Text('Major: ${item.major}'),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.phone, size: 16, color: Colors.grey),
                                              const SizedBox(width: 4),
                                              Flexible(child: Text(item.phone)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        IconButton(
                                          tooltip: 'View detail',
                                          icon: const Icon(Icons.visibility, color: Colors.indigo),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => DetailPage(registration: item),
                                              ),
                                            );
                                          },
                                        ),
                                        IconButton(
                                          tooltip: 'Delete',
                                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                          onPressed: () => _deleteItem(_registrations.indexOf(item)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

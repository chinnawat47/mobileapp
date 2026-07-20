import 'package:flutter/material.dart';
import 'SimplePieChartDemoSol.dart';
import 'SimpleBarChartDemoSol.dart';
import 'SimpleLineChartDemoSol.dart';

class LogDashboardPage extends StatelessWidget {
  const LogDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Dashboard Analytics'),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.analytics_outlined, color: Colors.indigo),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Log Analytics', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text('Live Firestore metrics and trends', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildChartCard(
                  context,
                  title: 'Log Status Distribution',
                  child: const SimplePieChartDemoSol(),
                ),
                const SizedBox(height: 16),
                _buildChartCard(
                  context,
                  title: 'Average Response Duration by Service',
                  child: const SimpleBarChartDemoSol(),
                ),
                const SizedBox(height: 16),
                _buildChartCard(
                  context,
                  title: 'Log Duration Timeline',
                  child: const SimpleLineChartDemoSol(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChartCard(BuildContext context, {required String title, required Widget child}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'SimplePieChartDemoSol.dart';
import 'SimpleBarChartDemoSol.dart';
import 'SimpleLineChartDemoSol.dart';

class LogDashboardPage extends StatelessWidget {
  const LogDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Dashboard Analytics'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Log Dashboard Analytics',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

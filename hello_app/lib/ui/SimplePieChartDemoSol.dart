import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../service/LogDataService.dart';

class SimplePieChartDemoSol extends StatefulWidget {
  const SimplePieChartDemoSol({super.key});

  @override
  State<SimplePieChartDemoSol> createState() => _SimplePieChartDemoSolState();
}

class _SimplePieChartDemoSolState extends State<SimplePieChartDemoSol> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _logStream;

  final Map<String, Color> _levelColors = {
    'INFO': Colors.green.shade600,
    'WARN': Colors.amber.shade600,
    'ERROR': Colors.orange.shade700,
    'FATAL': Colors.red.shade700,
  };

  @override
  void initState() {
    super.initState();
    _logStream = FirebaseFirestore.instance
        .collection('server_logs')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _logStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No data in server_logs'));
            }

            final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                snapshot.data!.docs;

            final Map<String, int> logCounts =
                LogDataService.aggregateLogLevels(
              docs,
              allowedLevels: ['INFO', 'WARN', 'ERROR', 'FATAL'],
            );

            List<PieChartSectionData> sections = [];
            logCounts.forEach((level, valueCount) {
              if (valueCount > 0) {
                //draw status in case value > 0
                sections.add(
                  PieChartSectionData(
                    value: valueCount.toDouble(),
                    title: '$level\n($valueCount)', //display info here
                    color: _levelColors[level] ?? Colors.grey,
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                );
              }
            });

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Log Status Distribution',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: sections,
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction_model.dart';
import '../services/transaction_service.dart';

class TransactionDashboard extends StatefulWidget {
  const TransactionDashboard({super.key});

  @override
  State<TransactionDashboard> createState() => _TransactionDashboardState();
}

class _TransactionDashboardState extends State<TransactionDashboard> {
  final TransactionService _transactionService = TransactionService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const Color _primaryDark = Color(0xFF0F172A);
  static const Color _primaryMid = Color(0xFF1E3A5F);
  static const Color _accentOrange = Color(0xFFF97316);
  static const Color _accentIndigo = Color(0xFF6366F1);
  static const Color _accentTeal = Color(0xFF14B8A6);

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matchesSearch(TransactionModel transaction, String query) {
    if (query.isEmpty) {
      return true;
    }

    final normalizedQuery = query.toLowerCase();
    return transaction.status.toLowerCase().contains(normalizedQuery) ||
        transaction.type.toLowerCase().contains(normalizedQuery) ||
        transaction.customer.toLowerCase().contains(normalizedQuery) ||
        transaction.paymentMethod.toLowerCase().contains(normalizedQuery) ||
        transaction.description.toLowerCase().contains(normalizedQuery);
  }

  String _normalizePaymentMethod(String method) {
    final lower = method.toLowerCase();
    if (lower.contains('paypal')) {
      return 'PayPal';
    }
    if (lower.contains('credit') ||
        lower.contains('card') ||
        lower.contains('visa') ||
        lower.contains('master') ||
        lower.contains('amex') ||
        lower.contains('express') ||
        lower.contains('union') ||
        lower.contains('jcb') ||
        lower.contains('discover') ||
        lower.contains('pay')) {
      return 'Credit Card';
    }
    if (lower.contains('bank') ||
        lower.contains('transfer') ||
        lower.contains('wire') ||
        lower.contains('swift') ||
        lower.contains('ach') ||
        lower.contains('deposit')) {
      return 'Bank Transfer';
    }
    if (lower.contains('crypto') ||
        lower.contains('bitcoin') ||
        lower.contains('ethereum') ||
        lower.contains('btc') ||
        lower.contains('eth') ||
        lower.contains('sol') ||
        lower.contains('usdt') ||
        lower.contains('usdc')) {
      return 'Crypto';
    }
    return method.isEmpty ? 'Unknown' : 'Other';
  }

  Map<String, _PaymentMethodSummary> _groupByPaymentMethod(
    List<TransactionModel> transactions,
  ) {
    final grouped = <String, _PaymentMethodSummary>{};

    for (final transaction in transactions) {
      final paymentMethod = _normalizePaymentMethod(transaction.paymentMethod);

      grouped.putIfAbsent(
        paymentMethod,
        () => _PaymentMethodSummary(paymentMethod: paymentMethod),
      );

      final summary = grouped[paymentMethod]!;
      summary.count += 1;
      summary.totalAmount += transaction.amount;
    }

    final sortedEntries = grouped.entries.toList()
      ..sort((a, b) => b.value.count.compareTo(a.value.count));

    return Map.fromEntries(sortedEntries);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_primaryDark, _primaryMid, Color(0xFF312E81)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: StreamBuilder<List<TransactionModel>>(
            stream: _transactionService.getTransactionsStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return _buildStatusView(
                  icon: Icons.error_outline,
                  title: 'Connection Error',
                  message: '${snapshot.error}',
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildStatusView(
                  icon: Icons.cloud_off_outlined,
                  title: 'No Data Found',
                  message: 'No transactions found in Firestore collection "transactions".',
                );
              }

              final allTransactions = snapshot.data!;
              final filteredTransactions = allTransactions
                  .where(
                    (transaction) => _matchesSearch(transaction, _searchQuery),
                  )
                  .toList();
              final groupedData = _groupByPaymentMethod(filteredTransactions);
              final paymentMethods = groupedData.keys.toList();
              final totalTransactions = filteredTransactions.length;
              final totalRevenue = filteredTransactions.fold<double>(
                0,
                (sum, transaction) => sum + transaction.amount,
              );
              final averageTransaction = totalTransactions == 0
                  ? 0.0
                  : totalRevenue / totalTransactions;

              final amountFormatter = NumberFormat('#,##0.00');
              final countFormatter = NumberFormat('#,##0');

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 24),
                    _buildSearchBox(),
                    const SizedBox(height: 24),
                    _buildSummaryCards(
                      totalTransactions: totalTransactions,
                      totalRevenue: totalRevenue,
                      averageTransaction: averageTransaction,
                      amountFormatter: amountFormatter,
                      countFormatter: countFormatter,
                    ),
                    const SizedBox(height: 24),
                    _buildChartSection(
                      paymentMethods: paymentMethods,
                      groupedData: groupedData,
                      amountFormatter: amountFormatter,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatusView({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.white70),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          tooltip: 'Back',
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Transaction Analytics Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF22C55E),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Real-time Firebase Report',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.analytics_outlined,
            color: _accentOrange,
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Filter by status, type, customer, payment method, description...',
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
          suffixIcon: _searchQuery.isEmpty
              ? null
              : IconButton(
                  icon: Icon(Icons.close, color: Colors.grey.shade600),
                  onPressed: _searchController.clear,
                ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildSummaryCards({
    required int totalTransactions,
    required double totalRevenue,
    required double averageTransaction,
    required NumberFormat amountFormatter,
    required NumberFormat countFormatter,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;
        final cards = [
          _buildSummaryCard(
            title: 'Total Transactions',
            value: countFormatter.format(totalTransactions),
            icon: Icons.receipt_long_outlined,
            color: _accentIndigo,
          ),
          _buildSummaryCard(
            title: 'Total Revenue',
            value: amountFormatter.format(totalRevenue),
            icon: Icons.payments_outlined,
            color: _accentOrange,
          ),
          _buildSummaryCard(
            title: 'Average Transaction',
            value: amountFormatter.format(averageTransaction),
            icon: Icons.trending_up_outlined,
            color: _accentTeal,
          ),
        ];

        if (isWide) {
          return Row(
            children: [
              for (var i = 0; i < cards.length; i++) ...[
                if (i > 0) const SizedBox(width: 16),
                Expanded(child: cards[i]),
              ],
            ],
          );
        }

        return Column(
          children: [
            for (var i = 0; i < cards.length; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              cards[i],
            ],
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const Spacer(),
              Icon(Icons.circle, size: 8, color: color.withValues(alpha: 0.5)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: _primaryDark,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection({
    required List<String> paymentMethods,
    required Map<String, _PaymentMethodSummary> groupedData,
    required NumberFormat amountFormatter,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _accentIndigo.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.bar_chart_rounded,
                  color: _accentIndigo,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transactions by Payment Method',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _primaryDark,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Tap a bar to view detailed metrics',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          if (paymentMethods.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 48),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(Icons.search_off, size: 40, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    'No transactions match your search.',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          else
            SizedBox(
              height: 300,
              child: BarChart(
                _buildBarChartData(
                  paymentMethods: paymentMethods,
                  groupedData: groupedData,
                  amountFormatter: amountFormatter,
                ),
              ),
            ),
        ],
      ),
    );
  }

  BarChartData _buildBarChartData({
    required List<String> paymentMethods,
    required Map<String, _PaymentMethodSummary> groupedData,
    required NumberFormat amountFormatter,
  }) {
    final barColors = [
      _accentIndigo,
      _accentOrange,
      _accentTeal,
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
      const Color(0xFF0EA5E9),
    ];

    final maxCount = paymentMethods
        .map((method) => groupedData[method]!.count.toDouble())
        .fold<double>(0, (previous, value) => value > previous ? value : previous);

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: maxCount <= 0 ? 10 : maxCount * 1.25,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.grey.shade200,
          strokeWidth: 1,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1.5),
          left: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
      ),
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => _primaryDark,
          tooltipBorderRadius: BorderRadius.circular(10),
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            final paymentMethod = paymentMethods[group.x];
            final summary = groupedData[paymentMethod]!;

            return BarTooltipItem(
              '$paymentMethod\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              children: [
                TextSpan(
                  text: 'Transactions: ${summary.count}\n',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                TextSpan(
                  text: 'Total Amount: ${amountFormatter.format(summary.totalAmount)}',
                  style: const TextStyle(
                    color: _accentOrange,
                    fontSize: 12,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 42,
            getTitlesWidget: (value, meta) {
              if (value % 1 != 0 || value < 0) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 46,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= paymentMethods.length) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _shortLabel(paymentMethods[index]),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ),
      ),
      barGroups: List.generate(paymentMethods.length, (index) {
        final count = groupedData[paymentMethods[index]]!.count.toDouble();
        final color = barColors[index % barColors.length];

        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: count,
              color: color,
              width: 24,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: maxCount <= 0 ? 10 : maxCount * 1.25,
                color: color.withValues(alpha: 0.08),
              ),
            ),
          ],
        );
      }),
    );
  }

  String _shortLabel(String label) {
    if (label.length <= 12) {
      return label;
    }
    return '${label.substring(0, 12)}...';
  }
}

class _PaymentMethodSummary {
  _PaymentMethodSummary({required this.paymentMethod});

  final String paymentMethod;
  int count = 0;
  double totalAmount = 0;
}

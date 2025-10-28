import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/providers/budget_provider.dart';
import 'package:expense_tracker/screen/budget_setup_screen.dart';
import 'package:expense_tracker/widgets/budget_card.dart';
import 'package:expense_tracker/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/transaction_provider.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final budgets = ref.watch(budgetProvider);
    final notifier = ref.read(budgetProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Finance Tracker'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BudgetSetupScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              final currentMode = ref.read(themeModeProvider.notifier);
              final isDark = Theme.of(context).brightness == Brightness.dark;
              currentMode.state = isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),

      body: transactionsAsync.when(
        data: (transactions) {
          final totalBalance = transactions.fold<double>(
            0.0,
            (sum, t) => t.isExpense ? sum - t.amount : sum + t.amount,
          );

          // Group expenses by category
          final categoryTotals = <String, double>{};
          for (var tx in transactions) {
            if (tx.isExpense) {
              categoryTotals[tx.category] =
                  (categoryTotals[tx.category] ?? 0) + tx.amount;
            }
          }

          // Generate pie chart sections
          final chartSections = categoryTotals.entries.map((entry) {
            final color =
                Colors.primaries[entry.key.hashCode % Colors.primaries.length];
            return PieChartSectionData(
              color: color,
              value: entry.value,
              title: entry.key,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList();

          return RefreshIndicator(
            onRefresh: () async =>
                ref.read(transactionsProvider.notifier).loadTransactions(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBalanceCard(totalBalance),
                    const SizedBox(height: 16),

                    // Expense Pie Chart
                    if (categoryTotals.isNotEmpty)
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                'Expenses by Category',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 220,
                                child: PieChart(
                                  PieChartData(
                                    sectionsSpace: 2,
                                    centerSpaceRadius: 40,
                                    sections: chartSections,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 10,
                                runSpacing: 8,
                                children: categoryTotals.entries.map((entry) {
                                  final color =
                                      Colors.primaries[entry.key.hashCode %
                                          Colors.primaries.length];
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: color,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${entry.key}: ₹${entry.value.toStringAsFixed(0)}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('No expense data yet.'),
                        ),
                      ),

                    const SizedBox(height: 16),
                    const Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    if (transactions.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Text('No transactions yet.'),
                        ),
                      )
                    else
                      ...transactions
                          .take(10)
                          .map((tx) => TransactionTile(transaction: tx)),
                    const SizedBox(height: 16),
                    const Text(
                      'Category Budgets',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...budgets.map((b) => BudgetCard(budget: b)),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBalanceCard(double totalBalance) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Balance',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              NumberFormat.currency(symbol: '₹').format(totalBalance),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: totalBalance >= 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:expense_tracker/providers/budget_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BudgetSetupScreen extends ConsumerWidget {
  const BudgetSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(budgetProvider);
    final notifier = ref.read(budgetProvider.notifier);

    final categoryController = TextEditingController();
    final limitController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Set Monthly Budgets')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: limitController,
              decoration: const InputDecoration(
                labelText: 'Budget Limit (₹)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final category = categoryController.text.trim();
                final limit = double.tryParse(limitController.text) ?? 0;
                if (category.isNotEmpty && limit > 0) {
                  await notifier.setBudget(category, limit);
                  categoryController.clear();
                  limitController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Budget added/updated!')),
                  );
                }
              },
              child: const Text('Save Budget'),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: budgets.length,
                itemBuilder: (context, index) {
                  final b = budgets[index];
                  return ListTile(
                    title: Text(b.category),
                    subtitle: Text('Limit: ₹${b.limit.toStringAsFixed(0)}'),
                    trailing: Text(
                      'Spent: ₹${b.spent.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: b.spent >= b.limit * 0.9
                            ? Colors.orange
                            : (b.spent > b.limit ? Colors.red : Colors.green),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

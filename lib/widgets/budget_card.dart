import 'package:expense_tracker/model/budget_model.dart';
import 'package:flutter/material.dart';

class BudgetCard extends StatelessWidget {
  final BudgetModel budget;

  const BudgetCard({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double progress =
        budget.limit > 0 ? (budget.spent / budget.limit).clamp(0.0, 1.0) : 0.0;

    Color progressColor;
    if (progress >= 1.0) {
      progressColor = Colors.red; // Over budget
    } else if (progress >= 0.8) {
      progressColor = Colors.orange; // Close to limit
    } else {
      progressColor = Colors.green; // Safe zone
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  budget.category,
                  style: theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '₹${budget.spent.toStringAsFixed(0)} / ₹${budget.limit.toStringAsFixed(0)}',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: progressColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                color: progressColor,
                minHeight: 10,
              ),
            ),

            // Budget alert message
            const SizedBox(height: 8),
            if (progress >= 1.0)
              Text(
                "Over budget!",
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
              )
            else if (progress >= 0.8)
              Text(
                "You're close to your budget limit!",
                style: TextStyle(
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              Text(
                "You're within your budget.",
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

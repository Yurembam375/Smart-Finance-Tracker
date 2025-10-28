import 'package:expense_tracker/model/transaction_model.dart';
import 'package:expense_tracker/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TransactionTile extends ConsumerWidget {
  final TransactionModel transaction;
  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(transaction.id),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.red),
      ),
      onDismissed: (_) async {
        // Temporarily store deleted transaction
        final deletedTx = transaction;

        // Delete from provider
        await ref.read(transactionsProvider.notifier).deleteTransaction(transaction.id);

        // Show snackbar with undo option
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Transaction deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                ref.read(transactionsProvider.notifier).addTransaction(
                      deletedTx.title,
                      deletedTx.amount,
                      deletedTx.category,
                      deletedTx.isExpense,
                    );
              },
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: transaction.isExpense ? Colors.red.shade100 : Colors.green.shade100,
            child: Icon(
              transaction.isExpense ? Icons.arrow_downward : Icons.arrow_upward,
              color: transaction.isExpense ? Colors.red : Colors.green,
            ),
          ),
          title: Text(transaction.title, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(
            '${transaction.category} • ${DateFormat.yMMMd().format(transaction.date)}',
            style: const TextStyle(fontSize: 12),
          ),
          trailing: Text(
            (transaction.isExpense ? '-' : '+') + NumberFormat.currency(symbol: '₹').format(transaction.amount),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: transaction.isExpense ? Colors.red : Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:expense_tracker/model/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}

import 'package:expense_tracker/model/transaction_model.dart';
import 'package:hive/hive.dart';


class TransactionRepository {
  static const String boxName = 'transactionsBox';

  Future<Box<TransactionModel>> _getBox() async {
    return Hive.box<TransactionModel>(boxName);
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    final box = await _getBox();
    await box.put(transaction.id, transaction);
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    final box = await _getBox();
    await box.put(transaction.id, transaction);
  }

  Future<void> deleteTransaction(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final box = await _getBox();
    return box.values.toList();
  }

  Future<double> getTotalBalance() async {
    final transactions = await getAllTransactions();
    double income = transactions
        .where((t) => !t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount);
    double expenses = transactions
        .where((t) => t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount);
    return income - expenses;
  }
}

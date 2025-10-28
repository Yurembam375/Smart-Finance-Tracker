import 'package:hive_flutter/hive_flutter.dart';
import '../model/budget_model.dart';

class BudgetRepository {
  static const boxName = 'budgetsBox';
  final Box<BudgetModel> box = Hive.box<BudgetModel>(boxName);

  List<BudgetModel> getAllBudgets() => box.values.toList();

  Future<void> addOrUpdateBudget(String category, double limit) async {
    final now = DateTime.now();
    final monthKey = '${category}_${now.year}_${now.month}';

    final existing = box.get(monthKey);
    if (existing != null) {
      existing.limit = limit;
      await existing.save();
    } else {
      final newBudget = BudgetModel(category: category, limit: limit);
      await box.put(monthKey, newBudget);
    }
  }

  Future<void> updateSpent(String category, double amount, bool isExpense) async {
    final now = DateTime.now();
    final monthKey = '${category}_${now.year}_${now.month}';
    final budget = box.get(monthKey);

    if (budget != null) {
      budget.spent += isExpense ? amount : -amount;
      await budget.save();
    }
  }

  Future<BudgetModel?> getBudget(String category) async {
    final now = DateTime.now();
    final monthKey = '${category}_${now.year}_${now.month}';
    return box.get(monthKey);
  }
}

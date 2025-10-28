import 'package:hive_flutter/hive_flutter.dart';
import '../model/budget_model.dart';

class BudgetRepository {
  static const boxName = 'budgetsBox';
  final Box<BudgetModel> box = Hive.box<BudgetModel>(boxName);

  List<BudgetModel> getAllBudgets() => box.values.toList();

  Future<void> addOrUpdateBudget(String category, double limit) async {
    final existing = box.get(category);
    if (existing != null) {
      existing.limit = limit;
      await existing.save();
    } else {
      final newBudget = BudgetModel(category: category, limit: limit, spent: 0);
      await box.put(category, newBudget);
    }
  }

  Future<void> updateSpent(String category, double amount, bool isExpense) async {
    final budget = box.get(category);
    if (budget != null) {
      budget.spent += isExpense ? amount : -amount;
      await budget.save();
    }
  }
}

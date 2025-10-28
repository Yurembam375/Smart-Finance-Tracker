
// import 'package:expense_tracker/repositories/budget_repository.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import '../model/budget_model.dart';


// final budgetProvider = StateNotifierProvider<BudgetNotifier, List<BudgetModel>>((ref) {
//   return BudgetNotifier();
// });

// class BudgetNotifier extends StateNotifier<List<BudgetModel>> {
//   final repo = BudgetRepository();

//   BudgetNotifier() : super([]) {
//     loadBudgets();
//   }

//   Future<void> loadBudgets() async {
//     state = repo.getAllBudgets();
//   }

//   Future<void> setBudget(String category, double limit) async {
//     await repo.addOrUpdateBudget(category, limit);
//     await loadBudgets();
//   }

//   Future<void> updateSpent(String category, double amount, bool isExpense) async {
//     await repo.updateSpent(category, amount, isExpense);
//     await loadBudgets();
//   }
// }
import 'package:expense_tracker/model/budget_model.dart';
import 'package:expense_tracker/repositories/budget_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final budgetRepositoryProvider = Provider((ref) => BudgetRepository());

final budgetProvider = StateNotifierProvider<BudgetNotifier, List<BudgetModel>>(
  (ref) {
    final repo = ref.watch(budgetRepositoryProvider);
    return BudgetNotifier(repo);
  },
);

class BudgetNotifier extends StateNotifier<List<BudgetModel>> {
  final BudgetRepository _repository;
  BudgetNotifier(this._repository) : super([]) {
    loadBudgets();
  }

  void loadBudgets() {
    state = _repository.getAllBudgets();
  }

  Future<void> setBudget(String category, double limit) async {
    await _repository.addOrUpdateBudget(category, limit);
    loadBudgets();
  }

  Future<void> updateSpent(String category, double amount, bool isExpense) async {
    await _repository.updateSpent(category, amount, isExpense);
    loadBudgets();
  }
}

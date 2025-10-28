import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../repositories/budget_repository.dart';
import '../model/budget_model.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepository();
});

final budgetProvider =
    StateNotifierProvider<BudgetNotifier, List<BudgetModel>>((ref) {
  final repo = ref.watch(budgetRepositoryProvider);
  return BudgetNotifier(repo);
});

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
}


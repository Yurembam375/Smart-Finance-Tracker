import 'package:expense_tracker/model/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';

import '../repositories/transaction_repository.dart';
import '../repositories/budget_repository.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository();
});

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepository();
});

final transactionsProvider =
    StateNotifierProvider<TransactionNotifier, AsyncValue<List<TransactionModel>>>(
  (ref) {
    final transactionRepo = ref.watch(transactionRepositoryProvider);
    final budgetRepo = ref.watch(budgetRepositoryProvider);
    return TransactionNotifier(transactionRepo, budgetRepo);
  },
);

class TransactionNotifier extends StateNotifier<AsyncValue<List<TransactionModel>>> {
  final TransactionRepository _repository;
  final BudgetRepository _budgetRepository;

  TransactionNotifier(this._repository, this._budgetRepository)
      : super(const AsyncValue.loading()) {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    state = const AsyncValue.loading();
    try {
      final transactions = await _repository.getAllTransactions();
      transactions.sort((a, b) => b.date.compareTo(a.date));
      state = AsyncValue.data(transactions);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addTransaction(
    String title,
    double amount,
    String category,
    bool isExpense,
  ) async {
    final transaction = TransactionModel(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      category: category,
      date: DateTime.now(),
      isExpense: isExpense,
    );

    await _repository.addTransaction(transaction);

    // 🔥 Update the category's budget spent
    await _budgetRepository.updateSpent(category, amount, isExpense);

    await loadTransactions();
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await _repository.updateTransaction(transaction);
    await loadTransactions();
  }

  Future<void> deleteTransaction(String id) async {
    try {
      // Get the transaction being deleted so we can update the budget
      final currentTransactions = state.value ?? [];
      final transaction = currentTransactions.firstWhere((t) => t.id == id);

      await _repository.deleteTransaction(id);

      // 🔥 Reduce spent from budget (reverse logic)
      await _budgetRepository.updateSpent(
        transaction.category,
        transaction.amount,
        !transaction.isExpense,
      );

      await loadTransactions();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

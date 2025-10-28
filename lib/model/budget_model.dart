import 'package:hive/hive.dart';

part 'budget_model.g.dart';

@HiveType(typeId: 1)
class BudgetModel extends HiveObject {
  @HiveField(0)
  String category;

  @HiveField(1)
  double limit;

  @HiveField(2)
  double spent;

  @HiveField(3)
  DateTime month; // For monthly tracking

  BudgetModel({
    required this.category,
    required this.limit,
    this.spent = 0.0,
    DateTime? month,
  }) : month = month ?? DateTime(DateTime.now().year, DateTime.now().month);
}

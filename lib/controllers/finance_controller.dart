import 'package:get/get.dart';
import '../services/storage_service.dart';
import '../models/transaction.dart';

class FinanceController extends GetxController {
  final service = Get.find<StorageService>();
  
  late var transactions = <Transaction>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadTransactions();
  }

  void _loadTransactions() {
    final loadedTransactions = service.getTransactions();
    if (loadedTransactions.isNotEmpty) {
      transactions.assignAll(loadedTransactions);
    } else {
      transactions.assignAll([
        Transaction(id: '1', title: 'Groceries', amount: 50.0, category: 'Food'),
        Transaction(id: '2', title: 'Bus Ticket', amount: 5.0, category: 'Transport'),
      ]);
      _saveTransactions();
    }
  }

  void _loadIncomes() {
    // Placeholder for loading incomes if needed
    service.getIncomes();
  }

  void _saveTransactions() {
    service.saveTransactions(transactions);
  }

  double get totalSpent => transactions.where((t) => t.category != 'Income').fold(0, (sum, item) => sum + item.amount);
  double get totalIncome => transactions
      .where((t) => t.category == 'Income')
      .fold(0, (sum, item) => sum + item.amount);

  void addTransaction(Map<String, dynamic> formData) {
    transactions.add(Transaction(
      id: DateTime.now().toString(),
      title: formData['title'],
      amount: double.parse(formData['amount']),
      category: formData['category'],
    ));
    _saveTransactions();
  }

  void addIncome(Map<String, dynamic> formData) {
    transactions.add(Transaction(
      id: DateTime.now().toString(),
      title: formData['title'],
      amount: double.parse(formData['amount']),
      category: 'Income',
    ));
    _saveTransactions();
  }


  void deleteTransaction(String id) {
    transactions.removeWhere((t) => t.id == id);
    _saveTransactions();
  }

  void updateTransaction(String id, Map<String, dynamic> formData) {
    final index = transactions.indexWhere((t) => t.id == id);
    if (index != -1) {
      transactions[index] = Transaction(
        id: id,
        title: formData['title'],
        amount: double.parse(formData['amount']),
        category: formData['category'],
      );
      _saveTransactions();
    }
  }

  double getSpentByCategory(String category) {
    return transactions
        .where((t) => t.category == category)
        .fold(0.0, (sum, item) => sum + item.amount);
  }
}
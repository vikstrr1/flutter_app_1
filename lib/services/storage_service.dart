import 'package:hive_ce/hive.dart';
import '../models/transaction.dart';

class StorageService {
  static const String _transactionsKey = 'transactions';

  Box get storage => Hive.box("storage");

  List<Transaction> getTransactions() {
    try {
      final savedData = storage.get(_transactionsKey);
      if (savedData != null && savedData is List) {
        return (savedData as List)
            .map((item) {
              final map = Map<String, dynamic>.from(item as Map);
              return Transaction.fromJson(map);
            })
            .toList();
      }
      return [];
    } catch (e) {
      print('ERROR loading transactions: $e');
      return [];
    }
  }

  List<Transaction> getIncomes() {
    try {
      final savedData = storage.get(_transactionsKey);
      if (savedData != null && savedData is List) {
        return (savedData as List)
            .map((item) {
              final map = Map<String, dynamic>.from(item as Map);
              return Transaction.fromJson(map);
            })
            .where((t) => t.category == 'Income')
            .toList();
      }
      return [];
    } catch (e) {
      print('ERROR loading incomes: $e');
      return [];
    }
  }

  void saveTransactions(List<Transaction> transactions) {
    try {
      final jsonList = transactions.map((t) => t.toJson()).toList();
      storage.put(_transactionsKey, jsonList);
    } catch (e) {
      print('ERROR saving transactions: $e');
    }
  }


}
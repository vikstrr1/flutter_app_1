import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/finance_controller.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FinanceController>();
    final category = Get.parameters['category'] ?? '';


    return Scaffold(
      appBar: AppBar(title: Text('$category Transactions')),
      body: Obx(() {
        final categoryTransactions = controller.transactions
            .where((t) => t.category == category && t.category != 'Income')
            .toList();
        
        return categoryTransactions.isEmpty
            ? Center(child: Text('No $category transactions'))
            : ListView.builder(
              itemCount: categoryTransactions.length,
              itemBuilder: (context, index) {
                final transaction = categoryTransactions[index];
                return ListTile(
                  title: Text(transaction.title),
                  trailing: Text('€${transaction.amount}'),
                );
              },
            );
      }),
    );
  }
}
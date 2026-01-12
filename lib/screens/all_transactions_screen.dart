import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/finance_controller.dart';

class AllTransactionsScreen extends StatelessWidget {
  const AllTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FinanceController>();

    return Scaffold(
      appBar: AppBar(title: const Text('All Transactions')),
      body: Obx(() => ListView.builder(
        itemCount: controller.transactions.length,
        itemBuilder: (context, index) {
          final transaction = controller.transactions[index];
          return ListTile(
            title: Text(transaction.title),
            subtitle: Text('${transaction.category} - €${transaction.amount}', style: TextStyle(color: transaction.category == 'Income' ? Colors.green : Colors.red)),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => controller.deleteTransaction(transaction.id),
            ),
          );
        },
      )),
    );
  }
}
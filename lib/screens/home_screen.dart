import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/finance_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FinanceController controller = Get.find();
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(title: const Text('My Finances')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isMobile
              ? _buildMobileLayout(controller)
              : _buildTabletLayout(controller),
        ),
      ),
      // RE-ADDED: The + button in the corner
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add'),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Mobile Layout (vertical stacking)
  Widget _buildMobileLayout(FinanceController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildBalanceCard(controller),
        const SizedBox(height: 20),
        _buildTotalSpentCard(controller),
        const SizedBox(height: 20),
        _buildIncomeCard(controller),
        const SizedBox(height: 20),
        _buildSpendingByCategoryCard(controller),
        const SizedBox(height: 20),
        _buildRecentTransactionsCard(controller),
        const SizedBox(height: 20),
        _buildActionButtons(),
      ],
    );
  }

  // Tablet Layout (side-by-side)
  Widget _buildTabletLayout(FinanceController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildBalanceCard(controller),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: _buildTotalSpentCard(controller)),
            const SizedBox(width: 20),
            Expanded(child: _buildIncomeCard(controller)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildSpendingByCategoryCard(controller)),
            const SizedBox(width: 20),
            Expanded(child: _buildRecentTransactionsCard(controller)),
          ],
        ),
        const SizedBox(height: 20),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildBalanceCard(FinanceController controller) {
    return Obx(() {
      final balance = controller.totalIncome - controller.totalSpent;
      final balanceColor = balance >= 0 ? Colors.green : Colors.red;

      return Card(
        color: balanceColor,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text('Current Balance', style: TextStyle(color: Colors.white70)),
              Text(
                '€${balance.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    });
  }

  // Total Spent Card
  Widget _buildTotalSpentCard(FinanceController controller) {
    return Obx(() => Card(
      color: Colors.indigo,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text('Total Spent', style: TextStyle(color: Colors.white70)),
            Text(
              '€${controller.totalSpent.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ));
  }

  // Income Card
  Widget _buildIncomeCard(FinanceController controller) {
    return Obx(() => Card(
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text('Total Income', style: TextStyle(color: Colors.white70)),
            Text(
              '€${controller.totalIncome.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ));  
  }

  // Spending by Category Card
  Widget _buildSpendingByCategoryCard(FinanceController controller) {
    return Obx(() {
      final categories = <String>{};
      for (var transaction in controller.transactions) {
        if (transaction.category != 'Income') {
          categories.add(transaction.category);
        }
      }

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Spending by Category', 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              ...categories.map((category) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(category),
                    Text('€${controller.getSpentByCategory(category).toStringAsFixed(2)}'),
                  ],
                ),
              )),
            ],
          ),
        ),
      );
    });
  }

  // Recent Transactions Card - FIXED FOR PATH VARIABLES
  Widget _buildRecentTransactionsCard(FinanceController controller) {
    return Obx(() => Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Recent Transactions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ...controller.transactions.take(5).map((transaction) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              
              // ADDED: InkWell to make the row clickable for navigation
              child: InkWell(
                onTap: () {
                  // THIS LINE satisfies the "Path Variable" requirement
                  // It navigates to a URL like /edit/12345
                  Get.toNamed('/edit/${transaction.id}');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(transaction.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          transaction.category == 'Income' ?
                          Text(transaction.category, style: const TextStyle(fontSize: 12, color: Colors.green ))
                          : Text(transaction.category, style: const TextStyle(fontSize: 12, color: Colors.red )),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        transaction.category == 'Income' ?
                        Text('+ €${transaction.amount.toStringAsFixed(2)}') : Text('- €${transaction.amount.toStringAsFixed(2)}'),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 18),
                          onPressed: () => _showDeleteDialog(controller, transaction.id),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    ));
  }

  // Action Buttons
  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add New Expense'),
          onPressed: () => Get.toNamed('/add'),
        ),
        const SizedBox(height: 10),
         ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add New Income'),
          onPressed: () => Get.toNamed('/add_income'),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () => Get.toNamed('/all'),
          child: const Text('View All Transactions'),
        ),
      ],
    );
  }

  // Delete confirmation dialog
  void _showDeleteDialog(FinanceController controller, String id) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Transaction?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteTransaction(id);
              Get.back();
              Get.snackbar('Success', 'Transaction deleted');
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
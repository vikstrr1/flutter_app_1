import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../controllers/finance_controller.dart';
import '../models/transaction.dart';

class EditTransactionScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  EditTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FinanceController controller = Get.find();
    
    // 1. SAFE ID RETRIEVAL
    // We get the ID from the URL parameter
    final String? id = Get.parameters['id'];
    
    // CRITICAL FIX: If ID is null, stop immediately. Do not use '!'
    if (id == null || id.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Error: ID is missing")),
      );
    }

    // 2. SAFE TRANSACTION FINDER
    // Use try/catch to find the transaction safely
    Transaction? transaction;
    try {
      transaction = controller.transactions.firstWhere((t) => t.id == id);
    } catch (e) {
      // If not found, transaction stays null
    }

    // If we couldn't find the transaction, show an error page (don't crash)
    if (transaction == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: Center(child: Text("Transaction not found for ID: $id")),
      );
    }

    // 3. DATA SANITIZATION
    // Ensure we have a valid string for the category (never null)
    String safeCategory = transaction.category;
    // If the category somehow came from the database as null/empty, default to 'Other'
    if (safeCategory.isEmpty) { 
      safeCategory = 'Other'; 
    }

    // 4. DROPDOWN PREPARATION
    // Start with your standard list
    List<String> validCategories = ['Income', 'Food', 'Transport', 'Fun', 'Bills', 'Other', 'Shopping'];
    
    // CRITICAL FIX: If the transaction has a category like "Salary" or "Income " (with space),
    // we MUST add it to the list, or the Dropdown will crash.
    if (!validCategories.contains(safeCategory)) {
      validCategories.add(safeCategory);
    }

    // 5. DETERMINE INCOME STATUS
    // We check this to decide if we should lock the dropdown
    bool isIncome = safeCategory == 'Income';

    // Setup text controllers
    final titleController = TextEditingController(text: transaction.title);
    final amountController = TextEditingController(text: transaction.amount.toString());

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Transaction')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                // Title Field
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 16),

                // Category Dropdown (Crash Proof)
                FormBuilderDropdown<String>(
                  name: 'category',
                  initialValue: safeCategory, // Guaranteed to be in the list now
                  enabled: !isIncome,         // Disable if it is Income
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: validCategories
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                ),
                
                const SizedBox(height: 16),
                
                // Amount Field
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 24),
                
                // Save Button
                ElevatedButton(
                  onPressed: () {
                    // Save form state
                    _formKey.currentState?.save();
                    
                    // SAFE CATEGORY FALLBACK
                    // If dropdown is disabled, value might be null. fallback to safeCategory.
                    final formCategory = _formKey.currentState?.value['category'];
                    final finalCategory = formCategory ?? safeCategory;

                    // Prepare the data map
                    final Map<String, dynamic> formData = {
                      'title': titleController.text,
                      'amount': amountController.text, 
                      'category': finalCategory,
                    };

                    // CALL UPDATE (Without using !)
                    controller.updateTransaction(id, formData);
                    
                    Get.back(); 
                    Get.snackbar('Success', 'Transaction updated!');
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
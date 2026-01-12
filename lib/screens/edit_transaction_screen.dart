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
    
    final String? id = Get.parameters['id'];
    
    if (id == null || id.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Error: ID is missing")),
      );
    }

    Transaction? transaction;
    try {
      transaction = controller.transactions.firstWhere((t) => t.id == id);
    } catch (e) {
    }

    if (transaction == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: Center(child: Text("Transaction not found for ID: $id")),
      );
    }

    String safeCategory = transaction.category;
    if (safeCategory.isEmpty) { 
      safeCategory = 'Other'; 
    }
    List<String> validCategories = ['Income', 'Food', 'Transport', 'Fun', 'Bills', 'Other', 'Shopping'];
    
    if (!validCategories.contains(safeCategory)) {
      validCategories.add(safeCategory);
    }


    bool isIncome = safeCategory == 'Income';

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
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 16),

                FormBuilderDropdown<String>(
                  name: 'category',
                  initialValue: safeCategory, 
                  enabled: !isIncome,       
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: validCategories
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                ),
                
                const SizedBox(height: 16),
                

                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () {

                    _formKey.currentState?.save();
                    
                    final formCategory = _formKey.currentState?.value['category'];
                    final finalCategory = formCategory ?? safeCategory;

                    final Map<String, dynamic> formData = {
                      'title': titleController.text,
                      'amount': amountController.text, 
                      'category': finalCategory,
                    };

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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../controllers/finance_controller.dart';

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FinanceController>();
    final formKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'title',
                  decoration: const InputDecoration(labelText: 'What did you buy?'),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 10),
                FormBuilderTextField(
                  name: 'amount',
                  decoration: const InputDecoration(labelText: 'Cost (€)', prefixText: '€ '),
                  keyboardType: TextInputType.number,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.numeric(),
                  ]),
                ),
                const SizedBox(height: 10),
                FormBuilderDropdown<String>(
                  name: 'category',
                  initialValue: 'Food',
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: ['Food', 'Transport', 'Fun', 'Bills', 'Other', 'Shopping']
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.saveAndValidate() ?? false) {
                      controller.addTransaction(formKey.currentState!.value);
                      formKey.currentState?.reset();
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Transaction Added!')),
                      );
                    }
                  },
                  child: const Text('Save Transaction'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
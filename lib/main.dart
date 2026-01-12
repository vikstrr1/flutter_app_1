import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'services/storage_service.dart';
import 'controllers/finance_controller.dart';
import 'widgets/responsive_wrapper.dart';
import 'screens/home_screen.dart';
import 'screens/add_transaction_screen.dart';
import 'screens/all_transactions_screen.dart';
import 'screens/category_screen.dart';
import 'screens/add_income_screen.dart';
import 'screens/edit_transaction_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("storage");
  
  Get.lazyPut<StorageService>(() => StorageService());
  Get.lazyPut<FinanceController>(() => FinanceController());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Finance Tracker',
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const ResponsiveWrapper(child: HomeScreen())),
        GetPage(name: '/add', page: () => const ResponsiveWrapper(child: AddTransactionScreen())),
        GetPage(name: '/all', page: () => const ResponsiveWrapper(child: AllTransactionsScreen())),
        GetPage(name: '/category/:category', page: () => const ResponsiveWrapper(child: CategoryScreen())),
        GetPage(name: '/add_income', page: () => const ResponsiveWrapper(child: AddIncomeScreen())),
        GetPage(name: '/edit/:id', page: () => ResponsiveWrapper(child: EditTransactionScreen())),
      ],
    );
  }
}
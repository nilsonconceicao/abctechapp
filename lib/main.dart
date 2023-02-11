import 'package:abc_tech_app/pages/home_bind.dart';
import 'package:abc_tech_app/pages/home_page.dart';
import 'package:abc_tech_app/pages/order_bind.dart';
import 'package:abc_tech_app/pages/order_page.dart';
import 'package:abc_tech_app/provider/assist_provider.dart';
import 'package:abc_tech_app/service/assist_service.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';

void main() {
  initService();
  runApp(const MyApp());
}

void initService() async {
  await Get.putAsync(() => AssistService().init(AssistProvider()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: const TextTheme(
            headlineMedium:
                TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        primarySwatch: Colors.blue,
      ),
      getPages: [
        GetPage(name: "/", page: () => OrderParge(), binding: OrderBind()),
        GetPage(
            name: "/assists", page: () => const HomePage(), binding: HomeBind())
      ],
    );
  }
}

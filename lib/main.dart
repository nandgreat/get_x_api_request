import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_x_api_request/bindings/initial_bindings.dart';
import 'package:get_x_api_request/routes/app_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      initialBinding: InitialBindings(),
      initialRoute: Routes.posts,
      getPages: AppPages.pages,
    );
  }
}

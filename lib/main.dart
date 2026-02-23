import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanagementflutter/controllers/auth_controller.dart';
import 'package:taskmanagementflutter/controllers/task_controller.dart';
import 'package:taskmanagementflutter/core/stoarge_service.dart';
import 'package:taskmanagementflutter/ui/register_page.dart';
import 'ui/login_page.dart';
import 'ui/task_list_page.dart';
import 'ui/task_detail_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("tasksBox");
  await Hive.openBox("syncQueueBox");
  Get.put(AuthController());
  Get.put(TaskController());
  bool loggedIn = await SessionService.isLoggedIn();
  runApp(MyApp(loggedIn));
}

class MyApp extends StatelessWidget {
  final bool loggedIn;
  const MyApp(this.loggedIn, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: loggedIn ? "/tasks" : "/login",
      getPages: [
        GetPage(name: "/login", page: ()=> LoginPage()),
        GetPage(name: "/register", page: ()=> RegisterPage()),
        GetPage(name: "/tasks", page: ()=> TaskListPage()),
        GetPage(name: "/detail", page: ()=> TaskDetailPage()),
      ],
    );
  }
}
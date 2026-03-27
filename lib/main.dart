import 'package:campusflow/views/admin/admin_dashboard.dart';
import 'package:campusflow/views/admin/admin_home.dart';
import 'package:campusflow/views/faculty/faculty_home.dart';
import 'package:campusflow/views/student/student_dashboard.dart';
import 'package:campusflow/views/student/student_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'controllers/admin_controller.dart';
import 'controllers/faculty_controller.dart';
import 'controllers/student_controller.dart';
import 'utils/app_colors.dart';
import 'utils/app_size.dart';
import 'views/login/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdminController()),
        ChangeNotifierProvider(create: (_) => FacultyController()),
        ChangeNotifierProvider(create: (_) => StudentController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Inter',
      ),
      home: Builder(
        builder: (context) {
          AppSize.init(context);
          return const AdminHome();
        },
      ),
    );
  }
}

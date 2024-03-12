import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rec_ecommerce/core/design/shared/app_theme.dart';
import 'package:rec_ecommerce/features/home/pages/home_page.dart';
import 'package:rec_ecommerce/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: ScreenUtilInit(
        designSize: const Size(360, 640),
        child: MaterialApp(
          title: 'Rec_ecommerce',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: HomePage(),
        ),
      ),
    );
  }
}

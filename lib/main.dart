import 'package:ecommerce_app/core/styling/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'core/local_storage/prefs_provider.dart';
// ignore: library_prefixes
import 'core/routing/router_generation_config.dart' as RouterGenerationConfig; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  
  // 1. Wake up SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      // 2. Inject SharedPreferences into Riverpod globally
      overrides: [
        sharedPrefsProvider.overrideWithValue(sharedPreferences),
      ],
      // 3. Pass it down to MyApp
      child: MyApp(prefs: sharedPreferences), 
    ),
  );
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'E-Commerce App',
          theme: AppThemes.lightTheme,
          
          // 4. Pass the prefs into the Router!
          routerConfig: RouterGenerationConfig.getRouter(prefs), 
          
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: widget!,
            );
          },
        );
      },
    );
  }
}
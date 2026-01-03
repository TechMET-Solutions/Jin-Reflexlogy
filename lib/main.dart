import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:jin_reflex_new/api_service/preference/app_preference.dart';
import 'package:jin_reflex_new/splash_screen.dart';

// Global RouteObserver
final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
await AppPreference().initialAppPreference();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'JIN Reflexology',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:SplashScreen(),
    );
  }
}


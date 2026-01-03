import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/dashbard_screen.dart';
import 'package:jin_reflex_new/login_screen.dart';
import 'package:jin_reflex_new/screens/Diagnosis/diagnosis_screen_list.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LifestyleScreen extends StatefulWidget {
  const LifestyleScreen({super.key});

  @override
  State<LifestyleScreen> createState() => _LifestyleScreenState();
}

class _LifestyleScreenState extends State<LifestyleScreen> {
  late WebViewController controller;
  String patientId = "";

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      // WebView.platform = AndroidWebView();
    }

    loadWebview();
  }

  Future<void> loadWebview() async {
    String url =
        "https://jinreflexology.in/api1/new/patient_lifestyle.php?id=${AppPreference().getString(PreferencesKey.userId)}";
    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.white)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (url) {
                print("Loaded: $url");
              },
            ),
          )
          ..loadRequest(Uri.parse(url));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final token = AppPreference().getString(PreferencesKey.token);
    final type = AppPreference().getString(PreferencesKey.type);
    print("DEBUG TYPE => '$type'");
    print("DEBUG TOKEN => '$token'");
    print("DEBUG isEmpty => ${token.isEmpty}");
    return Scaffold(
      appBar: CommonAppBar(
        title: "Lifestyle",
        onBack: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
      ),
      body:
          type == "therapist" || token.isEmpty
              ? JinLoginScreen(
                text: "LifestyleScreen",
                type: "patient",
                onTab: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LifestyleScreen()),
                  );
                },
              )
              : patientId.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : WebViewWidget(controller: controller),
    );
  }
}

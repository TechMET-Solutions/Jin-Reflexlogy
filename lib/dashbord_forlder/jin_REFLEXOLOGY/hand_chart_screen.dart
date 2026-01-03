import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class HandChartScreen extends StatefulWidget {
  const HandChartScreen({super.key});

  @override
  State<HandChartScreen> createState() => _HandChartScreenState();
}

class _HandChartScreenState extends State<HandChartScreen> {
  late WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Enable Android WebView debugging for better error handling
    if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      AndroidWebViewController.enableDebugging(true);
    }

    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (String url) {
                setState(() {
                  isLoading = false;
                });
              },
              onWebResourceError: (WebResourceError error) {
                debugPrint('WebView error: ${error.description}');
                setState(() {
                  isLoading = false;
                });
              },
              onNavigationRequest: (NavigationRequest request) {
                // Allow navigation to local asset files and foot-chart navigation
                if (request.url.startsWith('file://') ||
                    request.url.contains('assets') ||
                    request.url.contains('hand-chart')) {
                  return NavigationDecision.navigate;
                }
                return NavigationDecision.prevent;
              },
            ),
          )
          ..loadFlutterAsset("assets/hand-chart.html");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hand Chart")),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            Container(
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

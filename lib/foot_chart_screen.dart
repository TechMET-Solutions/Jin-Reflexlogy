import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FootChartScreen extends StatefulWidget {
  const FootChartScreen({super.key});

  @override
  State<FootChartScreen> createState() => _FootChartScreenState();
}

class _FootChartScreenState extends State<FootChartScreen> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadFlutterAsset("assets/foot-chart.html"); // FINAL WORKING PATH
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Foot Chart")),
      body: WebViewWidget(controller: controller),
    );
  }
}

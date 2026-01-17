import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HandChartScreen extends StatefulWidget {
  const HandChartScreen({super.key});

  @override
  State<HandChartScreen> createState() => _HandChartScreenState();
}

class _HandChartScreenState extends State<HandChartScreen> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..loadFlutterAsset("assets/hand-chart.html");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Hand Chart"),
      body: WebViewWidget(controller: controller),
    );
  }
}

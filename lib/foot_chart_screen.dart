import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;


class FootChartScreen extends StatefulWidget {
  const FootChartScreen({super.key});

  @override
  State<FootChartScreen> createState() => _FootChartScreenState();
}

class _FootChartScreenState extends State<FootChartScreen> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    _loadLocalHtml();
  }

  Future<void> _loadLocalHtml() async {
    String fileHtmlContents = await rootBundle.loadString('assets/foot-chart.html');
    _controller.loadHtmlString(fileHtmlContents);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CommonAppBar(title: 'Foot Chart'),
      body: WebViewWidget(controller: _controller),
    );
  }
}

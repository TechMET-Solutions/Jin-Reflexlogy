import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommonWebView extends StatefulWidget {
  final String url; 
  final title;

  const CommonWebView({Key? key, required this.url,required this.title}) : super(key: key);

  @override
  State<CommonWebView> createState() => _CommonWebViewState();
}

class _CommonWebViewState extends State<CommonWebView> {
  late WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "${widget.title}"),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),

          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewTreatment extends StatefulWidget {
  final String patientId;
  final String diagnosisId;

  const NewTreatment({
    super.key,
    required this.patientId,
    required this.diagnosisId,
  });


  @override
  State<NewTreatment> createState() => _NewTreatmentState();
}

class _NewTreatmentState extends State<NewTreatment> {
  late WebViewController webController;
  bool isPageLoading = true; // 👈 loader flag

  @override
  void initState() {
    super.initState();

    webController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (url) {
                setState(() => isPageLoading = true);
              },
              onPageFinished: (url) {
                setState(() => isPageLoading = false);
              },
              onWebResourceError: (error) {
                setState(() => isPageLoading = false);
              },
            ),
          )
          ..loadRequest(
            Uri.parse(
              "https://jinreflexology.in/api1/new/patient_lifestyle_therapist.php"
              "?id=${widget.patientId}&diagnosisId=${widget.diagnosisId}",
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Treatment"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Stack(
        children: [
          // -------- WEBVIEW --------
          WebViewWidget(controller: webController),

          // -------- LOADER --------
          if (isPageLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.redAccent),
              ),
            ),
        ],
      ),
    );
  }
}
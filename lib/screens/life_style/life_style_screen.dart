import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/dashbard_screen.dart';
import 'package:jin_reflex_new/login_screen.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LifestyleScreen extends StatefulWidget {
  final String? patientId; // Optional patient ID parameter
  
  const LifestyleScreen({super.key, this.patientId});

  @override
  State<LifestyleScreen> createState() => _LifestyleScreenState();
}

class _LifestyleScreenState extends State<LifestyleScreen> {
  late WebViewController controller;
  bool isLoading = true;
  double progress = 0;

@override
void initState() {
  super.initState();
  
  // Platform initialization for WebView
  _initPlatformSettings();
  
  _initWebView();
}

void _initPlatformSettings() {
  // For Android
  if (Platform.isAndroid) {
    // Android specific settings
    // No need to set WebView.platform explicitly in newer versions
  }
  
  // For iOS
  if (Platform.isIOS) {
    // iOS specific settings
  }
}
  Future<void> _initWebView() async {
    try {
      // Get patient ID from parameter or preferences
      String patientId = widget.patientId ?? await _getPatientId();
      
      print("🟢 Loading WebView for patient ID: $patientId");
      
      // Create platform specific controller
      late final PlatformWebViewControllerCreationParams params;
      
      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
      } else {
        params = const PlatformWebViewControllerCreationParams();
      }

      final webViewController = WebViewController.fromPlatformCreationParams(params);

      // Platform specific configurations
      if (webViewController.platform is AndroidWebViewController) {
        AndroidWebViewController.enableDebugging(true);
        (webViewController.platform as AndroidWebViewController)
            .setMediaPlaybackRequiresUserGesture(false);
      }

      // Setup controller
      controller = webViewController
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              print("Loading progress: $progress%");
              setState(() {
                this.progress = progress / 100;
              });
            },
            onPageStarted: (String url) {
              print("Page started loading: $url");
              setState(() {
                isLoading = true;
              });
            },
            onPageFinished: (String url) {
              print("Page finished loading: $url");
              setState(() {
                isLoading = false;
              });
            },
            onWebResourceError: (WebResourceError error) {
              print("WebResourceError: ${error.errorCode} - ${error.description}");
              print("Error URL: ${error.url}");
              print("Error Type: ${error.errorType}");
              setState(() {
                isLoading = false;
              });
            },
            onNavigationRequest: (NavigationRequest request) {
              print("Navigation request: ${request.url}");
              return NavigationDecision.navigate;
            },
            onUrlChange: (UrlChange change) {
              print("URL changed: ${change.url}");
            },
          ),
        )
        ..addJavaScriptChannel(
          'Flutter',
          onMessageReceived: (JavaScriptMessage message) {
            print("JavaScript message: ${message.message}");
          },
        );

      // Load URL
      String url = "https://jinreflexology.in/api1/new/patient_lifestyle.php?id=${AppPreference().getString(PreferencesKey.userId)}";
      print("🔗 Loading URL: $url");
      
      await controller.loadRequest(
        Uri.parse(url),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36',
          'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
          'Accept-Language': 'en-US,en;q=0.9',
        },
      );

      setState(() {});
      
    } catch (e, stackTrace) {
      print("❌ Error initializing WebView: $e");
      print("Stack trace: $stackTrace");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String> _getPatientId() async {
    // Try to get patient ID from multiple sources
    try {
      // First try from route arguments
      final routeArgs = ModalRoute.of(context)?.settings.arguments;
      if (routeArgs is String) {
        return routeArgs;
      } else if (routeArgs is Map) {
        return routeArgs['patientId']?.toString() ?? '';
      }
      
      // Then try from preferences
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('patientId') ?? '1059'; // Default fallback
    } catch (e) {
      return '1059'; // Default fallback
    }
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
      body: type == "therapist" || type == "prouser"|| type == "user"|| token.isEmpty
          ? JinLoginScreen(
              text: "LifestyleScreen",
              type: "patient",
              // registershow: true,
              onTab: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LifestyleScreen()),
                );
              },
            )
          : Stack(
              children: [
                WebViewWidget(controller: controller),
                
                // Loading indicator
                if (isLoading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.white.withOpacity(0.8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Loading... ${(progress * 100).toStringAsFixed(0)}%",
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                // Error/Reload button
                if (!isLoading && progress == 0)
                  Positioned.fill(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 64,
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Failed to load content",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Please check your internet connection",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                          SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                                progress = 0;
                              });
                              _initWebView();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            ),
                            child: Text(
                              "Reload",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
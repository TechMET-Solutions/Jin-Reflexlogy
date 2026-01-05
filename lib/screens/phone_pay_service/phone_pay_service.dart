import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class PhonePePaymentService {
  // Configuration
  static const String merchantId = 'YOUR_MERCHANT_ID';
  static const String saltKey = 'YOUR_SALT_KEY';
  static const String saltIndex = '1';
  static String flowId = 'UNIQUE_USER_ID'; // User ID or unique identifier
  
  // Environment
  static String environment = 'SANDBOX'; // Change to 'PRODUCTION' for live
  static String packageName = "com.phonepe.simulator";
  
  // App Schema
  static const String appSchema = "yourAppScheme"; // Change to your app scheme
  
  // Initialize SDK
  static Future<bool> initSDK() async {
    try {
      bool isInitialized = await PhonePePaymentSdk.init(
        environment,
        merchantId,
        flowId,
        true, // enableLogs
      );
      
      if (environment == 'PRODUCTION') {
        packageName = "com.phonepe.app";
      }
      
      print('PhonePe SDK Initialized: $isInitialized');
      return isInitialized;
    } catch (e) {
      print('Error initializing SDK: $e');
      return false;
    }
  }

  // Generate transaction ID
  static String generateTransactionId() {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return 'TXN${DateTime.now().millisecondsSinceEpoch}${List.generate(6, (index) => chars[random.nextInt(chars.length)]).join()}';
  }

  // Generate checksum
  static String generateXVerify(String base64Payload, String apiEndpoint) {
    final String data = base64Payload + apiEndpoint + saltKey;
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return '${digest.toString()}###$saltIndex';
  }

  // Create payment request
  static Future<Map<String, dynamic>> createPayment({
    required double amount,
    required String mobileNumber,
    required String userId,
    required String callbackUrl,
    String? transactionId,
  }) async {
    try {
      transactionId ??= generateTransactionId();
      flowId = userId; // Update flowId with current user
      
      // Create payload
      final payload = {
        "merchantId": merchantId,
        "merchantTransactionId": transactionId,
        "merchantUserId": userId,
        "amount": (amount * 100).toInt(), // Convert to paise
        "redirectUrl": callbackUrl,
        "redirectMode": "REDIRECT",
        "callbackUrl": callbackUrl,
        "mobileNumber": mobileNumber,
        "paymentInstrument": {
          "type": "PAY_PAGE"
        }
      };

      // Encode payload
      final String base64Payload = base64.encode(utf8.encode(json.encode(payload)));
      final String apiEndpoint = '/pg/v1/pay';
      final String xVerify = generateXVerify(base64Payload, apiEndpoint);
      
      // For SDK startTransaction
      final request = json.encode({
        'request': base64Payload,
      });

      return {
        'success': true,
        'transactionId': transactionId,
        'request': request,
        'xVerify': xVerify,
        'base64Payload': base64Payload,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Start payment transaction
  static Future<Map<String, dynamic>> startPayment({
    required String request,
  }) async {
    try {
      final response = await PhonePePaymentSdk.startTransaction(
        request,
        appSchema,
      );
      
      return {
        'success': true,
        'response': response,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Check payment status
  static Future<Map<String, dynamic>> checkPaymentStatus(String transactionId) async {
    try {
      final String apiEndpoint = '/pg/v1/status/$merchantId/$transactionId';
      final String data = '/pg/v1/status/$merchantId/$transactionId$saltKey';
      
      final bytes = utf8.encode(data);
      final digest = sha256.convert(bytes);
      final xVerify = '${digest.toString()}###$saltIndex';

      final baseUrl = environment == 'PRODUCTION' 
          ? 'https://api.phonepe.com/apis/hermes'
          : 'https://api-preprod.phonepe.com/apis/pg-sandbox';

      final response = await http.get(
        Uri.parse('$baseUrl$apiEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          'X-VERIFY': xVerify,
          'X-MERCHANT-ID': merchantId,
          'accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final success = responseData['success'] == true;
        final code = responseData['code'];
        
        return {
          'success': success,
          'data': responseData,
          'status': success ? 'SUCCESS' : 'FAILED',
          'code': code,
          'message': _getStatusMessage(code),
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to check status',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  // Get installed UPI apps
  static Future<List<dynamic>> getInstalledUpiApps() async {
    try {
      if (Platform.isAndroid) {
        final apps = await PhonePePaymentSdk.getUpiAppsForAndroid();
        if (apps != null) {
          final List<dynamic> parsedApps = json.decode(apps);
          return parsedApps;
        }
      } else {
        final apps = await PhonePePaymentSdk.getInstalledUpiAppsForiOS();
        return apps ?? [];
      }
      return [];
    } catch (e) {
      print('Error getting UPI apps: $e');
      return [];
    }
  }

  // Helper method for status messages
  static String _getStatusMessage(String code) {
    final messages = {
      'PAYMENT_SUCCESS': 'Payment Successful!',
      'PAYMENT_ERROR': 'Payment Error',
      'PAYMENT_PENDING': 'Payment Pending',
      'PAYMENT_DECLINED': 'Payment Declined',
      'TIMED_OUT': 'Payment Timed Out',
      'USER_DROPPED': 'User Cancelled Payment',
      'AUTHORIZATION_FAILED': 'Authorization Failed',
      'AUTHENTICATION_FAILED': 'Authentication Failed',
      'ACTIVITY_NOT_FOUND': 'PhonePe App Not Found',
      'INTENT_NOT_RESOLVED': 'Intent Not Resolved',
    };
    return messages[code] ?? 'Unknown Status: $code';
  }
}
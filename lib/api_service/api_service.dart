import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:jin_reflex_new/api_service/global/utils.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/api_service/urls.dart';



class ApiService {
String? tokens = AppPreference().getString(PreferencesKey.token);
final Dio _dio = Dio(
  BaseOptions(
    baseUrl: baseUrl, 
    connectTimeout:  Duration(seconds: 10),
    receiveTimeout:  Duration(seconds: 40),
    headers: {
      'Content-Type': 'application/json',
      // if(AppPreference().getString(PreferencesKey.status).isNotEmpty)
       'Authorization': 'Bearer ${AppPreference().getString(PreferencesKey.token).toString()}', // Avoids null and removes the extra }
    },
  ),
);


  Future<Response?> getRequest(String endpoint, {Map<String, dynamic>? queryParams}) async {
   log('${endpoint}');
    try {
      return await _dio.get(endpoint, queryParameters: queryParams,);
    } on DioError catch (e) {
      _handleDioError(e);
       //Utils().showToastMessage("$e");
      return null;
    } catch (e) {
      print("Unexpected error: $e");
      return null;
    }
  }


Future<Response?> postRequest(String endpoint, dynamic data) async {
  log("Request Dataddd: $data");
  log("Requestsss Data: $endpoint");
  try {
    final response = await _dio.post(endpoint, data: data, options: Options(
       headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'POST, GET, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type, Authorization',
           'Authorization': 'Bearer ${AppPreference().getString(PreferencesKey.token).toString()}', // Avoids null and removes the extra }
        },
    ));
   // log("Response: ${response.data}");
    return response;
  } on DioError catch (e) {
    print("DioError Type: ${e.type}");
    print("DioError Message: ${e.message}");
    print("DioError Response: ${e.response}");
    print("DioError Request: ${e.requestOptions}");
    _handleDioError(e);
    return null;
  } catch (e) {
    print("Unexpected error: $e");
    return null;
  }
}


  Future<Response?> putRequest(String endpoint, dynamic data) async {
    try {
      return await _dio.put(endpoint, data: data);
    } on DioError catch (e) {
     // _handleDioError(e);
      print(e);
      print("data");
      return null;
    } catch (e) {
      print("Unexpected error: $e");
      return null;
    }
  }

  Future<Response?> deleteRequest(String endpoint) async {
    try {
      return await _dio.delete(endpoint);
    } on DioError catch (e) {
      _handleDioError(e);
      return null;
    } catch (e) {
      print("Unexpected error: $e");
      return null;
    }
  }


  void _handleDioError(DioError error) {
    if (error.response != null) {
      switch (error.response?.statusCode) {
        case 400:
          print("${error.response?.data['message']}");
            Utils().showToastMessage("${error.response?.data['message']}");
          break;
        case 401:
             Utils().showToastMessage("${error.response?.data['message']}");
          break;
        case 403:
            Utils().showToastMessage("${error.response?.data['message']}");
          break;
        case 404:
           Utils().showToastMessage("${error.response?.data['message']}");
          break;
        case 500:
           Utils().showToastMessage(error.response?.data['message']);
          break;
        default:
            Utils().showToastMessage("${error.response?.data['message']}");
          break;
      }
    } else {
      switch (error.type) {
        case DioErrorType.connectionTimeout:
          print("Connection timeout occurred.");
              Utils().showToastMessage("Connection timeout occurred.");
          break;
        case DioErrorType.receiveTimeout:
          print("Receive timeout occurred.");
           Utils().showToastMessage("Receive timeout occurred.");
          break;
        case DioErrorType.sendTimeout:
          print("Send timeout occurred.");
           Utils().showToastMessage("Send timeout occurred.");
          break;
        case DioErrorType.cancel:
          print("Request was cancelled.");
           Utils().showToastMessage("Request was cancelled.");
          break;
        case DioErrorType.unknown:
          if (error.error is SocketException) {
            print("No Internet connection. Please check your network.");
             Utils().showToastMessage("No Internet connection. Please check your network.");
          } else {
            print("Unexpected error: ${error.message}");
              Utils().showToastMessage("Unexpected error: ${error.message}");
            
          }
          break;
        default:
          print("Unknown DioError: ${error.message}");
             Utils().showToastMessage("Unknown DioError: ${error.message}");
          break;
      }
    }
  }
}

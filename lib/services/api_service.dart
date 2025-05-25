import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:login_ui/pages/Bill/bill_payment.dart';
import '../models/payment_dto.dart';
import '../services/payment_service.dart';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiService {
  final Dio _dio = Dio();
  static const String _baseUrl =
      'https://water-monitoring-api-k06t.onrender.com/'; // Change this to your base URL
  // 'https://water-monitoring-api-k06t.onrender.com/';

  ApiService() {
    _dio.options = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
      responseType: ResponseType.json,
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Check connectivity
        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          return handler.reject(
            DioException(
              requestOptions: options,
              error: 'No internet connection',
              type: DioExceptionType.connectionError,
            ),
          );
        }

        // Add auth token if exists
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        print('REQUEST[${options.method}] => PATH: ${options.path}');
        print('REQUEST HEADERS => ${options.headers}');
        if (options.data != null) {
          print('REQUEST BODY => ${options.data}');
        }

        return handler.next(options);
      },
      onResponse: (response, handler) {
        print(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
        print('RESPONSE DATA => ${response.data}');
        return handler.next(response);
      },
      onError: (DioException error, handler) async {
        print(
            'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
        print('ERROR MESSAGE => ${error.message}');

        // Handle token expiration (401)
        if (error.response?.statusCode == 401) {
          // Optionally: Implement token refresh logic here
          return handler.reject(error);
        }

        return handler.next(error);
      },
    ));
  }

  // Auth Methods
  Future<Response> login(String email, String password) async {
    try {
      final response = await _dio.post('auth/login', data: {
        'phoneOrEmail': email,
        'password': password,
        'isPhone': false,
        'role': "CUSTOMER"
      });

      if (response.statusCode == 200) {
        await _saveToken(response.data['authToken.accessToken']);
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // in api_service.dart
  Future<void> toggleValve({
    required bool status,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      final userJson =
          prefs.getString('user'); // Make sure to store this during login
      if (userJson != null) {
        final decodedUser = json.decode(userJson) as Map<String, dynamic>;
        final deviceId = decodedUser['deviceId']
            ?.toString(); // Ensure uuid is treated as string

        // Set headers
        final headers = {
          'Authorization': token, // Add token to headers
          "Content-Type": "application/json",
          "Accept": "application/json",
        };
        final response = await _dio.patch(
          'sensor/valvechange',
          options: Options(headers: headers), // Pass headers in options

          data: {
            'status': status,
            'deviceId': deviceId,
          },
        );
        if (response.statusCode != 200) {
          throw DioException(
            requestOptions: response.requestOptions,
            error: 'Valve change failed',
            response: response,
            type: DioExceptionType.badResponse,
          );
        }
      }
    } catch (e) {
      // Handle any exceptions that occur
      rethrow;
    }
  }

  // in api_service.dart
  Future<BillingInfo> getPaymentInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      final userJson = prefs.getString('user');

      if (userJson == null || token == null) {
        throw Exception('User or token information missing. Please log in.');
      }

      final decodedUser = json.decode(userJson) as Map<String, dynamic>;
      final uuid = decodedUser['uuid']?.toString();

      if (uuid == null) {
        throw Exception('User UUID is missing.');
      }

      final headers = {
        'Authorization': token,
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

      final response = await _dio.get(
        'payment/info/$uuid',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        print(response.data);
        if (response.data['ok'] == true && response.data['val'] != null) {
          return BillingInfo.fromJson(response.data['val']);
        } else if (response.data['ok'] == false &&
            response.data['code'] == 404) {
          var date = DateTime.now();
          return BillingInfo(
              status: 'paid',
              uuid: '',
              userId: '',
              dueDate: date,
              amount: 0,
              breakdown: []);
        } else {
          throw Exception(
              'API response indicates an error or missing data: ${response.data['error'] ?? 'No error message'}');
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          error: 'Failed to get payment info: ${response.statusCode}',
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('Dio error getting payment info: $e');
      if (e.response != null) {
        print('Error response data: ${e.response!.data}');
        throw Exception(
            'Failed to load billing information: ${e.response!.data['error'] ?? 'Server error'}');
      }
      throw Exception('Failed to load billing information: ${e.message}');
    } catch (e) {
      print('Unexpected error getting payment info: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // in api_service.dart
  Future<List<dynamic>?> getPaymentHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      final userJson = prefs.getString('user');

      if (userJson == null || token == null) {
        throw Exception('User or token information missing. Please log in.');
      }

      final decodedUser = json.decode(userJson) as Map<String, dynamic>;
      final id = decodedUser['_id']?.toString();

      if (id == null) {
        throw Exception('User UUID is missing.');
      }

      final headers = {
        'Authorization': token,
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

      final response = await _dio.get(
        'payment/history/$id',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        if (response.data['ok'] == true && response.data['val'] != null) {
          return response.data['val'];
        } else {
          throw Exception(
              'API response indicates an error or missing data: ${response.data['error'] ?? 'No error message'}');
        }
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          error: 'Failed to get payment info: ${response.statusCode}',
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException catch (e) {
      print('Dio error getting payment info: $e');
      if (e.response != null) {
        print('Error response data: ${e.response!.data}');
        throw Exception(
            'Failed to load billing information: ${e.response!.data['error'] ?? 'Server error'}');
      }
      throw Exception('Failed to load billing information: ${e.message}');
    } catch (e) {
      print('Unexpected error getting payment info: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // get ticket info
  Future<Response> getSupportTickets() async {
    try {
      // Get auth token from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      // Set headers
      final headers = {
        'Authorization': token, // Add token to headers
        "Content-Type": "application/json",
        "Accept": "application/json",
      };
      final userJson =
          prefs.getString('user'); // Make sure to store this during login

      final decodedUser = json.decode(userJson!) as Map<String, dynamic>;
      final userId =
          decodedUser['_id']?.toString(); // Ensure uuid is treated as string

      // Make GET request to tickets endpoint
      return await _dio.get(
        'ticket?userId=$userId',
        options: Options(headers: headers), // Pass headers in options
      );
    } catch (e) {
      rethrow;
    }
  }

  // Get notifications
  Future<Response> getNotifications() async {
    try {
      // Get auth token from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      // Set headers
      final headers = {
        'Authorization': token,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      final userJson =
          prefs.getString('user'); // Make sure to store this during login

      final decodedUser = json.decode(userJson!) as Map<String, dynamic>;
      final userId =
          decodedUser['_id']?.toString(); // Ensure uuid is treated as string


      // Make GET request to notifications endpoint
      return await _dio.get(
        'notification?userId=$userId&limit=10&page=1&sort=createdAt&sortOrder=-1', // adjust the endpoint if needed
        options: Options(headers: headers),
      );
    } catch (e) {
      rethrow;
    }
  }

  // In ApiService.dart
  Future<Object> createSupportTicket({
    required String description,
    required String type,
  }) async {
    try {
      // Get user ID from shared preferences if you store it during login
      final prefs = await SharedPreferences.getInstance();
      final userJson =
          prefs.getString('user'); // Make sure to store this during login
      final token = prefs.getString('accessToken'); // Retrieve auth token
      if (userJson != null) {
        final decodedUser = json.decode(userJson) as Map<String, dynamic>;
        final userId =
            decodedUser['_id']?.toString(); // Ensure uuid is treated as string

        final headers = {
          'Authorization': token, // Add token to headers
          "Content-Type": "application/json",
          "Accept": "application/json",
        };
        print(headers);
        return await _dio.post(
          'ticket',
          data: {
            'description': description,
            'userId': userId ?? '', // Fallback to empty string if null
            'technicianId': '', // Can be left empty initially
            'type': type
                .toUpperCase()
                .replaceAll(' ', '_'), // Convert to enum format
            'status': 'Pending'
          },
          options: Options(headers: headers), // Pass headers in options
        );
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<Object> forgotPassword({
    required String email,
  }) async {
    try {
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };
      return await _dio.post(
        'auth/forgotPassword',
        data: {
          'email': email,
        },
        options: Options(headers: headers), // Pass headers in options
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Object> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };
      return await _dio.post(
        'auth/resetPassword',
        data: {
          "emailOrUserName": email,
          "code": code,
          "newPassword": newPassword,
          "resetAllSessions": true
        },
        options: Options(headers: headers), // Pass headers in options
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Object> activatePassword({
    required String email,
    required String code,
  }) async {
    try {
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };
      return await _dio.post(
        'auth/activate',
        data: {
          "phoneOrEmail": email,
          "code": code,
        },
        options: Options(headers: headers), // Pass headers in options
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Object> changePassword({
    required String oldPassword,
    required String newPassword,
    required String role,
  }) async {
    try {
      // Get user ID from shared preferences if you store it during login
      final prefs = await SharedPreferences.getInstance();
      final userJson =
          prefs.getString('user'); // Make sure to store this during login
      final token = prefs.getString('accessToken'); // Retrieve auth token
      if (token != null) {
        final headers = {
          'Authorization': token, // Add token to headers
          "Content-Type": "application/json",
          "Accept": "application/json",
        };
        print(headers);
        return await _dio.post(
          'auth/changePassword',
          data: {
            "oldPassword": oldPassword,
            "newPassword": newPassword,
            "role": role
          },
          options: Options(headers: headers), // Pass headers in options
        );
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // CRUD Methods
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    return await _dio.get(
      path,
      queryParameters: queryParams,
    );
  }

  Future<Response> post(String path, dynamic data) async {
    return await _dio.post(path, data: data);
  }

  Future<Response> put(String path, dynamic data) async {
    return await _dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }

  // File Upload
  Future<Response> uploadFile(String path, String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    return await _dio.post(path, data: formData);
  }

  // Error Handling
  static String handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.sendTimeout:
        return 'Send timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.badCertificate:
        return 'Bad certificate';
      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response);
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      case DioExceptionType.unknown:
        return 'Unknown error occurred';
    }
  }

  static String _handleStatusCode(Response? response) {
    switch (response?.statusCode) {
      case 400:
        return response?.data['message'] ?? 'Bad request';
      case 401:
        return 'Unauthorized - Please login again';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Resource not found';
      case 500:
        return 'Internal server error';
      default:
        return 'Something went wrong';
    }
  }
}

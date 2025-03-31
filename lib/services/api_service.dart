import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ApiService {
  final Dio _dio = Dio();
  static const String _baseUrl ='http://localhost:3001/'; // Change this to your base URL
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

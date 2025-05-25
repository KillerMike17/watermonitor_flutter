import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/payment_dto.dart';

class PaymentApiService {
  static const String baseUrl = 'https://water-monitoring-api-k06t.onrender.com';

  // Initiate Chapa Payment
  static Future<String?> initiateChapaPayment(PaymentDto dto, String token) async {
    final url = Uri.parse('$baseUrl/payment/chapa');

    final body = jsonEncode(dto.toJson());
    print('[DEBUG] InitiateChapaPayment payload: $body');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
        body: body,
      );

      print('[DEBUG] Response status: ${response.statusCode}');
      print('[DEBUG] Response body: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final checkoutUrl = data['checkout_url'];
        if (checkoutUrl != null && checkoutUrl is String && checkoutUrl.isNotEmpty) {
          return checkoutUrl;
        } else {
          print('[ERROR] checkout_url is null or invalid in response');
          return null;
        }
      } else {
        print('[ERROR] Payment initiation failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('[ERROR] Exception in payment initiation: $e');
      return null;
    }
  }
}
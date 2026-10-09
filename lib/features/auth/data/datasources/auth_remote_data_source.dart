import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mr_market/features/auth/data/models/verify_otp_response.dart';

class AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSource({required this.client});

  Future<void> sendOtp(String mobileNumber) async {
    final uri = Uri.parse(
      'https://api.didebanhooshmand.ir/api/TemproryCode/sendtemprorycode',
    ).replace(queryParameters: {'mobilenumber': mobileNumber});

    print('REQUEST URL: $uri');

    final response = await client.get(
      uri,
      headers: {'Accept': 'application/json'},
    );

    print('STATUS CODE: ${response.statusCode}');
    print('RESPONSE BODY: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('API Error: ${response.statusCode}');
    }
  }

  Future<VerifyOtpResponse> verifyOtp({
    required String mobileNumber,
    required String otp,
  }) async {
    final uri =
        Uri.parse(
          'https://api.didebanhooshmand.ir/api/TemproryCode/validatetemprorycode',
        ).replace(
          queryParameters: {
            'MobileNumber': mobileNumber,
            'UserName': 'DidebanHooshmandMehraban',
            'PassWord': 'YOUR_PASSWORD',
            'TemproryCode': otp,
            'TokenNotification': '12345678',
          },
        );

    final response = await client.get(
      uri,
      headers: {'Accept': 'application/json'},
    );

    print('VERIFY OTP URL: $uri');
    print('VERIFY OTP STATUS: ${response.statusCode}');
    print('VERIFY OTP BODY: ${response.body}');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('اعتبارسنجی کد با خطا مواجه شد: ${response.statusCode}');
    }

    final dynamic decoded = jsonDecode(response.body);

    if (decoded is! List || decoded.isEmpty) {
      throw const FormatException('ساختار پاسخ اعتبارسنجی OTP نامعتبر است');
    }

    final firstItem = decoded.first;

    if (firstItem is! Map<String, dynamic>) {
      throw const FormatException('اطلاعات کاربر در پاسخ OTP نامعتبر است');
    }

    final result = firstItem;

    // --------------------------------
    // OTP اشتباه
    // --------------------------------
    if (result['success']?.toString().toLowerCase() == 'false') {
      throw Exception(result['result']?.toString() ?? 'کد وارد شده صحیح نیست');
    }

    // --------------------------------
    // کاربر جدید
    // پاسخ: success + result
    // --------------------------------
    if (result.containsKey('success') && result.containsKey('result')) {
      return VerifyOtpResponse.fromJson(result);
    }

    // --------------------------------
    // کاربر قبلی
    // پاسخ: اطلاعات کاربر + token
    // --------------------------------
    // if (result.containsKey('token')) {
    //   return VerifyOtpResponse.fromJson(result);
    // }

    if (result.containsKey('token')) {
      print('OTP RESULT: $result');
      print('OTP HAS TOKEN: ${result.containsKey('token')}');
      print('OTP TOKEN: ${result['token']}');

      final parsedResponse = VerifyOtpResponse.fromJson(result);

      print('PARSED OTP RESPONSE');
      print('IS NEW USER: ${parsedResponse.isNewUser}');
      print('TOKEN PARSED: ${parsedResponse.token}');

      return parsedResponse;
    }

    // --------------------------------
    // پاسخ ناشناخته
    // --------------------------------
    throw const FormatException('پاسخ سرور قابل شناسایی نیست');
  }
}

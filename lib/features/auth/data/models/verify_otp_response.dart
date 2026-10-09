class VerifyOtpResponse {
  final bool isNewUser;
  final String token;

  final int? id;
  final String? name;
  final String? family;
  final String? ostan;
  final String? mobile;

  VerifyOtpResponse({
    required this.isNewUser,
    required this.token,
    this.id,
    this.name,
    this.family,
    this.ostan,
    this.mobile,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    // -------------------------------
    // کاربر جدید
    // -------------------------------
    if (json.containsKey('success') && json.containsKey('result')) {
      final success = json['success']?.toString().toLowerCase();

      if (success == 'false') {
        throw Exception(json['result']?.toString() ?? 'کد وارد شده صحیح نیست');
      }

      return VerifyOtpResponse(
        isNewUser: true,
        token: json['result'].toString(),
      );
    }

    // -------------------------------
    // کاربر قبلی
    // -------------------------------
    final token = json['token']?.toString();

    if (token == null || token.isEmpty) {
      throw Exception('پاسخ نامعتبر از سرور دریافت شد');
    }

    return VerifyOtpResponse(
      isNewUser: false,
      token: token,
      id: json['id'] as int?,
      name: json['name']?.toString(),
      family: json['family']?.toString(),
      ostan: json['ostan']?.toString(),
      mobile: json['mobile']?.toString(),
    );
  }
}

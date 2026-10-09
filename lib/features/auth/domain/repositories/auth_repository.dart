import 'package:mr_market/features/auth/data/models/verify_otp_response.dart';

abstract class AuthRepository {
  Future<void> sendOtp(String mobileNumber);

  Future<VerifyOtpResponse> verifyOtp({
    required String mobileNumber,
    required String otp,
  });
}

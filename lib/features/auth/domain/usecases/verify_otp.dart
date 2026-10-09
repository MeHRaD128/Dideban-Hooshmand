import 'package:mr_market/features/auth/data/models/verify_otp_response.dart';
import '../repositories/auth_repository.dart';

class VerifyOtp {
  final AuthRepository repository;

  VerifyOtp(this.repository);

  Future<VerifyOtpResponse> call({
    required String mobileNumber,
    required String otp,
  }) {
    return repository.verifyOtp(mobileNumber: mobileNumber, otp: otp);
  }
}

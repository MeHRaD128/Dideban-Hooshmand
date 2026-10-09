import 'package:mr_market/features/auth/data/models/verify_otp_response.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> sendOtp(String mobileNumber) {
    return remoteDataSource.sendOtp(mobileNumber);
  }

  @override
  Future<VerifyOtpResponse> verifyOtp({
    required String mobileNumber,
    required String otp,
  }) {
    return remoteDataSource.verifyOtp(mobileNumber: mobileNumber, otp: otp);
  }
}

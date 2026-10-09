import 'dart:async';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:mr_market/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mr_market/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mr_market/features/auth/domain/usecases/verify_otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mr_market/app/localization/fa/auth_fa.dart';
import 'package:mr_market/app/localization/fa/common.dart';
import 'package:mr_market/core/widgets/responsive/responsive_container.dart';
import 'package:mr_market/features/auth/presentation/sign_up.dart';
import 'package:mr_market/features/home/presentation/home_page.dart';
import 'package:mr_market/features/shared/base/base.dart';

class OtpPage extends StatefulWidget {
  final String mobileNumber;

  const OtpPage({super.key, required this.mobileNumber});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  late int length = 6;
  final bool _isFocused = false;
  Timer? _timer;
  int _remainingSeconds = 30;
  bool _canResend = false;
  bool _isResending = false;
  late final List<TextEditingController> _controller = List.generate(
    6,
    (_) => TextEditingController(),
  );
  late final otp = _controller.map((controller) {
    return controller.text;
  }).join();
  late final VerifyOtp _verifyOtp;
  late final AuthRemoteDataSource _remoteDataSource;

  final List<FocusNode> _focusNode = List.generate(6, (_) => FocusNode());
  final List<String> _previousValue = List.generate(6, (_) => '');

  bool get _isOtpComplete {
    return _controller.every((controller) => controller.text.isNotEmpty);
  }

  @override
  void initState() {
    super.initState();

    _startTimer();

    final client = http.Client();

    _remoteDataSource = AuthRemoteDataSource(client: client);

    final repository = AuthRepositoryImpl(remoteDataSource: _remoteDataSource);

    _verifyOtp = VerifyOtp(repository);
  }

  Future<void> _handleContinue() async {
    if (!_isOtpComplete) return;

    final otp = _controller.map((controller) => controller.text).join();

    try {
      final response = await _verifyOtp(
        mobileNumber: widget.mobileNumber,
        otp: otp,
      );

      print('VERIFY USECASE COMPLETED');
      print('IS NEW USER: ${response.isNewUser}');
      print('TOKEN RECEIVED IN OTP PAGE: ${response.token}');

      if (!mounted) return;

      print('OTP PAGE IS MOUNTED');

      if (response.isNewUser) {
        print('GOING TO SIGN UP PAGE');

        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (_) => SignUpPage(
              token: response.token,
              mobileNumber: widget.mobileNumber,
            ),
          ),
        );
      } else {
        print('GOING TO HOME PAGE');

        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (_) => HomePage(token: response.token)),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('VERIFY OTP ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('کد نامعتبر'),
            content: const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'کد وارد شده صحیح نیست. لطفاً کد دریافت‌شده را بررسی کنید.',
              ),
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('باشه'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResend || _isResending) return;

    setState(() {
      _isResending = true;
    });

    try {
      await _remoteDataSource.sendOtp(widget.mobileNumber);

      if (!mounted) return;

      // پاک کردن OTP قبلی
      for (final controller in _controller) {
        controller.clear();
      }

      for (var i = 0; i < _previousValue.length; i++) {
        _previousValue[i] = '';
      }

      _focusNode[0].requestFocus();

      setState(() {
        _isResending = false;
      });

      // شروع مجدد تایمر
      _startTimer();
    } catch (e, stackTrace) {
      debugPrint('RESEND OTP ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _isResending = false;
      });

      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('خطا'),
            content: const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'ارسال مجدد کد با خطا مواجه شد. لطفاً دوباره تلاش کنید.',
              ),
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('باشه'),
              ),
            ],
          );
        },
      );
    }
  }

  void _startTimer() {
    _timer?.cancel();

    setState(() {
      _remainingSeconds = 30;
      _canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();

        setState(() {
          _canResend = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();

    for (final controller in _controller) {
      controller.dispose();
    }

    for (final focusNode in _focusNode) {
      focusNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Base(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 35),
                  // Spacer(flex: 55,),
                  // Container(
                  //   width: 100,
                  //   height: 100,
                  //   decoration: BoxDecoration(
                  //     color: Color.fromARGB(200, 217, 217, 217),
                  //     borderRadius: BorderRadius.circular(36),
                  //   ),
                  // ),
                  // Image.asset("assets/icons/Money.png"),
                  SvgPicture.asset(
                    "assets/icons/chart-presentation.svg",
                    width: 90,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AuthFa.OTP_TITLE,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      // fontWeight: FontWeight.w600,
                      fontFamily: 'Peyda',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    AuthFa.OTP_DESCRIPTION,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 35),
                  _buildOtpTextField(context),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_canResend)
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            _isResending ? null : _resendOtp();
                          },
                          child: Text(
                            'درخواست مجدد',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontSize: 12,
                                  color: const Color(0xFF2F9F96),
                                ),
                          ),
                        )
                      else
                        Text(
                          '00:${_remainingSeconds.toString().padLeft(2, '0')}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontSize: 12,
                                color: const Color(0xFF2F9F96),
                              ),
                        ),

                      const SizedBox(width: 12),

                      Text(
                        AuthFa.OTP_EXPIRED_TIME,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  _buildOtpContinueButton(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOtpTextField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 45,
          height: 60,
          decoration: BoxDecoration(
            border: _isFocused
                ? Border.all(color: CupertinoColors.systemBlue, width: 1.5)
                : Border.all(color: CupertinoColors.systemGrey4, width: 1.5),
            // border: Border.all(color: CupertinoColors.systemGrey4, width: 1.5),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: CupertinoTextField(
              cursorHeight: 30,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: null,
              maxLength: 1,
              controller: _controller[index],
              focusNode: _focusNode[index],
              onChanged: (value) {
                setState(() {});
                if (value.isNotEmpty) {
                  _previousValue[index] = value;
                  if (index < 5) {
                    _focusNode[index + 1].requestFocus();
                  }
                  return;
                  // else {
                  //   _focusNode[index].nextFocus();
                  // }
                }
                if (value.isEmpty && _previousValue[index].isNotEmpty) {
                  _previousValue[index] = '';
                  if (index > 0) {
                    _focusNode[index - 1].requestFocus();
                  }
                }
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _buildOtpContinueButton(BuildContext context) {
    return ResponsiveContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 0,
        children: [
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                _isOtpComplete
                    ? BoxShadow(
                        color: const Color(0xFF05ba83).withValues(alpha: 0.30),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 6),
                      )
                    : BoxShadow(
                        color: const Color(0xFF74CEC4).withValues(alpha: 0.0),
                        blurRadius: 0,
                        spreadRadius: 0,
                        offset: const Offset(0, 0),
                      ),
              ],
            ),
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(25),
              color: _isOtpComplete
                  ? const Color(0xFF01B578)
                  : CupertinoColors.systemGrey5,
              disabledColor: CupertinoColors.systemGrey5,
              onPressed: _isOtpComplete ? _handleContinue : null,
              child: Text(
                CommonFa.CONTINUE_TEXT,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 18,
                  color: _isOtpComplete
                      ? CupertinoColors.white
                      : CupertinoColors.inactiveGray,
                ),
              ),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.only(bottom: 0),
            child: Text(
              CommonFa.RETURN,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 15,
                color: const Color(0xFF687579),
              ),
            ),
            onPressed: () => {Navigator.pop(context)},
          ),
        ],
      ),
    );
  }
}

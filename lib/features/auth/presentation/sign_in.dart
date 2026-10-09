import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:mr_market/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mr_market/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mr_market/features/auth/domain/usecases/send_otp.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mr_market/app/localization/localization.dart';
import 'package:mr_market/core/widgets/responsive/responsive_container.dart';
import 'package:mr_market/features/auth/presentation/otp.dart';
import 'package:mr_market/features/auth/presentation/username_signin.dart';
import 'package:mr_market/features/auth/presentation/widgets/phone_number_field.dart';
import 'package:mr_market/features/shared/base/base.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  Country _selectedCountry = Country(
    phoneCode: '98',
    countryCode: 'IR',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Iran',
    example: '9123456789',
    displayName: 'Iran',
    displayNameNoCountryCode: 'IR',
    e164Key: '98-IR',
  );

  bool _rememberMe = false;
  late final SendOtp _sendOtp;
  final TextEditingController _phoneController = TextEditingController();

  bool get _isPhoneValid {
    return _phoneController.text.trim().isNotEmpty;
  }

  Future<void> _handleContinue() async {
    if (!_isPhoneValid) return;

    final phone = _phoneController.text.trim();

    final mobileNumber = phone.startsWith('0') ? phone : '0$phone';

    print('Sending: $mobileNumber');

    try {
      await _sendOtp(mobileNumber);

      if (!mounted) return;

      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => OtpPage(mobileNumber: mobileNumber),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('ارسال کد با خطا مواجه شد')));
    }
  }

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      setState(() {});
    });

    final client = http.Client();

    final remoteDataSource = AuthRemoteDataSource(client: client);

    final repository = AuthRepositoryImpl(remoteDataSource: remoteDataSource);

    _sendOtp = SendOtp(repository);

    _phoneController.addListener(() {
      setState(() {});
    });
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
                  // const SizedBox(height: 35),
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
                  SvgPicture.asset("assets/icons/login.svg"),
                  const SizedBox(height: 20),
                  Text(
                    AuthFa.LOGIN_TITLE,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      // fontWeight: FontWeight.w600,
                      fontFamily: 'Peyda',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    AuthFa.LOGIN_DESCRIPTION,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 35),
                  ResponsiveContainer(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            AuthFa.PHONE_NUMBER_FIELD_LABEL,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ============================================
                  // Primary phone number field
                  // ============================================
                  ResponsiveContainer(
                    child: PhoneNumberField(
                      initialCountry: _selectedCountry,
                      controller: _phoneController,
                      onCountryChanged: (country) => {
                        setState(() => _selectedCountry = country),
                      },
                    ),
                  ),

                  ResponsiveContainer(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AuthFa.REMEBER_ME,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(fontSize: 15),
                          ),
                          GestureDetector(
                            onLongPress: () {
                              setState(() {
                                _rememberMe = true;
                              });
                            },
                            onLongPressEnd: (details) {
                              setState(() {
                                _rememberMe = false;
                              });
                            },
                            child: CupertinoSwitch(
                              value: _rememberMe,
                              activeTrackColor: const Color(0xFF00C853),
                              onChanged: (bool value) {
                                setState(() => _rememberMe = value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // const Color(0xFF12D18E)
                  ResponsiveContainer(
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
                              _isPhoneValid
                                  ? BoxShadow(
                                      color: const Color(
                                        0xFF05ba83,
                                      ).withValues(alpha: 0.30),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 6),
                                    )
                                  : BoxShadow(
                                      color: const Color(
                                        0xFF74CEC4,
                                      ).withValues(alpha: 0.0),
                                      blurRadius: 0,
                                      spreadRadius: 0,
                                      offset: const Offset(0, 0),
                                    ),
                            ],
                          ),
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            borderRadius: BorderRadius.circular(25),
                            color: _isPhoneValid
                                ? const Color(0xFF01B578)
                                : CupertinoColors.systemGrey5,
                            disabledColor: CupertinoColors.systemGrey5,
                            onPressed: _isPhoneValid ? _handleContinue : null,
                            child: Text(
                              CommonFa.CONTINUE_TEXT,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontSize: 18,
                                    color: _phoneController.text.isEmpty
                                        ? Colors.blueGrey
                                        : CupertinoColors.white,
                                  ),
                            ),
                          ),
                        ),

                        CupertinoButton(
                          padding: EdgeInsets.only(bottom: 0),
                          child: Text(
                            AuthFa.LOGIN_WITH_USERNAME,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontSize: 15,
                                  color: const Color(
                                    0xFF687579,
                                  ).withValues(alpha: 1),
                                ),
                          ),
                          onPressed: () => {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => UsernameSignin(),
                              ),
                            ),
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

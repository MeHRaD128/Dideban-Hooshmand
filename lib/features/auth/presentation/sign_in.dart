import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mr_market/app/localization/localization.dart';
import 'package:mr_market/core/widgets/responsive/responsive_container.dart';
import 'package:mr_market/features/auth/presentation/otp.dart';
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

  final TextEditingController _phoneController = TextEditingController();

  bool get _isPhoneValid {
    return _phoneController.text.trim().isNotEmpty;
  }

  void _handleContinue() {
    if (!_isPhoneValid) return;

    final phone = _phoneController.text.trim();

    final fullPhoneNumber = '+${_selectedCountry.phoneCode}$phone';

    print('ادامه: $fullPhoneNumber');

    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => OtpPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Base(
      child: Column(
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
          Image.asset("assets/animations/Money.gif"),
          const SizedBox(height: 20),
          Text(
            AuthFa.LOGIN_TITLE,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            AuthFa.LOGIN_DESCRIPTION,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 35),
          ResponsiveContainer(
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
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

          // const SizedBox(height: 10),
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

          ResponsiveContainer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 0,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.circular(25),
                    color: _isPhoneValid
                        ? const Color(0xFF0091FF)
                        : CupertinoColors.systemGrey5,
                    disabledColor: CupertinoColors.systemGrey5,
                    onPressed: _isPhoneValid ? _handleContinue : null,
                    child: Text(
                      CommonFa.continueText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 18,
                        color: _phoneController.text.isEmpty
                            ? Colors.blueGrey
                            : CupertinoColors.white,
                      ),
                    ),
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.only(bottom: 6),
                  child: Text(
                    AuthFa.LOGIN_WITH_USERNAME,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(fontSize: 12),
                  ),
                  onPressed: () => {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

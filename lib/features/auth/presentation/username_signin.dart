import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mr_market/app/localization/fa/auth_fa.dart';
import 'package:mr_market/app/localization/fa/common.dart';
import 'package:mr_market/core/widgets/responsive/responsive_container.dart';
import 'package:mr_market/features/auth/presentation/forget_password.dart';
import 'package:mr_market/features/auth/presentation/sign_in.dart';
import 'package:mr_market/features/shared/base/base.dart';

class UsernameSignin extends StatefulWidget {
  const UsernameSignin({super.key});

  @override
  State<UsernameSignin> createState() => _UsernameSigninState();
}

class _UsernameSigninState extends State<UsernameSignin> {
  static const int length = 6;
  final List<TextEditingController> _controller = List.generate(
    length,
    (_) => TextEditingController(),
  );
  final FocusNode _phoneFocusNode = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool get _isFormComplete {
    return _phoneController.text.trim().isNotEmpty &&
        _codeController.text.trim().isNotEmpty;
  }

  void _handleContinue() {
    if (!_isFormComplete) return;
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => SignInPage()),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    _phoneFocusNode.dispose();

    for (final controller in _controller) {
      controller.dispose();
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
              constraints: BoxConstraints(minHeight: constraints.minHeight),
              child: Column(
                children: [
                  // Image.asset("assets/icons/Money.png"),
                  SvgPicture.asset("assets/icons/diagram-bar.svg", width: 90),
                  const SizedBox(height: 20),
                  Text(
                    AuthFa.USERNAME_SIGNIN_TITLE,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      // fontWeight: FontWeight.w600,
                      fontFamily: 'Peyda',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    AuthFa.USERNAME_SIGNIN_DESCRIPTION,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 35),

                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          AuthFa.USERNAME_SIGNIN_PHONE_NUMBER_TEXT_FIELD_LABEL,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 5),
                        CupertinoTextField(
                          controller: _phoneController,
                          focusNode: _phoneFocusNode,
                          keyboardType: TextInputType.number,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: CupertinoColors.white,
                            border: BoxBorder.all(
                              color: CupertinoColors.systemGrey4,
                            ),
                          ),
                          maxLength: 20,
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          AuthFa.USERNAME_SIGNIN_SENT_CODE_TEXT_FIELD_LABEL,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 5),
                        CupertinoTextField(
                          controller: _codeController,
                          keyboardType: TextInputType.number,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: CupertinoColors.white,
                            border: BoxBorder.all(
                              color: CupertinoColors.systemGrey4,
                            ),
                          ),
                          maxLength: 26,
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: _buildOtpContinueButton(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
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
                _isFormComplete
                    ? BoxShadow(
                        color: const Color(0xFF74CEC4).withValues(alpha: 0.30),
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
              color: _isFormComplete
                  ? const Color(0xFF2F9F96)
                  : CupertinoColors.systemGrey5,
              disabledColor: CupertinoColors.systemGrey5,
              onPressed: _isFormComplete ? _handleContinue : null,
              child: Text(
                AuthFa.USERNAME_SIGNIN_ENTER_BUTTON,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 18,
                  color: _isFormComplete
                      ? CupertinoColors.white
                      : CupertinoColors.inactiveGray,
                ),
              ),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              AuthFa.FORGOT_PASSWORD,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 15,
                color: const Color(0xFF687579).withValues(alpha: 1),
              ),
            ),
            onPressed: () => {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => ForgetPasswordPage()),
              ),
            },
          ),
          CupertinoButton(
            padding: EdgeInsets.only(bottom: 20),
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mr_market/app/localization/fa/auth_fa.dart';
import 'package:mr_market/app/localization/fa/common.dart';
import 'package:mr_market/core/widgets/responsive/responsive_container.dart';
import 'package:mr_market/features/auth/presentation/sign_in.dart';
import 'package:mr_market/features/shared/base/base.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  late int length = 6;
  late final List<TextEditingController> _controller = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> _focusNode = List.generate(6, (_) => FocusNode());
  final List<String> _previousValue = List.generate(6, (_) => '');

  bool get _isOtpComplete {
    return _controller.every((controller) => controller.text.isNotEmpty);
  }

  void _handleContinue() {
    if (!_isOtpComplete) return;

    // final phone = _isOtpComplete.text.trim();
    // final fullPhoneNumber = '+${_selectedCountry.phoneCode}$phone';
    // print('ادامه: ');

    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => SignInPage()),
    );
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
            AuthFa.OTP_TITLE,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            AuthFa.OTP_DESCRIPTION,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 35),
          _buildOtpTextField(context),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "31:00",
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontSize: 12),
              ),
              const SizedBox(width: 12),
              Text(
                AuthFa.OTP_EXPIRED_TIME,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 35),
          _buildOtpContinueButton(context),
        ],
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
            border: Border.all(color: CupertinoColors.systemGrey4, width: 1.5),
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
          SizedBox(
            width: double.infinity,
            height: 50,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              borderRadius: BorderRadius.circular(25),
              color: _isOtpComplete
                  ? const Color(0xFF0091FF)
                  : CupertinoColors.systemGrey5,
              disabledColor: CupertinoColors.systemGrey5,
              onPressed: _isOtpComplete ? _handleContinue : null,
              child: Text(
                CommonFa.continueText,
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
            padding: EdgeInsets.only(bottom: 6),
            child: Text(
              AuthFa.OTP_CANCEL,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontSize: 12),
            ),
            onPressed: () => {Navigator.pop(context)},
          ),
        ],
      ),
    );
  }
}

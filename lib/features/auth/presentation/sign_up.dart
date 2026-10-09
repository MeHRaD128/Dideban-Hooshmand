import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:mr_market/app/localization/fa/auth_fa.dart';
import 'package:mr_market/app/localization/fa/common.dart';

import 'package:mr_market/core/widgets/responsive/responsive_container.dart';
import 'package:mr_market/features/shared/base/base.dart';

class SignUpPage extends StatefulWidget {
  final String token;
  final String mobileNumber;

  const SignUpPage({
    super.key,
    required this.token,
    required this.mobileNumber,
  });

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  String? _selectedProvince;

  List<String> _provinces = [];

  bool _isLoadingProvinces = false;
  bool _isSubmitting = false;

  bool get _isFormComplete {
    return _firstNameController.text.trim().isNotEmpty &&
        _lastNameController.text.trim().isNotEmpty &&
        _selectedProvince != null &&
        _passwordController.text.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();

    _firstNameController.addListener(_refresh);
    _lastNameController.addListener(_refresh);
    _passwordController.addListener(_refresh);

    _getProvinces();
  }

  void _refresh() {
    setState(() {});
  }

  Future<void> _getProvinces() async {
    setState(() {
      _isLoadingProvinces = true;
    });

    try {
      final uri = Uri.parse(
        'https://api.didebanhooshmand.ir/api/Common/getostanlist',
      ).replace(queryParameters: {'Type': '1'});

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      debugPrint('PROVINCE STATUS: ${response.statusCode}');
      debugPrint('PROVINCE BODY: ${response.body}');

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
          'دریافت استان‌ها با خطا مواجه شد: ${response.statusCode}',
        );
      }

      final decoded = jsonDecode(response.body);

      final provinces = _parseProvinces(decoded);

      if (!mounted) return;

      setState(() {
        _provinces = provinces;
      });
    } catch (e, stackTrace) {
      debugPrint('GET PROVINCES ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      _showMessage(
        title: 'خطا',
        message: 'دریافت لیست استان‌ها با خطا مواجه شد',
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoadingProvinces = false;
      });
    }
  }

  List<String> _parseProvinces(dynamic data) {
    dynamic listData = data;

    if (data is Map<String, dynamic>) {
      listData = data['result'] ?? data['data'] ?? data['items'];
    }

    if (listData is! List) {
      return [];
    }

    return listData
        .map<String>((item) {
          if (item is String) {
            return item;
          }

          if (item is Map<String, dynamic>) {
            return (item['name'] ??
                    item['Name'] ??
                    item['title'] ??
                    item['Title'] ??
                    item['ostan'] ??
                    item['Ostan'] ??
                    '')
                .toString();
          }

          return item.toString();
        })
        .where((name) => name.isNotEmpty)
        .toList();
  }

  void _showProvincePicker() {
    if (_provinces.isEmpty) return;

    int selectedIndex = _selectedProvince == null
        ? 0
        : _provinces.indexOf(_selectedProvince!);

    if (selectedIndex < 0) {
      selectedIndex = 0;
    }

    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          height: 320,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              Container(
                height: 55,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('لغو'),
                    ),
                    const Text(
                      'انتخاب استان',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {
                          _selectedProvince = _provinces[selectedIndex];
                        });

                        Navigator.pop(context);
                      },
                      child: const Text('تأیید'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 44,
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedIndex,
                  ),
                  onSelectedItemChanged: (index) {
                    selectedIndex = index;
                  },
                  children: _provinces
                      .map(
                        (province) => Center(
                          child: Text(
                            province,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleContinue() async {
    if (!_isFormComplete || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final uri =
          Uri.parse(
            'https://api.didebanhooshmand.ir/api/Customers/insertcustomer',
          ).replace(
            queryParameters: {
              'Name': _firstNameController.text.trim(),
              'Family': _lastNameController.text.trim(),
              'Ostan': _selectedProvince!,
              'MobileNumber': widget.mobileNumber,
              'Password': _passwordController.text.trim(),
            },
          );

      debugPrint('SIGN UP URL: $uri');

      final response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      debugPrint('SIGN UP STATUS: ${response.statusCode}');
      debugPrint('SIGN UP BODY: ${response.body}');

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('ثبت اطلاعات با خطا مواجه شد: ${response.statusCode}');
      }

      if (!mounted) return;

      _showMessage(title: 'موفق', message: 'اطلاعات با موفقیت ثبت شد');
    } catch (e, stackTrace) {
      debugPrint('SIGN UP ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      _showMessage(title: 'خطا', message: 'ثبت اطلاعات با خطا مواجه شد');
    } finally {
      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _showMessage({required String title, required String message}) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(message),
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

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();

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
                  // Image.asset('assets/icons/Money.png'),
                  SvgPicture.asset("assets/icons/registration.svg", width: 90),

                  const SizedBox(height: 20),

                  Text(
                    AuthFa.SIGNUP_TITLE,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(fontFamily: 'Peyda'),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 5),

                  Text(
                    AuthFa.SIGNUP_DESCRIPTION,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 35),

                  _buildTextField(
                    label: AuthFa.SIGNUP_FIRSTNAME,
                    controller: _firstNameController,
                    keyboardType: TextInputType.name,
                  ),

                  const SizedBox(height: 15),

                  _buildTextField(
                    label: AuthFa.SIGNUP_LASTNAME,
                    controller: _lastNameController,
                    keyboardType: TextInputType.name,
                  ),

                  const SizedBox(height: 15),

                  _buildProvinceField(),

                  const SizedBox(height: 15),

                  _buildTextField(
                    label: AuthFa.SIGNUP_PASSWORD,
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                  ),

                  const SizedBox(height: 50),

                  _buildContinueButton(),

                  const SizedBox(height: 4),

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
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
    bool obscureText = false,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),

          const SizedBox(height: 5),

          CupertinoTextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: CupertinoColors.white,
              border: Border.all(color: CupertinoColors.systemGrey4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProvinceField() {
    final hasProvince = _selectedProvince != null;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            AuthFa.SIGNUP_PROVINCE,
            style: Theme.of(context).textTheme.bodySmall,
          ),

          const SizedBox(height: 5),

          GestureDetector(
            onTap: _isLoadingProvinces ? null : _showProvincePicker,
            child: Container(
              width: double.infinity,
              height: 41,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: CupertinoColors.systemGrey4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_isLoadingProvinces)
                    const CupertinoActivityIndicator()
                  else
                    Text(
                      hasProvince
                          ? _selectedProvince!
                          : AuthFa.SIGNUP_SELECT_PROVINCE,
                      style: TextStyle(
                        fontSize: 16,
                        color: hasProvince
                            ? CupertinoColors.black
                            : CupertinoColors.systemGrey,
                      ),
                    ),
                  const Icon(CupertinoIcons.chevron_down, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return ResponsiveContainer(
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            if (_isFormComplete)
              BoxShadow(
                color: const Color(0xFF74CEC4).withValues(alpha: 0.30),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 6),
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
          onPressed: _isFormComplete && !_isSubmitting ? _handleContinue : null,
          child: _isSubmitting
              ? const CupertinoActivityIndicator(color: CupertinoColors.white)
              : Text(
                  CommonFa.CONTINUE_TEXT,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 18,
                    color: _isFormComplete
                        ? CupertinoColors.white
                        : CupertinoColors.inactiveGray,
                  ),
                ),
        ),
      ),
    );
  }
}

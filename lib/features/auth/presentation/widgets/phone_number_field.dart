import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/services.dart';
import 'country_selector.dart';

class PhoneNumberField extends StatefulWidget {
  final Country initialCountry;
  final TextEditingController? controller;
  final ValueChanged<Country>? onCountryChanged;

  const PhoneNumberField({
    super.key,
    required this.initialCountry,
    this.controller,
    this.onCountryChanged,
  });

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  late Country _selectedCountry;
  final FocusNode _phoneFocus = FocusNode();
  late TextEditingController _phoneController;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.initialCountry;
    _phoneController = widget.controller ?? TextEditingController();

    _phoneFocus.addListener(() {
      setState(() => _isFocused = _phoneFocus.hasFocus);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_phoneFocus);
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _phoneController.dispose();
    }
    _phoneFocus.dispose();
    super.dispose();
  }

  void _onCountrySelected(Country country) {
    setState(() => _selectedCountry = country);
    widget.onCountryChanged?.call(country);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: _isFocused
                ? const Color(0xFF2AABEE)
                : CupertinoColors.systemGrey5,
            width: _isFocused ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Row(
          children: [
            // ===== Country selector =====
            CountrySelector(
              selectedCountry: _selectedCountry,
              onCountrySelected: _onCountrySelected,
            ),
            const SizedBox(width: 4),

            // ===== Phone number field =====
            Expanded(
              child: CupertinoTextField(
                controller: _phoneController,
                focusNode: _phoneFocus,
                keyboardType: TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                placeholder: '(${_selectedCountry.example}) 000-0000',
                placeholderStyle: const TextStyle(
                  color: CupertinoColors.systemGrey3,
                  fontSize: 16,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.black,
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(),
                // border: null,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}

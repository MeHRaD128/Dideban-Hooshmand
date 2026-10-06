import 'package:flutter/cupertino.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'circular_flag.dart';

class CountrySelector extends StatelessWidget {
  final Country selectedCountry;
  final ValueChanged<Country> onCountrySelected;

  const CountrySelector({
    super.key,
    required this.selectedCountry,
    required this.onCountrySelected,
  });

  void _openCountryPicker(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      countryListTheme: CountryListThemeData(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        inputDecoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: const Icon(CupertinoIcons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: CupertinoColors.systemGrey4),
          ),
        ),
      ),
      onSelect: onCountrySelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: () => _openCountryPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularFlag(countryCode: selectedCountry.countryCode),
            const SizedBox(width: 8),
            Text(
              '${selectedCountry.displayNameNoCountryCode} +${selectedCountry.phoneCode}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: CupertinoColors.black,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              CupertinoIcons.chevron_up_chevron_down,
              size: 14,
              color: CupertinoColors.black,
            ),
          ],
        ),
      ),
    );
  }
}

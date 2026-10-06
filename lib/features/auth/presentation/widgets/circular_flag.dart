import 'package:flutter/cupertino.dart';
import 'package:country_flags/country_flags.dart';

class CircularFlag extends StatelessWidget {
  final String countryCode; // مثال: 'AE'
  final double size;

  const CircularFlag({
    super.key,
    required this.countryCode,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return CountryFlag.fromCountryCode(
      countryCode,
      shape: const Circle(),
      width: size,
      height: size,
    );
  }
}

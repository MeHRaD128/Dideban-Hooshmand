import 'package:flutter/material.dart';

class ProfitLossPage extends StatelessWidget {
  final String token;

  const ProfitLossPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('سود و زیان'));
  }
}

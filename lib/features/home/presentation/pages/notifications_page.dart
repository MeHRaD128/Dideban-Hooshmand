import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final String token;
  const NotificationsPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('اعلانات'));
  }
}

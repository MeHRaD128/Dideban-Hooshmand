import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  final String token;
  const DashboardPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    final stocks = [
      ('طلا ۱۸ عیار', '۱۲,۴۵۰,۰۰۰', '+۲.۴٪', true),
      ('بیت‌کوین', '۱۱۲,۸۵۰', '+۱.۸٪', true),
      ('اتریوم', '۴,۲۸۰', '-۰.۷٪', false),
      ('دلار آمریکا', '۹۸,۵۰۰', '+۰.۵٪', true),
      ('نفت برنت', '۷۲.۴۰', '-۱.۲٪', false),
    ];

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
      itemCount: 20,
      itemBuilder: (context, index) {
        final stock = stocks[index % stocks.length];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          color: CupertinoColors.secondarySystemGroupedBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: CircleAvatar(
              backgroundColor: stock.$4
                  ? const Color(0xFFE1F7E9)
                  : const Color(0xFFFFE7E7),
              child: Icon(
                stock.$4 ? Icons.trending_up : Icons.trending_down,
                color: stock.$4
                    ? const Color(0xFF159447)
                    : const Color(0xFFD93636),
              ),
            ),
            title: Text(
              stock.$1,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              stock.$3,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: stock.$4
                    ? const Color(0xFF159447)
                    : const Color(0xFFD93636),
              ),
            ),
            trailing: Text(
              stock.$2,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}

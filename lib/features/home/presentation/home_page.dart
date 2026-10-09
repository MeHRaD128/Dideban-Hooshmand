import 'package:flutter/material.dart';
import 'package:liquid_glass_bottom_navbar_plus/liquid_glass_bottom_navbar_plus.dart';
import 'package:mr_market/features/home/presentation/pages/dashboard_page.dart';
import 'package:mr_market/features/home/presentation/pages/notifications_page.dart';
import 'package:mr_market/features/home/presentation/pages/portfolio_page.dart';
import 'package:mr_market/features/home/presentation/pages/profile_page.dart';
import 'package:mr_market/features/home/presentation/pages/profit_loss_page.dart';
import 'package:mr_market/features/home/presentation/pages/watchlist_page.dart';
import 'package:mr_market/features/shared/base/base.dart';

class HomePage extends StatefulWidget {
  final String token;
  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 3;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      ProfilePage(token: widget.token),
      PortfolioPage(token: widget.token),
      WatchlistPage(token: widget.token),
      DashboardPage(token: widget.token),
      NotificationsPage(token: widget.token),
      ProfitLossPage(token: widget.token),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Base(
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F7),
        extendBody: true,

        body: IndexedStack(index: _index, children: _pages),

        bottomNavigationBar: LiquidGlassBottomBar(
          settings: const LiquidGlassSettings(
            thickness: 14,
            refractiveIndex: 5.5,
            blur: 6,
            saturation: 6,
            chromaticAberration: 0,
            lightAngle: -0.785,
          ),
          selectedIndex: _index,
          onDestinationSelected: (index) {
            setState(() {
              _index = index;
            });
          },
          items: const [
            LiquidGlassBarItem(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'پروفایل',
            ),
            LiquidGlassBarItem(
              icon: Icon(Icons.pie_chart_outline),
              selectedIcon: Icon(Icons.pie_chart),
              label: 'پورتفولیو',
            ),
            LiquidGlassBarItem(
              icon: Icon(Icons.visibility_outlined),
              selectedIcon: Icon(Icons.visibility),
              label: 'دیده‌بان',
            ),
            LiquidGlassBarItem(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'صفحه اصلی',
            ),
            LiquidGlassBarItem(
              icon: Icon(Icons.notifications_none),
              selectedIcon: Icon(Icons.notifications),
              label: 'اعلانات',
            ),
            LiquidGlassBarItem(
              icon: Icon(Icons.show_chart),
              selectedIcon: Icon(Icons.analytics),
              label: 'سود و زیان',
            ),
          ],
        ),
      ),
    );
  }
}

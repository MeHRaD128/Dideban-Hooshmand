import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String token;
  const ProfilePage({super.key, required this.token});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _searchQuery = '';

  final Map<String, bool> _switches = {
    'airplane': false,
    'wifi': true,
    'bluetooth': true,
    'mobile': true,
    'notifications': true,
    'dark_mode': false,
    'face_id': true,
    'analytics': false,
  };

  static const Color _blue = Color(0xFF007AFF);
  static const Color _green = Color(0xFF34C759);
  static const Color _background = Color(0xFFF2F2F7);
  static const Color _secondaryText = Color(0xFF8E8E93);

  late final List<_SettingsGroup> _groups = [
    _SettingsGroup(
      title: 'اتصالات',
      items: [
        _SettingsItem(
          title: 'حالت پرواز',
          icon: Icons.airplanemode_active,
          color: const Color(0xFFFF9500),
          switchKey: 'airplane',
        ),
        _SettingsItem(
          title: 'Wi-Fi',
          subtitle: 'شبکه متصل',
          icon: Icons.wifi,
          color: _blue,
          switchKey: 'wifi',
        ),
        _SettingsItem(
          title: 'Bluetooth',
          subtitle: 'روشن',
          icon: Icons.bluetooth,
          color: _blue,
          switchKey: 'bluetooth',
        ),
        _SettingsItem(
          title: 'شبکه تلفن همراه',
          icon: Icons.signal_cellular_alt,
          color: _green,
          switchKey: 'mobile',
        ),
      ],
    ),
    _SettingsGroup(
      title: 'حساب و شخصی‌سازی',
      items: [
        _SettingsItem(
          title: 'حساب کاربری',
          subtitle: 'مدیریت اطلاعات حساب',
          icon: Icons.person_outline_rounded,
          color: _blue,
        ),
        _SettingsItem(
          title: 'اعلانات',
          subtitle: 'صداها و اعلان‌های برنامه',
          icon: Icons.notifications_none_rounded,
          color: const Color(0xFFFF3B30),
          switchKey: 'notifications',
        ),
        _SettingsItem(
          title: 'تمرکز',
          subtitle: 'مدیریت حالت‌های تمرکز',
          icon: Icons.nightlight_round,
          color: const Color(0xFF5856D6),
        ),
        _SettingsItem(
          title: 'زمان استفاده',
          icon: Icons.hourglass_empty_rounded,
          color: const Color(0xFF5856D6),
        ),
      ],
    ),
    _SettingsGroup(
      title: 'ظاهر و نمایش',
      items: [
        _SettingsItem(
          title: 'نمایشگر و روشنایی',
          icon: Icons.brightness_6_outlined,
          color: const Color(0xFF007AFF),
        ),
        _SettingsItem(
          title: 'حالت تاریک',
          subtitle: 'تغییر ظاهر برنامه',
          icon: Icons.dark_mode_outlined,
          color: const Color(0xFF5856D6),
          switchKey: 'dark_mode',
        ),
        _SettingsItem(
          title: 'صفحه اصلی',
          icon: Icons.grid_view_rounded,
          color: const Color(0xFF007AFF),
        ),
        _SettingsItem(
          title: 'تصویر پس‌زمینه',
          icon: Icons.wallpaper_outlined,
          color: const Color(0xFF34C759),
        ),
      ],
    ),
    _SettingsGroup(
      title: 'امنیت و حریم خصوصی',
      items: [
        _SettingsItem(
          title: 'Face ID و رمز عبور',
          icon: Icons.face_retouching_natural,
          color: const Color(0xFF34C759),
          switchKey: 'face_id',
        ),
        _SettingsItem(
          title: 'حریم خصوصی و امنیت',
          icon: Icons.privacy_tip_outlined,
          color: _blue,
        ),
        _SettingsItem(
          title: 'مجوزهای برنامه',
          icon: Icons.admin_panel_settings_outlined,
          color: const Color(0xFF007AFF),
        ),
        _SettingsItem(
          title: 'تحلیل و بهبود',
          icon: Icons.analytics_outlined,
          color: const Color(0xFF5856D6),
          switchKey: 'analytics',
        ),
      ],
    ),
    _SettingsGroup(
      title: 'تنظیمات برنامه',
      items: [
        _SettingsItem(
          title: 'زبان',
          subtitle: 'فارسی',
          icon: Icons.language_rounded,
          color: _blue,
        ),
        _SettingsItem(
          title: 'دسترسی‌پذیری',
          icon: Icons.accessibility_new_rounded,
          color: _blue,
        ),
        _SettingsItem(
          title: 'برنامه‌های پیش‌فرض',
          icon: Icons.apps_rounded,
          color: const Color(0xFF5856D6),
        ),
        _SettingsItem(
          title: 'فضای ذخیره‌سازی',
          icon: Icons.storage_rounded,
          color: const Color(0xFF8E8E93),
        ),
      ],
    ),
    _SettingsGroup(
      title: 'درباره',
      items: [
        _SettingsItem(
          title: 'درباره آقای بازار',
          subtitle: 'نسخه 1.0.0',
          icon: Icons.info_outline_rounded,
          color: _blue,
        ),
        _SettingsItem(
          title: 'راهنما و پشتیبانی',
          icon: Icons.help_outline_rounded,
          color: _green,
        ),
        _SettingsItem(
          title: 'خروج از حساب کاربری',
          icon: Icons.logout_rounded,
          color: const Color(0xFFFF3B30),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredGroups = _groups
        .map(
          (group) => _SettingsGroup(
            title: group.title,
            items: group.items
                .where(
                  (item) =>
                      item.title.contains(_searchQuery) ||
                      (item.subtitle?.contains(_searchQuery) ?? false),
                )
                .toList(),
          ),
        )
        .where((group) => group.items.isNotEmpty)
        .toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        color: _background,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
          children: [
            const SizedBox(height: 12),

            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'تنظیمات',
                style: TextStyle(
                  fontSize: 34,
                  // fontWeight: FontWeight.w700,
                  letterSpacing: -0.8,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 18),

            CupertinoSearchTextField(
              placeholder: 'جستجو',
              style: Theme.of(context).textTheme.bodyMedium,
              backgroundColor: Colors.white,
              borderRadius: BorderRadius.circular(14),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              onChanged: (value) {
                setState(() => _searchQuery = value.trim());
              },
            ),

            const SizedBox(height: 22),

            if (_searchQuery.isEmpty) ...[
              _buildAccountCard(),
              const SizedBox(height: 28),
            ],

            for (final group in filteredGroups) ...[
              Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 8, top: 8),
                child: Text(
                  group.title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: _secondaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              _buildGroupCard(group),
              const SizedBox(height: 22),
            ],

            if (filteredGroups.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'موردی پیدا نشد',
                    style: TextStyle(color: _secondaryText, fontSize: 16),
                  ),
                ),
              ),

            const Center(
              child: Text(
                'دیده بان هوشمند',
                style: TextStyle(color: _secondaryText, fontSize: 13),
              ),
            ),
            const SizedBox(height: 6),
            const Center(
              child: Text(
                'نسخه 1.0.0',
                style: TextStyle(color: _secondaryText, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showMessage(
            'حساب کاربری',
            'در این قسمت می‌توان اطلاعات حساب را مدیریت کرد.',
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFFE5E5EA),
                  child: Icon(
                    Icons.person_rounded,
                    size: 36,
                    color: Color(0xFF8E8E93),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'حساب کاربری من',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'مدیریت پروفایل و اطلاعات شخصی',
                        style: TextStyle(fontSize: 13, color: _secondaryText),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_left_rounded,
                  color: _secondaryText,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupCard(_SettingsGroup group) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          for (int i = 0; i < group.items.length; i++) ...[
            _buildRow(group.items[i]),
            if (i != group.items.length - 1)
              const Padding(
                padding: EdgeInsets.only(right: 58),
                child: Divider(
                  height: 1,
                  thickness: 0.5,
                  color: Color(0xFFD1D1D6),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(_SettingsItem item) {
    final isSwitch = item.switchKey != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          if (isSwitch) {
            final key = item.switchKey!;
            setState(() {
              _switches[key] = !(_switches[key] ?? false);
            });
          } else {
            _showMessage(
              item.title,
              'صفحه ${item.title} هنوز به منطق اصلی برنامه متصل نشده است.',
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(item.icon, size: 21, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 15.5,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        item.subtitle!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: _secondaryText,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSwitch)
                CupertinoSwitch(
                  value: _switches[item.switchKey] ?? false,
                  activeTrackColor: _green,
                  onChanged: (value) {
                    setState(() {
                      _switches[item.switchKey!] = value;
                    });
                  },
                )
              else
                const Icon(
                  Icons.chevron_left_rounded,
                  size: 23,
                  color: Color(0xFFC7C7CC),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMessage(String title, String message) {
    showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(title),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(message),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('متوجه شدم'),
          ),
        ],
      ),
    );
  }
}

class _SettingsGroup {
  final String title;
  final List<_SettingsItem> items;

  const _SettingsGroup({required this.title, required this.items});
}

class _SettingsItem {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final String? switchKey;

  const _SettingsItem({
    required this.title,
    required this.icon,
    required this.color,
    this.subtitle,
    this.switchKey,
  });
}

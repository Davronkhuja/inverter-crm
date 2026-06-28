import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../state/security_provider.dart';
import '../../state/settings_provider.dart';
import '../security/pin_setup_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() => _version = '${info.version} (${info.buildNumber})');
      }
    } catch (_) {
      // Не критично — просто не показываем версию.
    }
  }

  Future<void> _pickTheme(SettingsProvider settings) async {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final result = await showModalBottomSheet<ThemeMode>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            _ThemeOption(
              icon: Icons.brightness_auto_outlined,
              label: l10n.themeSystem,
              selected: settings.themeMode == ThemeMode.system,
              onTap: () => Navigator.pop(context, ThemeMode.system),
            ),
            _ThemeOption(
              icon: Icons.light_mode_outlined,
              label: l10n.themeLight,
              selected: settings.themeMode == ThemeMode.light,
              onTap: () => Navigator.pop(context, ThemeMode.light),
            ),
            _ThemeOption(
              icon: Icons.dark_mode_outlined,
              label: l10n.themeDark,
              selected: settings.themeMode == ThemeMode.dark,
              onTap: () => Navigator.pop(context, ThemeMode.dark),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (result != null) settings.setThemeMode(result);
  }

  Future<void> _pickLanguage(SettingsProvider settings) async {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final result = await showModalBottomSheet<Locale>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            _LanguageOption(
              flag: '🇺🇿',
              label: l10n.languageUzbek,
              selected: settings.locale?.languageCode == 'uz',
              onTap: () => Navigator.pop(context, const Locale('uz')),
            ),
            _LanguageOption(
              flag: '🇷🇺',
              label: l10n.languageRussian,
              selected: settings.locale?.languageCode == 'ru',
              onTap: () => Navigator.pop(context, const Locale('ru')),
            ),
            _LanguageOption(
              flag: '🇬🇧',
              label: l10n.languageEnglish,
              selected: settings.locale?.languageCode == 'en',
              onTap: () => Navigator.pop(context, const Locale('en')),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (result != null) settings.setLocale(result);
  }

  Future<void> _onAppLockToggle(bool value, SecurityProvider security) async {
    if (value && !security.hasPin) {
      final created = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => const PinSetupScreen()),
      );
      if (created != true) return; // Пользователь отменил установку PIN.
      return; // setAppLockEnabled(true) уже выставлен внутри PinSetupScreen.
    }
    await security.setAppLockEnabled(value);
    if (!value) {
      await security.setBiometricEnabled(false);
    }
  }

  Future<void> _onBiometricToggle(bool value, SecurityProvider security) async {
    if (value) {
      final ok = await security.authenticateWithBiometrics();
      if (!ok) return;
    }
    await security.setBiometricEnabled(value);
  }

  Future<void> _changePin() async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const PinSetupScreen()),
    );
  }

  String _themeLabel(AppLocalizations l10n, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return l10n.themeSystem;
      case ThemeMode.light:
        return l10n.themeLight;
      case ThemeMode.dark:
        return l10n.themeDark;
    }
  }

  String _languageLabel(AppLocalizations l10n, Locale? locale) {
    switch (locale?.languageCode) {
      case 'uz':
        return l10n.languageUzbek;
      case 'ru':
        return l10n.languageRussian;
      case 'en':
        return l10n.languageEnglish;
      default:
        return l10n.themeSystem;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final settings = context.watch<SettingsProvider>();
    final security = context.watch<SecurityProvider>();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: true,
              titleSpacing: 20,
              title: Text(l10n.accountTitle),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              sliver: SliverList.list(
                children: [
                  _SectionLabel(l10n.accountAppearance),
                  _SettingsCard(
                    children: [
                      _SettingsTile(
                        icon: Icons.palette_outlined,
                        title: l10n.accountTheme,
                        trailingText: _themeLabel(l10n, settings.themeMode),
                        onTap: () => _pickTheme(settings),
                      ),
                      const Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.language_rounded,
                        title: l10n.accountLanguage,
                        trailingText: _languageLabel(l10n, settings.locale),
                        onTap: () => _pickLanguage(settings),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _SectionLabel(l10n.accountSecurity),
                  _SettingsCard(
                    children: [
                      SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        secondary: Icon(Icons.lock_outline_rounded, color: scheme.primary),
                        title: Text(l10n.securityAppLock),
                        subtitle: Text(
                          l10n.securityAppLockSubtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        value: security.appLockEnabled,
                        onChanged: (v) => _onAppLockToggle(v, security),
                      ),
                      if (security.appLockEnabled) ...[
                        const Divider(height: 1),
                        if (security.biometricAvailable)
                          SwitchListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            secondary: Icon(Icons.fingerprint_rounded, color: scheme.primary),
                            title: Text(l10n.securityBiometric),
                            subtitle: Text(
                              l10n.securityBiometricSubtitle,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                            value: security.biometricEnabled,
                            onChanged: (v) => _onBiometricToggle(v, security),
                          ),
                        if (security.biometricAvailable) const Divider(height: 1),
                        _SettingsTile(
                          icon: Icons.pin_outlined,
                          title: l10n.securityChangePin,
                          onTap: _changePin,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),
                  _SectionLabel(l10n.accountAbout),
                  _SettingsCard(
                    children: [
                      _SettingsTile(
                        icon: Icons.info_outline_rounded,
                        title: l10n.accountVersion,
                        trailingText: _version.isEmpty ? '—' : _version,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailingText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: scheme.primary),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText!,
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
          if (onTap != null) ...[
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
          ],
        ],
      ),
      onTap: onTap,
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: selected ? scheme.primary : scheme.onSurfaceVariant),
      title: Text(label),
      trailing: selected ? Icon(Icons.check_rounded, color: scheme.primary) : null,
      onTap: onTap,
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String flag;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.flag,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 22)),
      title: Text(label),
      trailing: selected ? Icon(Icons.check_rounded, color: scheme.primary) : null,
      onTap: onTap,
    );
  }
}
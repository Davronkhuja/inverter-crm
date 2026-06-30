import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/settings_provider.dart';
import 'app_icons.dart';

/// Быстрый доступ к иконкам текущей темы оформления: `context.icons.add`.
/// Не вызывает rebuild при смене иконок отдельно — подписывается на
/// SettingsProvider, как и цвета/шрифты, так что переключение оформления
/// в Account мгновенно обновляет иконки по всему приложению.
extension AppIconsContext on BuildContext {
  AppIconSet get icons => watch<SettingsProvider>().appearanceSpec.icons;
}

import 'package:allin1/core/theme/app_theme.dart';
import 'package:allin1/core/utilities/hydrated_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(ThemeMode.light)) {
    final isDark = hydratedStorage.read('isDark') as bool?;
    if (isDark != null) {
      updateAppTheme(isDark ? ThemeMode.dark : ThemeMode.light);
    } else {
      updateAppTheme(ThemeMode.light);
    }
  }

  static ThemeCubit get(BuildContext context) => BlocProvider.of(context);

  void updateAppTheme([ThemeMode themeMode = ThemeMode.system]) {
    if (themeMode == ThemeMode.system) {
      final currentBrightness =
          AppTheme.currentSystemBrightness ?? Brightness.light;

      currentBrightness == Brightness.light
          ? _setTheme(ThemeMode.light)
          : _setTheme(ThemeMode.dark);
    } else {
      _setTheme(themeMode);
    }
  }

  Future<void> _setTheme(ThemeMode themeMode) async {
    AppTheme.setStatusBarAndNotificationBarColor(themeMode);
    emit(ThemeState(themeMode));
    await hydratedStorage.write('isDark', themeMode == ThemeMode.dark);
  }
}

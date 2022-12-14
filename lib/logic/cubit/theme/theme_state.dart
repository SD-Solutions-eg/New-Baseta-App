part of 'theme_cubit.dart';

class ThemeState {
  final ThemeMode themeMode;

  ThemeState(this.themeMode);

  @override
  String toString() => 'ThemeState(themeMode: $themeMode)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ThemeState &&
      other.themeMode == themeMode;
  }

  @override
  int get hashCode => themeMode.hashCode;
}

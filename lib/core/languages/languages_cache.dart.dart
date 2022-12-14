import 'package:allin1/core/utilities/hydrated_storage.dart';
import 'package:allin1/my_app.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';

const String prefSelectedLanguageCode = "SelectedLanguageCode";

Future<Locale> setLocale(String languageCode) async {
  await hydratedStorage.write(prefSelectedLanguageCode, languageCode);
  return _locale(languageCode);
}

String apiLanguageCode = 'en';

String getApiLanguage() {
  if (apiLanguageCode == 'ar') {
    apiLanguageCode = 'ar';
  }
  return 'lang=$apiLanguageCode';
}

void changeApiLanguageCode(String code) {
  apiLanguageCode = code;
}

Future<Locale> getLocale() async {
  late final String languageCode;
  final cachedLanguage =
      hydratedStorage.read(prefSelectedLanguageCode) as String?;
  if (cachedLanguage != null) {
    languageCode = cachedLanguage;
  } else {
    final locale = await Devicelocale.currentLocale;
    languageCode = locale?.split('_').first ?? 'en';
  }
  apiLanguageCode = languageCode;
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  return languageCode.isNotEmpty
      ? Locale(languageCode, '')
      : const Locale('en', '');
}

Future<void> changeLanguage(
    BuildContext context, String selectedLanguageCode) async {
  final locale = await setLocale(selectedLanguageCode);
  changeApiLanguageCode(selectedLanguageCode);
  MyApp.setLocale(context, locale);
}

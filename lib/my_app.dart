import 'package:allin1/core/constants/app_config.dart';
import 'package:allin1/core/constants/constants.dart';
import 'package:allin1/core/languages/app_localization.dart';
import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/core/languages/languages.dart';
import 'package:allin1/core/languages/languages_cache.dart.dart';
import 'package:allin1/core/theme/app_theme.dart';
import 'package:allin1/core/utilities/hydrated_storage.dart';
import 'package:allin1/logic/cubit/theme/theme_cubit.dart';
import 'package:allin1/presentation/routers/app_router.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    final state = context.findAncestorStateOfType<_MyAppState>();
    if (state != null) {
      state.setLocale(newLocale);
    }
  }
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Locale? _locale;
  bool _isNewUser = true;
  late final AppRouter _appRouter;

  void setLocale(Locale locale) => setState(() => _locale = locale);
  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(context.read<InternetCubit>());

    WidgetsBinding.instance.addObserver(this);

    if (hydratedStorage.read(isNewUserTxt) != null) {
      _isNewUser = hydratedStorage.read(isNewUserTxt) as bool;
    }
  }

  @override
  void didChangePlatformBrightness() {
    context.read<ThemeCubit>().updateAppTheme();
    super.didChangePlatformBrightness();
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _appRouter.dispose();
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isAr = _locale != null && _locale!.languageCode == 'ar';
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: appName,
          theme: AppTheme.getLightTheme(isAr: isAr),
          locale: _locale,
          supportedLocales: const [Locale('en', ''), Locale('ar', '')],
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            CountryLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (final supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode &&
                  supportedLocale.countryCode == locale?.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          builder: (context, navigator) {
            final isAr = Languages.of(context) is LanguageAr;
            final isDark = Theme.of(context).brightness == Brightness.dark;

            return Theme(
              data: (isDark
                  ? AppTheme.getLightTheme(isAr: isAr)
                  : AppTheme.getLightTheme(isAr: isAr))
                ..copyWith(
                    textTheme: Theme.of(context).textTheme.apply(
                          fontSizeDelta: 1,
                        )),
              child: navigator ??
                  Container(
                    width: 200.w,
                    height: 200.w,
                    color: Colors.red,
                  ),
            );
          },
          initialRoute: _isNewUser ? AppRouter.language : AppRouter.splash,
          // initialRoute: _isNewUser ? AppRouter.language : AppRouter.language,
          onGenerateRoute: _appRouter.onGenerateRoute,
        );
      },
    );
  }
}

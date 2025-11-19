import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import './services/rcc_service.dart';
import './components/rcc_scroll.dart';
import './providers/preferences_provider.dart';
import './providers/rcc_provider.dart';
import './l10n/app_localizations.dart';
import './constants.dart';
import './router.dart';
import './utils/theme_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(const RootCorporation());
}

class RootCorporation extends StatelessWidget {
  const RootCorporation({super.key});

  @override
  Widget build(BuildContext context) {
    final rccService = RccService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PreferencesProvider()),
        ChangeNotifierProvider(create: (_) => RccProvider(rccService)),
      ],
      child: DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          // Use dynamic colors if available, otherwise fall back to seed colors
          ColorScheme lightColorScheme;
          ColorScheme darkColorScheme;

          if (lightDynamic != null && darkDynamic != null) {
            // Dynamic colors available (Android 12+)
            lightColorScheme = lightDynamic.harmonized();
            darkColorScheme = darkDynamic.harmonized();
          } else {
            // Fallback to seed-generated colors
            lightColorScheme = ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            );
            darkColorScheme = ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            );
          }

          return Consumer<PreferencesProvider>(
        builder: (context, preferencesProvider, child) {
          return MaterialApp.router(
            title: Constants.projectName,
            debugShowCheckedModeBanner: false,
            scrollBehavior: const RccScrollBehavior(),
            locale: preferencesProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ar'),
              Locale('en'),
              Locale('fa'),
              Locale('hi'),
              Locale('id'),
              Locale('ms'),
              Locale('ru'),
              Locale('tr'),
              Locale('zh', 'CN'),
            ],
            themeMode: preferencesProvider.themeMode,
            theme: ThemeData(
              colorScheme: lightColorScheme,
              useMaterial3: true,
              appBarTheme: AppBarTheme(
                centerTitle: true,
                elevation: 0,
                systemOverlayStyle: ThemeHelper.getSystemUiOverlayStyle(
                  brightness: Brightness.light,
                ),
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Colors.black,
              colorScheme: darkColorScheme.copyWith(
                surface: const Color(0xFF000000),
                surfaceContainer: const Color(0xFF0A0A0A),
              ),
              cardColor: const Color(0xFF0A0A0A),
              canvasColor: Colors.black,
              dialogTheme: const DialogThemeData(
                backgroundColor: Color(0xFF0A0A0A),
              ),
              useMaterial3: true,
              appBarTheme: AppBarTheme(
                centerTitle: true,
                elevation: 0,
                systemOverlayStyle: ThemeHelper.getSystemUiOverlayStyle(
                  brightness: Brightness.dark,
                ),
              ),
            ),
            routerConfig: router,
          );
        },
      );
        },
      ),
    );
  }
}

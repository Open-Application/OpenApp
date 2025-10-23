import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import './services/rcc_service.dart';
import './components/rcc_scroll.dart';
import './providers/preferences_provider.dart';
import './providers/rcc_provider.dart';
import './providers/log_provider.dart';
import './l10n/app_localizations.dart';
import './constants.dart';
import './router.dart';

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
        ChangeNotifierProvider(create: (_) => LogProvider()),
      ],
      child: Consumer<PreferencesProvider>(
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
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark,
                  statusBarBrightness: Brightness.light,
                  systemNavigationBarColor: Colors.transparent,
                  systemNavigationBarIconBrightness: Brightness.dark,
                ),
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Colors.black,
              colorScheme: const ColorScheme.dark(
                primary: Colors.indigo,
                secondary: Colors.indigoAccent,
                surface: Color(0xFF000000),
                surfaceContainer: Color(0xFF0A0A0A),
                onSurface: Colors.white,
                error: Color(0xFFCF6679),
              ),
              cardColor: const Color(0xFF0A0A0A),
              canvasColor: Colors.black,
              dialogTheme: const DialogThemeData(
                backgroundColor: Color(0xFF0A0A0A),
              ),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                centerTitle: true,
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.light,
                  statusBarBrightness: Brightness.dark,
                  systemNavigationBarColor: Colors.transparent,
                  systemNavigationBarIconBrightness: Brightness.light,
                ),
              ),
            ),
            routerConfig: router,
          );
        },
      ),
    );
  }
}

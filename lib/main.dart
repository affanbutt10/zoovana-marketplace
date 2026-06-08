import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'app/core/bootstrap/app_bootstrap.dart';
import 'app/core/controllers/locale_controller.dart';
import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_route_observer.dart';
import 'app/routes/app_routes.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppBootstrap.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // GetBuilder ensures the theme and locale prop re-render when
    // LocaleController.setLocale() calls update(). Get.updateLocale()
    // in setLocale() handles the actual locale propagation to all
    // localisation delegates in real time.
    return GetBuilder<LocaleController>(
      builder: (localeController) {
        return GetMaterialApp(
          title: 'Zoovana',
          debugShowCheckedModeBanner: false,
          locale: localeController.locale,
          fallbackLocale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: buildAppTheme(locale: localeController.locale),
          getPages: AppPages.pages,
          navigatorObservers: [appRouteObserver],
          initialRoute: AppRoutes.splash,
          defaultTransition: Transition.cupertino,
        );
      },
    );
  }
}

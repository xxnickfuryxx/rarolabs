import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rarolabs/src/utils/dependencies.dart';
import 'package:rarolabs/src/view/app_theme.dart';
import 'package:rarolabs/src/view/pages/feed/feed_viewmodel.dart';
import 'package:rarolabs/src/view/pages/login/login_viewmodel.dart';
import 'package:rarolabs/src/view/pages/splash/splash_page.dart';
import 'package:rarolabs/src/view/pages/user_list/user_list_viewmodel.dart';
import 'package:rarolabs/src/view/pages/user_profile/user_profile_viewmodel.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

void main() {
  // Initialize dependency injection
  setupDependencies();
  runApp(const RaroLabsApp());
}

class RaroLabsApp extends StatelessWidget {
  const RaroLabsApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Using MultiProvider to provide all ViewModels to the widget tree
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<LoginViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<UserListViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<FeedViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<UserProfileViewModel>()),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const SplashPage(),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', 'US'), // English
          Locale('pt', 'BR'), // Portuguese
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/splash/splash_screen.dart';
import 'state/history_notifier.dart';
import 'theme/app_theme.dart';

class KahiatraApp extends StatelessWidget {
  const KahiatraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => HistoryNotifier())],
      child: MaterialApp(
        title: 'Kahiatra',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
      ),
    );
  }
}

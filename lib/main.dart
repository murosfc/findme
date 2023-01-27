import 'package:findme/FindnMeHome.dart';
import 'package:findme/drawers/MainDrawer.dart';
import 'package:findme/colors/VisualIdColors.dart';
import 'package:findme/drawers/SearchBar.dart';
import 'package:findme/pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['lib/i18n'];
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        LocalJsonLocalization.delegate,
      ],
      theme: ThemeData(
        primarySwatch: VisualIdColors.colorGreen(),
        scaffoldBackgroundColor: Color.fromRGBO(18, 18, 18, 1),
      ),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('pt', 'BR'),
      ],
      home: LoginPage(), //FindnMeHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sketch_app/providers/language.dart';
import 'package:sketch_app/providers/theme.dart';
import 'package:sketch_app/auth/mainpage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
    child: const MyApp(),
    supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
    saveLocale: true,
    path: 'assets/translations',
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<LanguageProvider>(
              create: (_) => LanguageProvider(),
            ),
            ChangeNotifierProvider<ThemeProvider>(
              create: (_) => ThemeProvider(),
            ),
          ],
          child: Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              return Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    locale: languageProvider.locale,
                    supportedLocales: context.supportedLocales,
                    localizationsDelegates: context.localizationDelegates,
                    theme: themeProvider.themeData,
                    home: const MainPage(),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

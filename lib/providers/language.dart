import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

//Language Provider
class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en', 'US'); // Varsayılan dil İngilizce

  Locale get locale => _locale;

  void setLocale(BuildContext context, Locale locale) {
    if (locale != _locale) {
      _locale = locale;
      EasyLocalization.of(context)!.setLocale(locale);// Easy Localization ile dil değiştirme
      notifyListeners();
    }
  }
}
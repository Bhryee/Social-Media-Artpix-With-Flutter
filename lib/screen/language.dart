import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:sketch_app/providers/language.dart';
import '../main.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Uygulama Dili'.tr(),
          style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
        ),
        centerTitle: false,
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
          child: Column(
            children: [
              ListTile(
                title: Text('Turkish', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),),
                onTap: () {
                  Provider.of<LanguageProvider>(context, listen: false)
                      .setLocale(context, Locale('tr', 'TR'));
                },
              ),

              ListTile(
                title: Text('English', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),),
                onTap: () {
                  Provider.of<LanguageProvider>(context, listen: false)
                      .setLocale(context, Locale('en', 'US'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


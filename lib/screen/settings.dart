import 'package:flutter/material.dart';
import 'package:sketch_app/screen/language.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:sketch_app/providers/theme.dart';
import 'package:sketch_app/theme/theme.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isSwitched = themeProvider.themeData == darkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Ayarlar'.tr()),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 35),
          child: Column(
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LanguageScreen(),
                      ),
                    );
                  },
                  child: SettingRow(icon: Icons.translate_outlined, text: 'Dil'.tr(),trailing: Icon(Icons.arrow_forward_ios_rounded),)),
              SizedBox(
                height: 15,
              ),
              SettingRow(
                icon: Icons.remove_red_eye_outlined,
                text: 'Tema'.tr(),
                trailing: Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                      themeProvider.switchTheme();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget SettingRow({required IconData icon, required String text, Widget? trailing}) {
    return Row(
      children: [
        Icon(icon),
        SizedBox(width: 10),
        Text(text, style: TextStyle(fontSize: 18)),
        Spacer(),
        trailing ?? Icon(Icons.arrow_forward_ios_rounded),
      ],
    );
  }
}

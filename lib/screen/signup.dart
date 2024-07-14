import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sketch_app/data/firebase_servise/firebase_auth.dart';
import 'package:sketch_app/util/dialog.dart';
import 'package:sketch_app/util/exeption.dart';
import 'package:sketch_app/util/imagepicker.dart';
import 'package:easy_localization/easy_localization.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback show;

  SignupScreen(this.show, {super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final email = TextEditingController();
  FocusNode email_F = FocusNode();
  final password = TextEditingController();
  FocusNode password_F = FocusNode();
  final username = TextEditingController();
  FocusNode username_F = FocusNode();
  final passwordConfirme = TextEditingController();
  FocusNode passwordConfirme_F = FocusNode();
  final bio = TextEditingController();
  FocusNode bio_F = FocusNode();
  File? _imageFile;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password.dispose();
    passwordConfirme.dispose();
    username.dispose();
    bio.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 96, height: 30),
              Center(
                  child: SizedBox(
                      width: 260,
                      height: 260,
                      child: Image.asset('images/sign-up.png'))),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  "Yeni hesap oluşturun".tr(),
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: InkWell(
                onTap: () async {
                  File _imagefilee = await ImagePickerService().uploadImage('gallery');
                  setState(() {
                    _imageFile = _imagefilee;
                  });
                },
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.grey,
                  child: _imageFile == null
                      ? CircleAvatar(
                          radius: 34,
                          backgroundImage: AssetImage('images/person.png'),
                          backgroundColor: Colors.grey.shade200,
                        )
                      : CircleAvatar(
                          radius: 34,
                          backgroundImage: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                          ).image,
                          backgroundColor: Colors.grey.shade200,
                        ),
                ),
                            ),
              ),



              SizedBox(height: 20),
              Textfield(username, Icons.person, 'Kullanıcı adı'.tr(), username_F),
              SizedBox(height: 10),
              Textfield(email, Icons.email, 'Email', email_F),
              SizedBox(height: 10),
              Textfield(password, Icons.lock, 'Şifre'.tr(), password_F,
                  obscureText: true),
              SizedBox(height: 10),
              Textfield(passwordConfirme, Icons.lock, 'Şifre Tekrar'.tr(),
                  passwordConfirme_F,
                  obscureText: true),
              SizedBox(height: 10),
              Textfield(bio, Icons.abc, 'Bio', bio_F),
              SizedBox(height: 20),
              Signup(),
              SizedBox(height: 20),
              DontHaveAcount()
            ],
          ),
        ),
      ),
    );
  }

  Widget DontHaveAcount() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Zaten hesabın var mı? '.tr()),
          GestureDetector(
            onTap: widget.show,
            child: Text(
              'Giriş yap'.tr(),
              style: TextStyle(
                  color: const Color(0xFF215969),
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: const Color(0xFF215969)),
            ),
          )
        ],
      ),
    );
  }

  Widget Signup() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: InkWell(
        onTap: () async {
          try {
            await Authentication().Signup(
                email: email.text,
                password: password.text,
                passwordConfirme: passwordConfirme.text,
                username: username.text,
                bio: bio.text,
                profile: _imageFile ?? File(''),);
          } on exceptions catch (e) {
            dialogBuilder(context, e.message);
          }
        },
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFF215969),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              'Kayıt Ol'.tr(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget ForgotPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        children: [
          Spacer(),
          Text(
            'Şifremi unuttum'.tr(),
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget Textfield(TextEditingController controller, IconData icon, String type,
      FocusNode focusNode,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 13.0),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: type,
              prefixIcon: Icon(
                icon,
                color: focusNode.hasFocus ? Colors.black : Colors.grey,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            ),
            controller: controller,
            focusNode: focusNode,
            obscureText: obscureText,
          ),
        ),
      ),
    );
  }
}

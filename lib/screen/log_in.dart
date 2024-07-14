import 'package:flutter/material.dart';
import 'package:sketch_app/data/firebase_servise/firebase_auth.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback show;
  LoginScreen(this.show, {super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  FocusNode email_F = FocusNode();
  final password = TextEditingController();
  FocusNode password_F = FocusNode();

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        //resizeToAvoidBottomInset: false,
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
                    child: Image.asset('images/log-in.png')),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  "Hesabınıza giriş yapın".tr(),
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              Textfield(email, Icons.email, 'Email', email_F),
              SizedBox(height: 10),
              Textfield(password, Icons.lock, 'Şifre'.tr(), password_F,
                  obscureText: true),
              SizedBox(height: 20),
              ForgotPassword(),
              SizedBox(height: 20),
              Login(),
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
          Text('Hesabın yok mu? '.tr()),
          GestureDetector(
            onTap: widget.show,
            child: Text(
              'Kayıt ol'.tr(),
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

  Widget Login() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: InkWell(

      onTap: () async{
        await Authentication().Login(email: email.text, password: password.text);
      },
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFF215969),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              'Giriş Yap'.tr(),
              style: TextStyle(
                  color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
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
            style: TextStyle(fontSize: 15, color: const Color(0xFF215969)),
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

import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/ui/pages/auth/login_page/login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    dio.get("/init/download").then((value) {
      print(value);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    });

    // 스플래시 화면을 보여준 후 다음 화면으로 이동
    // Future.delayed(Duration(seconds: 5), () {
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/splash.gif',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

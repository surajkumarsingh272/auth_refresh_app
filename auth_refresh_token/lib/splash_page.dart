import 'package:auth_refresh_token/home_page.dart';
import 'package:auth_refresh_token/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    var authProvider = Provider.of<AuthProvider>(context,listen: false);
    authProvider.checkLoginStatus().then((value) {
      if(authProvider.isLoggedIn == true){
        authProvider.refreshToken();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(),), (route) => false,);
      }else{
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage(),), (route) => false,);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Loading")
        ],
      ),
    );
  }
}

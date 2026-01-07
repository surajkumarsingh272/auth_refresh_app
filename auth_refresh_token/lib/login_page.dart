import 'package:auth_refresh_token/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: authProvider.emailController,
          ),
          TextField(
            controller: authProvider.passwordController,
          ),

          TextButton(onPressed: ()async {
            await authProvider.login();
            if(authProvider.isLoggedIn == true){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(),), (route) => false,);
            }else{
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authProvider.message)));
            }
          }, child: Text("Login Now")),

        ],
      ),
    );
  }
}

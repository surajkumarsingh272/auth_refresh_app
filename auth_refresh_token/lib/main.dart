import 'package:auth_refresh_token/auth_provider.dart';
import 'package:auth_refresh_token/splash_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      MultiProvider(providers: [ ChangeNotifierProvider(create: (context) => AuthProvider(),)], child: MyApp(),)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashPage(),
    );
  }
}

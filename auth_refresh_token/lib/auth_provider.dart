import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class AuthProvider with ChangeNotifier{
  bool isLoggedIn = false;
  String message = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login()async{
    var reqBody = {
      "email":emailController.text,
      "password":passwordController.text
    };
    var res = await http.post(Uri.parse("https://shop-sathi-api.onrender.com/login"), body: reqBody);
    var jsonRes = jsonDecode(res.body);

    if(res.statusCode == 200 ){
      var token = jsonRes['accessToken'];
      var refreshToken = jsonRes["refreshToken"];
      await storeToken(token, refreshToken);
      isLoggedIn = true;
      notifyListeners();
    }else{
      message = jsonRes['message'];
      notifyListeners();
    }
  }

   storeToken(String token,String refreshToken)async{
    var currentDate = DateTime.now();
    String date = currentDate.toString().split(' ')[0];

    var sharePref =await SharedPreferences.getInstance();
   sharePref.setString("token", token);
   sharePref.setString("refreshToken", refreshToken);
   sharePref.setString("loginDate",date);
  }

  updateToken(String token)async{
    var sharePref =await SharedPreferences.getInstance();
    sharePref.setString("token", token);
  }

  checkLoginStatus()async{
    var sharePref = await SharedPreferences.getInstance();

    var currentDate = DateTime.now();
    String myDateStr = sharePref.getString("loginDate")??"";
    DateTime myDate = DateTime.parse(myDateStr);
    DateTime today = DateTime(currentDate.year, currentDate.month, currentDate.day,);
    if (myDate.isAfter(today)) {
      sharePref.clear();
      isLoggedIn = false;
      notifyListeners();
      return;
    }

    var token = sharePref.getString("token");
    var refreshToken = sharePref.getString("refreshToken");
    if(token != null && refreshToken != null){
      isLoggedIn = true;
      notifyListeners();
    }
  }



  refreshToken()async{
    var sharePref = await SharedPreferences.getInstance();
    var refreshToken = sharePref.getString("refreshToken");
    var reqBody = {
      "refreshToken":refreshToken,
    };
    var res = await http.post(Uri.parse("https://shop-sathi-api.onrender.com/refresh-token"), body: reqBody);
    var jsonRes = jsonDecode(res.body);

    if(res.statusCode == 200 ){
      var token = jsonRes['accessToken'];
      await updateToken(token);
      isLoggedIn = true;
      notifyListeners();
    }else{
      message = jsonRes['message'];
      if(message == "TokenExpire"){

      }
      notifyListeners();
    }
  }

  logout(){
    isLoggedIn = false;
    notifyListeners();

  }
}
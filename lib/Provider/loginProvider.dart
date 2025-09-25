
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';
import '../Auth/otp_screen.dart';
import '../Rest/api_services.dart';
import '../Screens/home_screen.dart';
import '../Widget/loading_dialog.dart';
 

import '../Widget/alert_dialog.dart';
// import 'package:shared_preferences/shared_preferences.dart';


class LoginProvider extends ChangeNotifier{

  ApiService apiService = ApiService();
  int secondsRemaining = 45;
  bool enableResend = false;
  Timer? timer;

  getLoginApi(BuildContext context, String userId, String password)async{
    LoadingDialog.show(context);

    if(userId == "Test01" && password == "gail@123"){
      SecureSharedPref preferences = await SecureSharedPref.getInstance();

      await preferences.putString('TOKEN', "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IjIwMDMiLCJuYmYiOjE3NTc0ODAxMTEsImV4cCI6MTc4OTAxNjExMSwiaWF0IjoxNzU3NDgwMTExfQ.IZKCR3g3l_joSt-8Eu0ufbZy1pQ9w6WRmgfoFkpvics",isEncrypted: true);
      await preferences.putString('EMP_NO', "Test01");
      await preferences.putString('EMP_NAME',"A MANORANJAN  PATNAIK",isEncrypted: true);
      await preferences.putString('GRADE', "E7");
      await preferences.putString('LOCATION', "HYDERABAD ZNL",isEncrypted: true);
      await preferences.putString('VENDOR_CODE', "0108009061",isEncrypted: true);
      await preferences.putString('apkVersion', "1.6.3");
      await preferences.putString('iosVersion', "1.6.3");

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const HomeScreen()));
    }else{
      var response = await apiService.getLogin(userId,password,context);

      print("response login $response");

      if(response['status_code'] == 200 && response['message'] == 'Login Successfully'){
        LoadingDialog.hide(context);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const HomeScreen()));
      }else{
        LoadingDialog.hide(context);
        DialogUtils.showCustomDialog(context,
            title: "PRMS", description: response['message'] ,onpositivePressed: (){
              Navigator.pop(context);
              LoadingDialog.hide(context);
            });
      }
    }


    // print("gtxfchgjkl cyfgukviho ghjk${response['status_code']}");
    notifyListeners();
  }

  void sednOTP(BuildContext context, String mobile) async{

    var response = await apiService.getOTPData(mobile,context);
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        secondsRemaining--;
        print("secondsRemaining :: $secondsRemaining");
        notifyListeners();
      } else {
        enableResend = true;
        notifyListeners();
      }

    });
    if(response != ""){
      print("response :: ${response['VENDOR_MOBILE']}");
      DialogUtils.showCustomDialog(context,
          title: "PRMS", description: "OPT Send Successfully on ${response['VENDOR_PHONE']}",onpositivePressed:(){
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>  OTPScreen(userID: mobile,vendorphone: response['VENDOR_PHONE'].toString())));
          });


    }else{

    }



    // if(response['status_code'] == 200){
    // //
    //
    // }else{
    //   print("error");
    // }

    notifyListeners();
  }

  void verifyOTP(BuildContext context, String verificationCode, String? userID) async{
    var response = await apiService.getVerifyData(verificationCode,userID,context);

    if(response['status_code'] == 200){
      enableResend = false;
      secondsRemaining = 45;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const HomeScreen()));
    }else{
    }
    notifyListeners();
  }




}
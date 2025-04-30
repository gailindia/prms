import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Auth/login_screen.dart';
import '../Screens/home_screen.dart';
// import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
 
import 'package:root_checker_plus/root_checker_plus.dart';
// import 'package:root_checker_plus/root_checker_plus.dart';
import 'package:secure_shared_preferences/secure_shared_preferences.dart';


// import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool? _jailbroken = false;
  bool? _eveloperMode = false;
  bool? _rooted = false;
  String? empno;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // isCheckJailbreak();
    // isCheckRooted();
    if(Platform.isAndroid){
      if(_rooted == null){

      }
      if(_rooted == false){
        navigateScreen();
      }else{
        // navigateScreen();
        // print("_jailbroken  ${jailbroken}");
      }
    }

    if(Platform.isIOS) {
      if (_jailbroken == null) {

      }
      if (_jailbroken == false) {
        navigateScreen();
      } else {
        // navigateScreen();
        // print("_jailbroken  ${jailbroken}");
      }
    }



  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/gaillogo.png'),
      ),
    );
  }

  void navigateScreen() async{
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    SecureSharedPref sharedPreferences = await SecureSharedPref.getInstance();
    try{
      await Future.delayed(const Duration(seconds: 3));
      // ignore: use_build_context_synchronously
      empno = await sharedPreferences.getString('EMP_NO');
      // if(Platform.isAndroid){
      //   empno = await sharedPreferences.getString('EMP_NO',isEncrypted: true);
      // }else{
      //   empno = await sharedPreferences.getString('EMP_NO') ?? "";
      // }

      if (empno == null || empno == "") {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    }catch(e){
    }
  }
  Future<void> isCheckRooted() async{
    bool _checkRooted;
    bool developerMode;
    try{
      _checkRooted = (await RootCheckerPlus.isRootChecker())! ;
      developerMode = (await RootCheckerPlus.isDeveloperMode())! ;
      print("Android :: $_checkRooted $developerMode");
    } on PlatformException {
      _checkRooted = true;
      developerMode = true;
    }
    if(!mounted) return;
    setState(() {
      _rooted = _checkRooted;
      _eveloperMode = developerMode;
    });
  }

  // Future<void> isCheckJailbreak() async {
  //
  //   bool jailbroken;
  //   bool developerMode;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     jailbroken = await FlutterJailbreakDetection.jailbroken;
  //     developerMode = await FlutterJailbreakDetection.developerMode;
  //
  //     print("jainbreak :: $jailbroken $developerMode");
  //
  //   } on PlatformException {
  //     jailbroken = true;
  //     developerMode = true;
  //   }
  //
  //   if (!mounted) return;
  //
  //   setState(() {
  //     _jailbroken = jailbroken;
  //     _eveloperMode = developerMode;
  //   });
  // }


}

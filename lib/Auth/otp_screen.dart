import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:prms/Provider/loginProvider.dart'; 
import 'package:provider/provider.dart';



class OTPScreen extends StatefulWidget {
  final String? userID,vendorphone;
  const OTPScreen({super.key, required this.userID,required this.vendorphone});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String? verifyOTPCode;



  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Padding(
          padding: const EdgeInsets.only(right: 50.0),
          child: Text("OTP",textScaleFactor: 1.2,style: TextStyle(color: Colors.grey),),
        )),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Image.asset('assets/images/otp_image.png'),
              SizedBox(
                height: 20,
              ),
              Text("Verification Code",textScaleFactor: 1.2,style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.w700),),
              SizedBox(
                height: 20,
              ),
              Text("We have send OTP code verification",textScaleFactor: 1.2,style: TextStyle(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.w600),),

              Text("to your mobile no",textScaleFactor: 1.2,style: TextStyle(color: Colors.grey,fontSize: 14,fontWeight: FontWeight.w600),),
              SizedBox(
                height: 40,
              ),
              Text("+91-${widget.vendorphone!.substring(0,6)}****",textScaleFactor: 1.2,style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w700),),
              SizedBox(
                height: 40,
              ),
              OtpTextField(
                numberOfFields: 6,
                fieldWidth: 50,
                borderColor: Color(0xFF512DA8),
                //set to true to show as box or false to show as dash
                showFieldAsBox: true,
                borderRadius: BorderRadius.circular(20),
                //runs when a code is typed in
                onCodeChanged: (String code) {
                  //handle validation or checks here
                },
                //runs when every textfield is filled
                onSubmit: (String verificationCode){
                  verifyOTPCode = verificationCode;
                  setState(() {
                  });
                  // showDialog(
                  //     context: context,
                  //     builder: (context){
                  //       return AlertDialog(
                  //         title: Text("Verification Code"),
                  //         content: Text('Code entered is $verificationCode'),
                  //       );
                  //     }
                  // );
                }, // end onSubmit
              ),
              InkWell(
                onTap: () {
                  loginProvider.sednOTP(context,widget.vendorphone!);
                },
                child: Visibility(
                  visible: loginProvider.enableResend,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Resend OTP',
                      textScaleFactor: 1.2,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueAccent),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: !loginProvider.enableResend,
                child: Text(
                  'Insert OTP within ${loginProvider.secondsRemaining} seconds',
                  textScaleFactor: 1.2,
                  style: TextStyle(
                      color: Colors.black, fontSize: 14),
                ),
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar:   Padding(
        padding: const EdgeInsets.only(left: 20.0,right: 20,bottom: 40),
        child: Container(
            width: MediaQuery.of(context).size.width*1,

            child: ElevatedButton(

                onPressed: (){
                  if(verifyOTPCode!.length == 6){
                    loginProvider.verifyOTP(context,verifyOTPCode!,widget.userID);
                  }


                  // if (_formKey.currentState!.validate()) {
                  //   _formKey.currentState!.save();
                  //   loginProvider.getLoginApi(context,userIDController.text,passwordController.text);
                  // }
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const OTPScreen()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    textStyle: TextStyle(
                      // fontSize: 30,
                        fontWeight: FontWeight.bold)),
                child: const Text("Submit",textScaleFactor: 1.2,style: TextStyle(color: Colors.white),))),
      ),
    );
  }


}




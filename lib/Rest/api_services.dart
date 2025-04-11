import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:prms/Auth/login_screen.dart';
import 'package:prms/Model/claim_status_details.dart';
import 'package:prms/Model/claim_status_model.dart';
import 'package:prms/Model/claim_type_model.dart';
import 'package:prms/Model/other_claim_model.dart';
import 'package:prms/Model/req_details_model.dart';
import 'package:prms/Model/system_of_medicine_model.dart';
import 'package:prms/Rest/services.dart';
import 'package:prms/Screens/home_screen.dart';
import 'package:prms/Widget/alert_dialog.dart';
import 'package:prms/Widget/loading_dialog.dart'; 
import 'package:secure_shared_preferences/secure_shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import '../routes.dart';

class ApiService extends Services{

  Future getLogin(String userId, String password, BuildContext context) async{
    SecureSharedPref preferences = await SecureSharedPref.getInstance();
    try {

      String apiurl = "$kBaseUrl$kIsLoginApi";
      Map<String, String>? _body;
      _body = {
        "userid":userId,
        "password":password
      };

      http.Response response = await http.post(Uri.parse(apiurl),body: _body);
      var getData= jsonDecode(response.body);
      print("getData :: $getData");
      if (response.statusCode == 200 && getData['message']=='Login Successfully') {
        // var getData = response.body;
       await preferences.putString('TOKEN', getData['TOKEN'],isEncrypted: true);
       await preferences.putString('EMP_NO', getData['EMP_CPF']);
       await preferences.putString('EMP_NAME', getData['EMP_NAME'],isEncrypted: true);
       await preferences.putString('GRADE', getData['GRADE']);
       await preferences.putString('LOCATION', getData['LOCATION'],isEncrypted: true);
       await preferences.putString('VENDOR_CODE', getData['VENDOR_CODE'],isEncrypted: true);
       await preferences.putString('apkVersion', getData['APK_INFO'][0]['APK_VERSION']);
       await preferences.putString('iosVersion', getData['APK_INFO'][0]['IPA_VERSION']);
       // print(getData);
        // prefs.setString('Token', response.body[0]);

        return getData;
      }else {
        DialogUtils.showCustomDialog(context,
            title: "PRMS", description: getData["message"],onpositivePressed: (){
              Navigator.pop(context);
              LoadingDialog.hide(context);
            });

      }
    } on TimeoutException catch (e) {
    } on SocketException catch (e) {

    }
    return "";
  }

  Future getVersion(BuildContext context) async{
    SecureSharedPref prefs = await SecureSharedPref.getInstance();
    try {

      // SharedPreferences preferences  =await SharedPreferences.getInstance();
      String apiurl = "$kBaseUrl$kIsVersionApi";

      // Map<String,String> header = {
      //   'Authorization': 'Bearer ${prefs.getString('Token')}'
      // };
      String? token = (await prefs.getString('TOKEN',isEncrypted: true));
      Map<String,String> header = {
        'Authorization': 'Bearer $token'
      };
      http.Response response = await http.get(Uri.parse(apiurl),headers: header);
      if (response.statusCode == 200) {
        // var getData = response.body;
        var getData= jsonDecode(response.body);
        await prefs.putString('apkVersion', getData['APK_INFO'][0]['APK_VERSION']);
        await prefs.putString('iosVersion', getData['APK_INFO'][0]['IPA_VERSION']);
        print("kIsVersionApi :; ${getData['APK_INFO'][0]['APK_VERSION']}");
        return getData;
      }else {
        ///TODO need to check
        // DialogUtils.showCustomDialog(context,
        //     title: "PRMS", description: "Something went wrong",onpositivePressed: (){
        //       // Navigator.of(context, rootNavigator: true).pop('dialog')
        //       LoadingDialog.hide(context);
        //     });
        // await showConfirmationDialog(
        //     context,
        //     title: "Alert!!",
        //     description: 'Invalid User ID or password..',
        //     onNegativePressed: () async {
        //       Navigator.pop(context);
        //
        //     },
        //     onPositivePressed: () async {
        //       Navigator.pop(context);
        //     });
        // return "";
      }
    } on TimeoutException catch (e) {
    } on SocketException catch (e) {

    }
    return "";
  }


  Future getAll(String? opdClaim) async{
    SecureSharedPref prefs = await SecureSharedPref.getInstance();
    try {

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String apiurl = "https://gailebank.gail.co.in/webservices/PRMS_MOB/api/PRMS/GetClaimTypes?type=$opdClaim";
      String apiurl = "$kBaseUrl$kGetClaimTypes$opdClaim";
      String? token = (await prefs.getString('TOKEN',isEncrypted: true));
      Map<String,String> header = {
        'Authorization': 'Bearer $token'
      };
      http.Response response = await http.get(Uri.parse(apiurl),headers: header);
      if (response.statusCode == 200) {
        var getData = response.body;
        return HomeModelFromJson(getData);
      }else {
        return null;
      }
    } on TimeoutException catch (e) {
    } on SocketException catch (e) {

    }
  }
  Future getPatientName() async{
    SecureSharedPref preferences = await SecureSharedPref.getInstance();
    try {

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String apiurl = "https://gailebank.gail.co.in/webservices/PRMS_MOB/api/PRMS/GetpatientName?user_id=2003";
      String? token = (await preferences.getString('TOKEN',isEncrypted: true));
      String? empno = (await preferences.getString('EMP_NO'));
      String apiurl = "$kBaseUrl$kGetpatientName$empno";

      Map<String,String> header = {
        'Authorization': 'Bearer $token'
      };
      http.Response response = await http.get(Uri.parse(apiurl),headers: header);
      if (response.statusCode == 200) {
        var getData = response.body;
        return HomeModelFromJson(getData);
      }else {
        return null;
      }
    } on TimeoutException catch (e) {
    } on SocketException catch (e) {

    }
  }
  Future getSystemMedicine() async{
    SecureSharedPref preferences = await SecureSharedPref.getInstance();
    try {

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String apiurl = "https://gailebank.gail.co.in/webservices/PRMS_MOB/api/PRMS/GetSystemMedicine";
      String apiurl = "$kBaseUrl$kGetSystemMedicine";
      String? token = (await preferences.getString('TOKEN',isEncrypted: true));
      Map<String,String> header = {
        'Authorization': 'Bearer $token'
      };
      http.Response response = await http.get(Uri.parse(apiurl),headers: header);
      if (response.statusCode == 200) {
        var getData = response.body;
        return SystemMedicineModelFromJson(getData);
      }else {
        return null;
      }
    } on TimeoutException catch (e) {
    } on SocketException catch (e) {

    }
  }
  Future getChronicalNormal() async{
    SecureSharedPref preferences = await SecureSharedPref.getInstance();
    try {

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String apiurl = "https://gailebank.gail.co.in/webservices/PRMS_MOB/api/PRMS/GetSystemMedicine";
      String apiurl = "$kBaseUrl$kGetChronicalNormal";
      String? token = (await preferences.getString('TOKEN',isEncrypted: true));
      Map<String,String> header = {
        'Authorization': 'Bearer $token'
      };
      http.Response response = await http.get(Uri.parse(apiurl),headers: header);

      if (response.statusCode == 200) {
        var getData = response.body;
        return HomeModelFromJson(getData);
      }else {
        return null;
      }
    } on TimeoutException catch (e) {

    } on SocketException catch (e) {

    }
  }
  Future getkGetOtherClaimlist() async{
    SecureSharedPref preferences = await SecureSharedPref.getInstance();
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String apiurl = "https://gailebank.gail.co.in/webservices/PRMS_MOB/api/PRMS/GetSystemMedicine";
      String apiurl = "$kBaseUrl$kGetOtherClaim";
      String? token = (await preferences.getString('TOKEN',isEncrypted: true));
      Map<String,String> header = {
        'Authorization': 'Bearer $token'
      };
      http.Response response = await http.get(Uri.parse(apiurl),headers: header);

      if (response.statusCode == 200) {
        var getData = response.body;
        return ClaimOtherModelFromJson(getData);
      }else {
        return null;
      }
    } on TimeoutException catch (e) {
    } on SocketException catch (e) {

    }
  }


  Future medicalClaimStatusData() async{
    SecureSharedPref preferences = await SecureSharedPref.getInstance();
    try {
      String apiurl = "$kBaseUrl$kGetClaimStatusList";
      String? token = (await preferences.getString('TOKEN',isEncrypted: true));
      String? empno = (await preferences.getString('EMP_NO'));
      Map<String, String>? _body;
      _body = {
        "userid":empno.toString(),

      };
      Map<String,String> header = {
        'Authorization': 'Bearer $token'
        // 'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IjIwMDMiLCJuYmYiOjE3MDc4ODY2NTMsImV4cCI6MTcwOTE4MjY1MywiaWF0IjoxNzA3ODg2NjUzfQ.-SFUkj8bX3KorUa8BKF0fpxj383dLlsZRPTrIzqTRjE'
      };

      http.Response response = await http.post(Uri.parse(apiurl),body: _body,headers: header);
      if (response.statusCode == 200) {
        // var getData;
        // if(response.body.isNotEmpty) {
        //    getData= json.decode(response.body);
        // }
        var getData = response.body;
        // var getData= jsonDecode(response.body);

        // print(getData);
        // prefs.setString('Token', response.body[0]);

        return ClaimModelFromJson(getData);
      }else {
        return "";
      }
    } on TimeoutException catch (e) {

    } on SocketException catch (e) {

    }
    return "";
  }
  Future gettreatementType() async{
    SecureSharedPref preferences = await SecureSharedPref.getInstance();
    try {

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String apiurl = "https://gailebank.gail.co.in/webservices/PRMS_MOB/api/PRMS/GetSystemMedicine";
      String apiurl = "$kBaseUrl$kGetTreatmenttype";
      String? token = (await preferences.getString('TOKEN',isEncrypted: true));
      Map<String,String> header = {
        'Authorization': 'Bearer $token'
      };
      http.Response response = await http.get(Uri.parse(apiurl),headers: header);
      if (response.statusCode == 200) {
        var getData = response.body;
        return SystemMedicineModelFromJson(getData);
      }else {
        return null;
      }
    } on TimeoutException catch (e) {

    } on SocketException catch (e) {

    }
  }
  Future getDomiciliaryAPi() async{
    SecureSharedPref preferences = await SecureSharedPref.getInstance();
    try {

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String apiurl = "https://gailebank.gail.co.in/webservices/PRMS_MOB/api/PRMS/GetSystemMedicine";
      String apiurl = "$kBaseUrl$kGetDomiciliaryTreat";
      String? token = (await preferences.getString('TOKEN',isEncrypted: true));
      Map<String,String> header = {
        'Authorization': 'Bearer $token'
      };
      http.Response response = await http.get(Uri.parse(apiurl),headers: header);
      if (response.statusCode == 200) {
        var getData = response.body;
        return SystemMedicineModelFromJson(getData);
      }else {
        return null;
      }
    } on TimeoutException catch (e) {
    } on SocketException catch (e) {

    }
  }
  Future getGetCriticalApi() async{
    SecureSharedPref preferences = await SecureSharedPref.getInstance();
    try {

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String apiurl = "https://gailebank.gail.co.in/webservices/PRMS_MOB/api/PRMS/GetSystemMedicine";
      String apiurl = "$kBaseUrl$kGetCriticalIllness";
      String? token = (await preferences.getString('TOKEN',isEncrypted: true));
      Map<String,String> header = {
        'Authorization': 'Bearer $token'
      };
      http.Response response = await http.get(Uri.parse(apiurl),headers: header);
      if (response.statusCode == 200) {
        var getData = response.body;
        return SystemMedicineModelFromJson(getData);
      }else {
        return null;
      }
    } on TimeoutException catch (e) {
    } on SocketException catch (e) {

    }
  }


  Future medicalClaimDetailsData() async{
    SecureSharedPref preferences = await SecureSharedPref.getInstance();
    try {

      // SharedPreferences preferences  =await SharedPreferences.getInstance();
      String apiurl = "$kBaseUrl$kGetClaimDetailsList";
      String? token = (await preferences.getString('TOKEN',isEncrypted: true));
      String? empno = (await preferences.getString('EMP_NO'));
      Map<String, String>? _body;
      _body = {
        "userid":empno.toString(),

      };
      Map<String,String> header = {
        'Authorization': 'Bearer $token'
        // 'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IjIwMDMiLCJuYmYiOjE3MDc4ODY2NTMsImV4cCI6MTcwOTE4MjY1MywiaWF0IjoxNzA3ODg2NjUzfQ.-SFUkj8bX3KorUa8BKF0fpxj383dLlsZRPTrIzqTRjE'
      };

      http.Response response = await http.post(Uri.parse(apiurl),body: _body,headers: header);
      if (response.statusCode == 200) {

        var getData = response.body;
        return ClaimDetailsModelFromJson(getData);
      }else {
        return "";
      }
    } on TimeoutException catch (e) {

    } on SocketException catch (e) {

    }
    return "";
  }


  Future getAddtoList(BuildContext context, String claimtype, String patientname, String consulationNumber, String consultationDate, String systemofmedicine, String physicianName, String chronical, String amount, String remarks, String base64string, String billNo, String dischargedate, String admissiondate, String domiciliary, String critical, String illness, String claimtypeother, String treatment, String filetype, String billDate, String prescriptionDate, String namelab, String perticularoftest, String fin_year,
      String base64stringDoc,String filetypeDoc, String  approvalTaken, String block_year) async{
    SecureSharedPref preferences = await SecureSharedPref.getInstance();
    try {
      LoadingDialog.show(context);

      // SharedPreferences preferences  =await SharedPreferences.getInstance();
      String cdate,adate,disdate,pdate;
      if(consultationDate == "--Select Date--" || consultationDate == ""){
        cdate = billDate;
      }else{
        cdate = consultationDate;
      }
      if(prescriptionDate == "--Select Date--" || prescriptionDate == ""){
        pdate = "";
      }else{
        pdate = prescriptionDate;
      }

      if(admissiondate == "--Select Date--" || admissiondate == ""){
        adate = "";
      }else{
        adate = admissiondate;
      }

      if(dischargedate == "--Select Date--" || dischargedate == ""){
        disdate = "";
      }else{
        disdate = dischargedate;
      }
      String? token = (await preferences.getString('TOKEN',isEncrypted: true));
      String? vendorid = (await preferences.getString('VENDOR_CODE',isEncrypted: true));
      String? empno = (await preferences.getString('EMP_NO'));
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var data = json.encode({
        "vendorId":vendorid,
        "userid":empno,
        "claimType":claimtype == "" ?"":claimtype,
        "patientName":patientname == ""?"":patientname,
        "consulationNo":consulationNumber == ""?billNo:consulationNumber,
        "consulationDate":cdate,
        "medicineSystem":systemofmedicine == ""?"":systemofmedicine,
        "physicianName":physicianName == ""?"":physicianName,
        "illnessType":chronical == ""?"":chronical,
        "amtClaimed":amount == ""?"":amount,
        "remarks":remarks == ""?"":remarks,
        "dentalNormal":"",
        "claimOtherType":claimtypeother == ""?"":claimtypeother,
        "admDate":adate,
        "dischrgDate":disdate,
        "treatmentType":treatment==""?"":treatment,
        "saveCriticalIllness":critical == ""?"":critical,
        "illnessDetails":illness == ""?"":illness,
        "domicilaryTreatment":domiciliary == ""?"":domiciliary,
        "claimCheckprior":"",
        "prescriptionDate":pdate,
        "labName":namelab == "" ?"":namelab,
        "testParticulars":perticularoftest == "" ?"":perticularoftest,
        "majorclaim" : "OPD",
        "filetype":filetype == ""?"":filetype,
        "filetypeDoc":filetypeDoc == "" ? "" : filetypeDoc,
        "fin_year" : fin_year,
        "approvalTaken":approvalTaken == "" ? "0" : approvalTaken,
        "block_year":block_year,
        "imgDocName":base64stringDoc == "" ? "" : base64stringDoc,
        "imgName":base64string == ""?"":base64string


      });

    print("kGetPrmsOPDraft data :: $data");

      // var dio = Dio();
      // var response = await dio.request(
      //   "$kBaseUrl$kGetPrmsOPDraft",
      //   options: Options(
      //     method: 'POST',
      //     headers: headers,
      //   ),
      //   data: data,
      // );

      var response = await http.post(
          Uri.parse("$kBaseUrl$kGetPrmsOPDraft"), body: data, headers: headers);
      // LoadingDialog.hide(context);
      print("response :: $response");
      if (response.statusCode == 200) {
        LoadingDialog.hide(context);

        var getData = json.encode(response.body);
        // var getData= jsonDecode(response.body);
        // print(" gdfikguawklkgfd ${response.body}");
        DialogUtils.showCustomDialog(context,
            title: "Success", description: "Your data saved successfully",onpositivePressed:(){
              Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  HomeScreen()), (Route<dynamic> route) => false);
            });

      }else if(response.statusCode == 401){
        var getData= jsonDecode(response.body);
        LoadingDialog.hide(context);
        DialogUtils.showCustomDialog(context,
            title: "Alert!!", description: getData['data'],onpositivePressed:(){
              Navigator.pop(context);
            });
      }

      else {
        LoadingDialog.hide(context);
        DialogUtils.showCustomDialog(context,
            title: "Error", description: "Bad request",onpositivePressed:(){
              Navigator.pop(context);
            });

      }

      }catch (e){
      print("e :: ${e}");
      LoadingDialog.hide(context);
      DialogUtils.showCustomDialog(context,
          title: "Alert!!", description: 'Something went wrong..Please try after sometime',onpositivePressed:(){
            Navigator.pop(context);
          });
      }

      // {vendorId: 0108009061, userid: 00002003, claimType: 1, patientName: 1, consulationNo: 4311, consulationDate: 22/2/2024, medicineSystem: 2, physicianName: test, illnessType: Chronical, amtClaimed: 546, remarks: trest,

  }

  Future ClaimDraftData(BuildContext context) async{
    SecureSharedPref preferences = await SecureSharedPref.getInstance();
    try {
      LoadingDialog.show(context);
      // SharedPreferences preferences  =await SharedPreferences.getInstance();
      String apiurl = "$kBaseUrl$kGetPrmsDraftDetails";
      String? token = (await preferences.getString('TOKEN',isEncrypted: true));
      String? empno = (await preferences.getString('EMP_NO'));
      Map<String, String>? _body;
      _body = {
        "userid":empno.toString(),

      };
      Map<String,String> header = {
        'Authorization': 'Bearer $token'
        // 'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IjIwMDMiLCJuYmYiOjE3MDc4ODY2NTMsImV4cCI6MTcwOTE4MjY1MywiaWF0IjoxNzA3ODg2NjUzfQ.-SFUkj8bX3KorUa8BKF0fpxj383dLlsZRPTrIzqTRjE'
      };


      http.Response response = await http.post(Uri.parse(apiurl),body: _body,headers: header,);
      print("response :: ${response.statusCode}");
      if (response.statusCode == 200) {
        LoadingDialog.hide(context);
        // var getData;
        // if(response.body.isNotEmpty) {
        //    getData= json.decode(response.body);
        // }

        var getData = response.body;
        // var getData= jsonDecode(response.body);

        return getData;

        // prefs.setString('Token', response.body[0]);


      }else {
        LoadingDialog.hide(context);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) =>
                LoginScreen()), (Route<dynamic> route) => false);
        // DialogUtils.showCustomDialog(context,
        //     title: "Alert!!",
        //     description: "You need to login again",
        //     onpositivePressed: () {
        //       Navigator.pop(context);
        //       Navigator.of(context).pushAndRemoveUntil(
        //           MaterialPageRoute(builder: (context) =>
        //               LoginScreen()), (Route<dynamic> route) => false);
        //     });
        return "";
      }
    } on TimeoutException catch (e) {
      LoadingDialog.hide(context);
    } on SocketException catch (e) {
      LoadingDialog.hide(context);
    }
    return "";
  }

  DeleteListData( BuildContext context, String claimID, String reqNo) async{
    SecureSharedPref preferences = await SecureSharedPref.getInstance();
    try {
      LoadingDialog.show(context);
      // SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = (await preferences.getString('TOKEN',isEncrypted: true));
      Map<String, String> header = {
        'Authorization': 'Bearer $token'//
      };
      String apiurl = "$kBaseUrl$kGetPRMSCLAIMDELETION";
      Map<String, String>? _body;
      _body = {
        "requestno":reqNo,
        "claimid":claimID
      };
      var response = await http.post(
          Uri.parse(apiurl), body: _body, headers: header);
      print("response :: ${response.body}");
      if (response.statusCode == 200) {
        var getData = response.body;
        LoadingDialog.hide(context);
        DialogUtils.showCustomDialog(context,
            title: "Success", description: "Your data has been delete successfully", onpositivePressed: () {
              Navigator.pop(context);
            });

        return getData;
      } else if(response.body.isNotEmpty){
        var getData = jsonDecode(response.body);
        LoadingDialog.hide(context);
        DialogUtils.showCustomDialog(context,
            title: "PRMS", description: getData['data'],onpositivePressed:(){
              Navigator.pop(context);

            });
        // return "";
      } else {
        LoadingDialog.hide(context);
        DialogUtils.showCustomDialog(context,
            title: "Error", description: "Bad request",onpositivePressed:(){
              Navigator.pop(context);
            });

      }
    }
   on TimeoutException catch (e) {

  } on SocketException catch (e) {

  }
  return "";
  }

  Future getUpdateData(BuildContext context, String claimtype, String patientname, String consulationNumber, String consultationDate, String systemofmedicine, String physicianName, String chronical, String amount, String remarks, String base64string, String billNo, String dischargedate, String admissiondate, String domiciliary, String critical, String illness, String claimtypeother, String treatment, String claimid, String filetype, String prescriptionDate,
      String billDate,String base64stringDoc,String filetypeDoc, String  approvalTaken, String block_year) async{
    SecureSharedPref preferences = await SecureSharedPref.getInstance();
    try {
      LoadingDialog.show(context);

      // SharedPreferences preferences  =await SharedPreferences.getInstance();
      String? token = (await preferences.getString('TOKEN',isEncrypted: true));
      String? vendorcode = (await preferences.getString('VENDOR_CODE',isEncrypted: true));
      String? empno = (await preferences.getString('EMP_NO'));
      Map<String,String> header = {
        'Authorization': 'Bearer $token'
      };

        var data = json.encode({
          "vendorId": vendorcode.toString(),
          "userid": empno.toString(),
          "claimid": claimid,
          "claimType": claimtype == "" ? "" : claimtype,
          "patientName": patientname == "" ? "" : patientname,
          "consulationNo": consulationNumber == "" ? "" : consulationNumber,
          "consulationDate": consultationDate == ""
              ? billDate
              : consultationDate,
          "medicineSystem": systemofmedicine == "" ? "" : systemofmedicine,
          "physicianName": physicianName == "" ? "" : physicianName,
          "illnessType": chronical == "" ? "" : chronical,
          "amtClaimed": amount == "" ? "" : amount,
          "remarks": remarks == "" ? "" : remarks,
          "dentalNormal": "",
          "claimOtherType": claimtypeother == "" ? "" : claimtypeother,
          "admDate": admissiondate == "" ? "" : admissiondate,
          "dischrgDate": dischargedate == "" ? "" : dischargedate,
          "treatmentType": treatment == "" ? "" : treatment,
          "saveCriticalIllness": critical == "" ? "" : critical,
          "illnessDetails": illness == "" ? "" : illness,
          "domicilaryTreatment": domiciliary == "" ? "" : domiciliary,
          "claimCheckprior": "",
          "prescriptionDate": prescriptionDate == "" ? "" : prescriptionDate,
          "majorclaim": "OPD",
          "filetype": filetype == "" ? "" : filetype,
          "filetypeDoc":filetypeDoc == "" ? "" : filetypeDoc,
          "approvalTaken":approvalTaken == "" ? "0" : approvalTaken,
          "block_year":block_year,
          "imgName": base64string == "" ? "" : base64string,
          "imgDocName":base64stringDoc == "" ? "" : base64stringDoc

        });

        print("base64stringDoc :: $base64stringDoc");
        print("base64string :: $base64string");
        print("kGetUpdateDraftData :: $data");
        // var dio = Dio();
        // var response = await dio.request(
        //   "$kBaseUrl$kGetUpdateDraftData",
        //   options: Options(
        //     method: 'POST',
        //     headers: header,
        //   ),
        //   data: data,
        // );

      // print("data :: $response");

      var response = await http.post(
          Uri.parse("$kBaseUrl$kGetUpdateDraftData"), body: data, headers: header);

        if (response.statusCode == 200) {
          LoadingDialog.hide(context);

          // print(" gdfikguawklkgfd ${response.body}");
          var getData = json.encode(response.body);
          // var getData= jsonDecode(response.body);
          // print(" gdfikguawklkgfd ${response.body}");
          DialogUtils.showCustomDialog(context,
              title: "Success",
              description: "Your data has been updated successfully",
              onpositivePressed: () {
                Navigator.pop(context);
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) =>
                        HomeScreen()), (Route<dynamic> route) => false);
              });
          return getData;
        } else if (response.statusCode == 401) {
          var getData = jsonDecode(response.body);
          LoadingDialog.hide(context);
          DialogUtils.showCustomDialog(context,
              title: "Alert!!",
              description: getData['data'],
              onpositivePressed: () {
                Navigator.pop(context);
              });
        }

        else {
          LoadingDialog.hide(context);
          DialogUtils.showCustomDialog(context,
              title: "Error",
              description: "Bad request",
              onpositivePressed: () {
                Navigator.pop(context);
              });
        }
      }catch(e){
        LoadingDialog.hide(context);
      }
  }

  Future getSubmitApi(BuildContext context,String cid) async{
    SecureSharedPref preferences = await SecureSharedPref.getInstance();
    LoadingDialog.show(context);
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String apiurl = "https://gailebank.gail.co.in/webservices/PRMS_MOB/api/PRMS/GetSystemMedicine";
      String apiurl = "$kBaseUrl$kGetsubmitData$cid";//$cid
      String? token = (await preferences.getString('TOKEN',isEncrypted: true));
      Map<String,String> header = {
        'Authorization': 'Bearer $token'//
      };
      http.Response response = await http.get(Uri.parse(apiurl),headers: header);
      print("response on submit :: ${response.statusCode}   ${response}");

      if (response.statusCode == 200) {
        LoadingDialog.hide(context);
        var getData = response.body;
        DialogUtils.showCustomDialog(context,
            title: "PRMS", description: "Your data Submitted successfully",onpositivePressed:(){
              Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  HomeScreen()), (Route<dynamic> route) => false);
            });
        return getData;
      }else {
        LoadingDialog.hide(context);
        var getData= response.body;
        if(getData.isNotEmpty){
          var d = jsonDecode(getData);
          if(d['data']==null){
            print("jgjgg  :: ${d['data']}");
            DialogUtils.showCustomDialog(context,
                title: "PRMS", description: 'An error has occurred.',onpositivePressed:(){
                  Navigator.pop(context);
                });//
          }else {
            print("jgjgg  :: ${d['data']}");
            DialogUtils.showCustomDialog(context,
                title: "PRMS", description: d['data'], onpositivePressed: () {
                  Navigator.pop(context);
                }); //
          }
        }else{
          DialogUtils.showCustomDialog(context,
              title: "PRMS", description: 'Something went wrong please try again...',onpositivePressed:(){
                Navigator.pop(context);
              });//
        }
      return null;
      }
    } on TimeoutException catch (e) {
      LoadingDialog.hide(context);
    } on SocketException catch (e) {
      LoadingDialog.hide(context);
    }
  }


  Future getOTPData(String mobile, BuildContext context) async{
    try {
      LoadingDialog.show(context);
      String apiurl = "$kBaseUrl$kIsSendOTPApi";
      Map<String, String>? _body;
      _body = {
        "userid":mobile,
      };
      // Map<String,String> header = {
      //   'Authorization': 'Bearer ${prefs.getString('Token')}'
      // };
      http.Response response  = await http.post(Uri.parse(apiurl),body: _body);
      if (response.statusCode == 200) {
        LoadingDialog.hide(context);
        var getData= jsonDecode(response.body);

        return getData;
      }else {
        LoadingDialog.hide(context);
        var getData= jsonDecode(response.body);
        // Navigator.pop(context);
        DialogUtils.showCustomDialog(context,
            title: "PRMS", description: getData['message'],onpositivePressed:(){
              Navigator.pop(context);
            });
        // return "";
      }
    } on TimeoutException catch (e) {
      LoadingDialog.hide(context);
    } on SocketException catch (e) {
      LoadingDialog.hide(context);

    }
    return "";
  }


  Future getVerifyData(String verificationCode, String? userID, BuildContext context) async{
    SecureSharedPref preferences = await SecureSharedPref.getInstance();
    try {
      LoadingDialog.show(context);
      // SharedPreferences preferences  =await SharedPreferences.getInstance();
      String apiurl = "$kBaseUrl$kIsVerifyOTPApi";
      Map<String, String>? _body;
      _body = {
        "userid":userID.toString(),
        "otp":verificationCode

      };
      // Map<String,String> header = {
      //   'Authorization': 'Bearer ${prefs.getString('Token')}'
      // };

      http.Response response = await http.post(Uri.parse(apiurl),body: _body);
      if (response.statusCode == 200) {
        LoadingDialog.hide(context);
        // var getData = response.body;
        var getData= jsonDecode(response.body);
        await preferences.putString('TOKEN', getData['TOKEN'],isEncrypted: true);
        await preferences.putString('EMP_NO', getData['EMP_CPF']);
        await preferences.putString('EMP_NAME', getData['EMP_NAME'],isEncrypted: true);
        await preferences.putString('GRADE', getData['GRADE']);
        await preferences.putString('LOCATION', getData['LOCATION'],isEncrypted: true);
        await preferences.putString('VENDOR_CODE', getData['VENDOR_CODE'],isEncrypted: true);
        return getData;
      }else {
        LoadingDialog.hide(context);
        var getData= jsonDecode(response.body);
        // Navigator.pop(context);

        DialogUtils.showCustomDialog(context,
            title: "PRMS", description: getData['message'],onpositivePressed:(){
              Navigator.pop(context);
            });
        // return "";
      }
    } on TimeoutException catch (e) {
      LoadingDialog.hide(context);

    } on SocketException catch (e) {
      LoadingDialog.hide(context);

    }
    return "";
  }


  Future claimReqDetailsData(BuildContext context,String reqNo) async{
    SecureSharedPref preferences = await SecureSharedPref.getInstance();
    try {
      LoadingDialog.show(context);
      // SharedPreferences preferences  =await SharedPreferences.getInstance();
      String apiurl = "$kBaseUrl$kGetReqDetails";
      String? token = (await preferences.getString('TOKEN',isEncrypted: true));
      String? emp = (await preferences.getString('EMP_NO'));
      Map<String, String>? _body;
      _body = {
        "userid":emp.toString(),
        "requestno":reqNo

      };
      Map<String,String> header = {
        'Authorization': 'Bearer $token'
        // 'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IjIwMDMiLCJuYmYiOjE3MDc4ODY2NTMsImV4cCI6MTcwOTE4MjY1MywiaWF0IjoxNzA3ODg2NjUzfQ.-SFUkj8bX3KorUa8BKF0fpxj383dLlsZRPTrIzqTRjE'
      };

      http.Response response = await http.post(Uri.parse(apiurl),body: _body,headers: header);
      if (response.statusCode == 200) {
        LoadingDialog.hide(context);
        var getData = response.body;
        return ClaimReqDetailsModelFromJson(getData);
      }else {
        LoadingDialog.hide(context);
        return "";
      }
    } on TimeoutException catch (e) {
      LoadingDialog.hide(context);
      return "";

    } on SocketException catch (e) {
      LoadingDialog.hide(context);
      return "";

    }
    return "";
  }

  Future<List<String>> getFinancialYearApi() async{
    SecureSharedPref preferences = await SecureSharedPref.getInstance();
    List<String> fY = [];
    try {
      String apiurl = "$kBaseUrl$kGetFinancialYear";
      String? token = (await preferences.getString('TOKEN',isEncrypted: true));
      Map<String,String> header = {
        'Authorization': 'Bearer $token'
      };
      http.Response response = await http.get(Uri.parse(apiurl),headers: header);
      if (response.statusCode == 200) {
        var getData = response.body;
        var g = jsonDecode(getData);
        List<dynamic> d = g['data'];
        for(int i = 0; i<d.length;i++){
          fY.add(d[i]["FIN_YEAR"]);
        }


        return fY;
      }else {
        // var getData= jsonDecode(response.body);
        // Navigator.pop(context);
        return [];
      }
    } on TimeoutException catch (e) {
    } on SocketException catch (e) {
    } throw Exception("");

  }

  Future<OPDDetailModel> getDataDetailOnDDApi(String year) async{
    SecureSharedPref preferences = await SecureSharedPref.getInstance();
    OPDDetailModel opdDetailModel;
    try {
      String? emp = (await preferences.getString('EMP_NO'));
      String? grade = (await preferences.getString('GRADE'));
      String apiurl = "$kBaseUrl$KGetdataDetailOnDD${'grade=$grade&cpfNo=$emp&fin_year=$year'}";
      String? token = (await preferences.getString('TOKEN',isEncrypted: true));
      Map<String,String> header = {
        'Authorization': 'Bearer $token'
      };

      http.Response response = await http.get(Uri.parse(apiurl),headers: header);
      print("response from details :: ${response.body}");
      print("response from details :: ${apiurl}");
      print("response from details :: ${response.statusCode}");

      if (response.statusCode == 200) {
        var getData = response.body;
        print("getDATA from details :: $getData");
        opdDetailModel = OPDDetailModelFromJson(getData);
        return opdDetailModel;
      }else {
        // var getData= jsonDecode(response.body);
        // Navigator.pop(context);

      }
    } on TimeoutException catch (e) {
    } on SocketException catch (e) {
    } throw Exception("null");

  }
}
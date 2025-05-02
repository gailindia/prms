import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
// import 'package:multiutillib/utils/utils.dart';
import '../Auth/login_screen.dart';
import '../Model/claim_draft_model.dart';
import '../Rest/api_services.dart';
 
import 'package:secure_shared_preferences/secure_shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sn_progress_dialog/progress_dialog.dart';

import '../Model/other_claim_model.dart';
import '../Widget/update_dialog.dart';

class HomeProvider extends ChangeNotifier{
  ApiService apiService = ApiService();
  ClaimDraftModel? claimDraftModel;
  List<ClaimDatum>? claimData;
  List<ClaimDataList>? claimDetailsList;
  OPDDetailModel? opdDetailModel;
  List<String>? claimDataType = [];
  List<Map<String,String>>? claimDate = [];
  bool isFinancialYear = false;
  String fin_year = '';
  String currentAppVersion = "";



  getCLaimData(BuildContext context) async{
    var s = await apiService.ClaimDraftData(context);
    print("ClaimDraftData ::$s");
    Map<String,dynamic> m = jsonDecode(s);
    if(m["data"]["ClaimData"]==null){
      // claimDraftModel = claimDraftModelFromJson(s);
      claimData = [];
      claimDataType = [];
      claimDate = [];
      isFinancialYear = false;
      fin_year = '';
    }else{
      claimDraftModel = claimDraftModelFromJson(s);
      claimData = claimDraftModel?.data.claimData!;

      for(int i=0; i<claimData!.length;i++){

        String claimType = claimData![i].claimType;
        claimDataType?.add(claimType.toUpperCase());
        claimDate?.add({'${claimType.toUpperCase()}':'${claimData![i].claimDataList[0].fin_year}'});
      }
    }
    notifyListeners();
  }

  getremovedata(BuildContext context, String claimID, String cid) async{
    print("${claimID} ${cid}");
    var response = await apiService.DeleteListData(context, claimID,cid);
    getCLaimData(context);
    notifyListeners();
  }

  //4510
  getDataSubmit(BuildContext context,String cid) async{
    // print("cid :: $cid");
    var response = await apiService.getSubmitApi(context,cid);
    notifyListeners();
  }

  void getLogout(BuildContext context) async{
    SecureSharedPref preferences = await SecureSharedPref.getInstance();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    preferences.clearAll();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        LoginScreen()), (Route<dynamic> route) => false);
    notifyListeners();
  }

  // onlyMessageProgress(context) async {
  //   ProgressDialog pd = ProgressDialog(context: context);
  //   pd.show(
  //     barrierDismissible: true,
  //     msg: "Please waiting...",
  //     hideValue: true,
  //   );
  //   /** You can update the message value after a certain action **/
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   pd.update(msg: "Almost done...");
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   pd.close();
  // }


  getDataDetailOnDD(String year) async{
    var response = await apiService.getDataDetailOnDDApi(year);

    opdDetailModel = response;

    notifyListeners();
  }

  getVersion(BuildContext context) async{
    await apiService.getVersion(context);
    _getAppVersion(context);
    notifyListeners();
  }

  _getAppVersion(BuildContext context) async {

    SecureSharedPref pref = await SecureSharedPref.getInstance();
    late String _storeLink, _serverAppVersion;


    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    // calling get app version method
    currentAppVersion =packageInfo.version;
    // update([kAppVersion]);

    if (Platform.isAndroid) {
      _storeLink = 'https://play.google.com/store/apps/details?id=com.gail.gailprms';
      _serverAppVersion = (await pref.getString("apkVersion"))??"";
    } else if (Platform.isIOS) {
      _storeLink = 'https://apps.apple.com/in/app/prms/id1574884477';
      _serverAppVersion = (await pref.getString("iosVersion"))??"";


    }

    // print("currentAppVersion :; $currentAppVersion");
    final int _serverAppVer = int.parse(_serverAppVersion.replaceAll('.', ''));
    final int _currentAppVer =
    int.parse(currentAppVersion!.replaceAll('.', ''));

    if (_serverAppVer > _currentAppVer) {

      // calling update app dialog method
      updateAppDialog(context: context, storeLink: _storeLink);
    }
  }

}
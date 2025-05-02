import 'dart:io';


import 'package:flutter/material.dart';
// import 'package:multiutillib/multiutillib_flutter.dart';
// import 'package:multiutillib/utils/utils.dart';
import 'package:prms/Screens/update_form_data.dart';

 
import 'package:provider/provider.dart';
import 'package:secure_shared_preferences/secure_shared_preferences.dart';

import '../Model/claim_draft_model.dart';
import '../Provider/homeprovider.dart';
import '../Widget/alert_dialog.dart';
import 'ClaimDetails/ClaimDetailsList.dart';
import 'ClaimForm/claim_from_screen.dart';
import 'ClaimStatus/claim_status_list.dart';
import 'my_profile.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // String currentAppVersion = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final homeprovider = Provider.of<HomeProvider>(context, listen: false);

    // claimTypeProvider.getClaimData();
    homeprovider.getCLaimData(context);
    homeprovider.getVersion(context);
    // homeprovider.onlyMessageProgress(context);
    // _getAppVersion(context);
  }

  @override
  void didChangeDependencies() {
    var homeprovider = Provider.of<HomeProvider>;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }


  // _getAppVersion(context) async {
  //
  //   SecureSharedPref pref = await SecureSharedPref.getInstance();
  //   late String _storeLink, _serverAppVersion;
  //
  //
  //
  //   // calling get app version method
  //   currentAppVersion = await getAppVersion();
  //   // update([kAppVersion]);
  //
  //   if (Platform.isAndroid) {
  //     _storeLink = 'https://play.google.com/store/apps/details?id=com.gail.gailprms';
  //     _serverAppVersion = (await pref.getString("apkVersion",isEncrypted: true))??"";
  //   } else if (Platform.isIOS) {
  //     _storeLink = 'https://apps.apple.com/in/app/prms/id1574884477';
  //     _serverAppVersion = (await pref.getString("iosVersion",isEncrypted: true))??"";
  //
  //
  //   }
  //
  //   print("currentAppVersion :; $currentAppVersion");
  //   final int _serverAppVer = int.parse(_serverAppVersion.replaceAll('.', ''));
  //   final int _currentAppVer =
  //   int.parse(currentAppVersion!.replaceAll('.', ''));
  //
  //   if (_serverAppVer > _currentAppVer) {
  //
  //     // calling update app dialog method
  //     updateAppDialog(context: context, storeLink: _storeLink);
  //   }
  // }


  bool issubmit= false;
  int? selectedOption;
  String? reqno;

  int valueradio= 0;


  @override
  Widget build(BuildContext context) {
    final postModel = Provider.of<HomeProvider>(context);

    // final claimTypeProvider = Provider.of<ClaimTypeProvider>(context);
    final mediaQueryData = MediaQuery.of(context);
    final scale = mediaQueryData.textScaleFactor;
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
        child: Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: const Text('PRMS',),
          flexibleSpace: Container(
            decoration:  const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[Colors.amber, Colors.amber])),
          )
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(
            248, 206, 206, 226), // Color.fromARGB(255, 181, 185, 147),
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              margin: const EdgeInsets.only(bottom: 2.0),
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 5.0),
              decoration: const BoxDecoration(
                color: Colors.amber,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,

                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Container(
                      width: 100.0,
                      height: 100.0,
                      child: Image.asset("assets/images/gaillogo.png")),
                  // Text(
                  //   "name".toString(),
                  //
                  // ),
                  // Text("userID".toString(),),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
              height: 0,
              // indent: 20,
              // endIndent: 20,
              color: Color.fromARGB(255, 164, 164, 164),
            ),
            Container(
              // color: Color.fromARGB(255, 155, 163, 88),
              // ignore: prefer_const_constructors
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(133, 153, 170, 185),
                    Color.fromARGB(227, 216, 212, 170),
                    Color.fromARGB(227, 216, 212, 170),
                    // Color.fromARGB(228, 211, 216, 170),
                  ],
                ),
              ),
              child: ListTile(
                // dense: true,
                // tileColor: kCGDDrawercolor,
                leading: const Icon(
                  Icons.supervised_user_circle,
                  color: Color.fromARGB(255, 85, 85, 85),
                ),
                title: const Text(
                  'My Profile',
                  // textScaleFactor: 1.2,
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                onTap: () {

                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  const MyProfile()));

                },
              ),
            ),
            const Divider(
              thickness: 1,
              height: 0,
              // indent: 20,
              // endIndent: 20,
              color: Color.fromARGB(255, 164, 164, 164),
            ),
            Container(
              // color: Color.fromARGB(255, 155, 163, 88),
              // ignore: prefer_const_constructors
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(133, 153, 170, 185),
                    Color.fromARGB(227, 216, 212, 170),
                    Color.fromARGB(227, 216, 212, 170),
                    // Color.fromARGB(228, 211, 216, 170),
                  ],
                ),
              ),
              child: ListTile(
                // dense: true,
                // tileColor: kCGDDrawercolor,
                leading: const Icon(
                  Icons.contact_mail_outlined,
                  color: Color.fromARGB(255, 85, 85, 85),
                ),
                title: const Text(
                  'Claim Status',
                  // textScaleFactor: 1.2,
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        // ignore: prefer_const_constructors
                          builder: (context) => ClaimStatusListScreen()));
                  // builder: (context) => DashboardScreen()));
                  // Navigator.pop(context);
                },
              ),
            ),
            const Divider(
              thickness: 1,
              height: 0,
              // indent: 20,
              // endIndent: 20,
              color: Color.fromARGB(255, 164, 164, 164),
            ),
            Container(
              // color: Color.fromARGB(255, 155, 163, 88),
              // ignore: prefer_const_constructors
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(133, 153, 170, 185),
                    Color.fromARGB(227, 216, 212, 170),
                    Color.fromARGB(227, 216, 212, 170),
                    // Color.fromARGB(228, 211, 216, 170),
                  ],
                ),
              ),
              child: ListTile(
                // dense: true,
                // tileColor: kCGDDrawercolor,
                leading: const Icon(
                  Icons.file_present,
                  color: Color.fromARGB(255, 85, 85, 85),
                ),
                title: const Text(
                  'Claim Details',
                  // textScaleFactor: 1.2,
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        // ignore: prefer_const_constructors
                          builder: (context) => ClaimDetailsListScreen()));
                  // builder: (context) => DashboardScreen()));
                  // Navigator.pop(context);
                },
              ),
            ),
            const Divider(
              thickness: 1,
              height: 0,
              // indent: 20,
              // endIndent: 20,
              color: Color.fromARGB(255, 164, 164, 164),
            ),
            Container(
              // color: Color.fromARGB(255, 155, 163, 88),
              // ignore: prefer_const_constructors
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(133, 153, 170, 185),
                    Color.fromARGB(227, 216, 212, 170),
                    Color.fromARGB(227, 216, 212, 170),
                    // Color.fromARGB(228, 211, 216, 170),
                  ],
                ),
              ),
              child: ListTile(
                // dense: true,
                // tileColor: kCGDDrawercolor,
                leading: const Icon(
                  Icons.login_rounded,
                  color: Color.fromARGB(255, 85, 85, 85),
                ),
                title: const Text(
                  'LogOut',
                  // textScaleFactor: 1.2,
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                onTap: () {
                  removeDataDialog("logout","",postModel,'Are you sure you want to logout?');
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       // ignore: prefer_const_constructors
                  //         builder: (context) => ArchieveListScreen()));
                  // builder: (context) => DashboardScreen()));
                  // Navigator.pop(context);
                },
              ),
            ),


            const Divider(
              thickness: 1,
              height: 0,
              // indent: 20,
              // endIndent: 20,
              color: Color.fromARGB(255, 164, 164, 164),
            ),
            Container(

              // decoration: BoxDecoration(
              //   gradient: const LinearGradient(
              //     begin: Alignment.topRight,
              //     end: Alignment.bottomLeft,
              //     colors: [
              //       Color.fromARGB(133, 153, 170, 185),
              //       Color.fromARGB(227, 216, 212, 170),
              //       Color.fromARGB(227, 216, 212, 170),
              //       // Color.fromARGB(228, 211, 216, 170),
              //     ],
              //   ),
              // ),
              child: ListTile(
                // dense: true,
                // tileColor: kCGDDrawercolor,

                title:  Text(
                  'App Version  : ${postModel.currentAppVersion!}',
                  // textScaleFactor: 1.2,
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),

              ),
            ),


            // ButtonBar(children: [
            //   ElevatedButton(
            //     child: const Text("Logout", textScaleFactor: 1.2),
            //     onPressed: () {
            //       // logout();
            //     },
            //   ),
            // ]),



          ],
        ),
      ),
      body:  RefreshIndicator(
        onRefresh: () async{
          await postModel.getCLaimData(context);
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: MediaQuery.of(context).size.width*1,
                  child: ElevatedButton(
                      onPressed: (){
                        // postModel.onlyMessageProgress(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ClaimFormScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                          textStyle: const TextStyle(
                            // fontSize: 30,
                              fontWeight: FontWeight.bold)),
                      child:  Row(
                        children: [
                          Spacer(),
                          Text("Create New Claim Request",
                            textScaleFactor: MediaQuery.of(context).textScaleFactor,
                            style: TextStyle(color: Colors.white),),
                          Spacer(),
                          Icon(Icons.add_circle_outline,color: Colors.white,)
                        ],
                      ))),
            ),
            postModel.claimData == null ? Container():
            Expanded(
              child: ListView.builder(
                itemCount: postModel.claimData!.length,
                itemBuilder: (context, i) {
                  return Container(
                    decoration: const BoxDecoration(
                      // color: Colors.grey
                    ),
                    child: ExpansionTile(
                      title: Row(
                        children: [
                          Radio(
                            value: i,
                            groupValue: selectedOption,
                            onChanged: (newval){
                              setState(() {
                                FocusScope.of(context).requestFocus(FocusNode());
                                selectedOption = newval;
                                reqno = postModel.claimData![i].cid.toString();
                                issubmit = true;
                              });
                            },
                          ),

                          Container(
                            height: 40,
                            width: 1,
                            decoration: const BoxDecoration(
                                color: Colors.grey
                            ),

                          ),
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                               Text('Claim\nID',
                                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                                textAlign: TextAlign.center, style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),),
                              Text(postModel.claimData![i].cid,
                                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                                style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic),),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            height: 40,
                            width: 1,
                            decoration: const BoxDecoration(
                                color: Colors.grey
                            ),

                          ),
                          const Spacer(),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                               Text('Claim\nType',
                                textScaleFactor:MediaQuery.of(context).textScaleFactor,
                                textAlign: TextAlign.center, style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),),
                              Text(postModel.claimData![i].claimType,
                                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                                style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            height: 40,
                            width: 1,
                            decoration: const BoxDecoration(
                                color: Colors.grey
                            ),

                          ),
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                               Text('Total\nAmount',
                                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                                textAlign: TextAlign.center, style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),),
                              Text(postModel.claimData![i].totalamount,
                                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                                style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic),),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            height: 40,
                            width: 1,
                            decoration: const BoxDecoration(
                                color: Colors.grey
                            ),

                          ),

                        ],
                      ),
                      children: <Widget>[
                        Column(
                          children: _buildExpandableContent(postModel.claimData![i].claimDataList,postModel,postModel.claimData![i].cid,postModel.claimData![i].claimType),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: issubmit,
              child:      Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20,top: 20,bottom: 20),
                child: Container(
                    width: MediaQuery.of(context).size.width*1,
                    child: ElevatedButton(
                        onPressed: () async {

                          await postModel.getDataDetailOnDD(postModel.claimData![0].claimDataList[0].fin_year );
                          var opdAmount = postModel.opdDetailModel!.opd;
                          postModel.claimData![selectedOption!].totalamount;
                          print("postModel.claimData![selectedOption!].totalamount :: ${postModel.claimData![selectedOption!].totalamount}");
                          int total = int.parse(postModel.claimData![selectedOption!].totalamount);
                          print(total);
                          if(opdAmount != null) {
                            if (opdAmount >= total) {
                              postModel.getDataSubmit(context,
                                  reqno.toString());
                            } else {
                              DialogUtils.showCustomDialog(context,
                                  title: "PRMS",
                                  description: "Your Amount Exceeded the remaining Amount",
                                  onpositivePressed: () {
                                    Navigator.pop(context);
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (context) =>
                                            HomeScreen()), (
                                        Route<dynamic> route) => false);
                                  });
                            }
                          }else{
                            DialogUtils.showCustomDialog(context,
                                title: "PRMS",
                                description: "Please try again later",
                                onpositivePressed: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) =>
                                          HomeScreen()), (
                                      Route<dynamic> route) => false);
                                });
                          }

                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                            textStyle: const TextStyle(
                              // fontSize: 30,
                                fontWeight: FontWeight.bold)),
                        child: const Text("Submit",style: TextStyle(color: Colors.white),))),
              ),


            )
          ],
        ),
      ),
    ));
  }

  _buildExpandableContent(List<ClaimDataList> claimDataList, HomeProvider postModel, String cid, String claimType) {
    List<Widget> columnContent = [];
    for(int i = 0; i< claimDataList.length; i++){
      columnContent.add(
        ListTile(
          title: Row(
            children: [

              Container(
                height: 40,
                width: 1,
                decoration: const BoxDecoration(
                    color: Colors.grey
                ),

              ),
              const Spacer(),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>   UpdateFormData(todo: claimDataList[i],claimType: claimType,)));
                },
                child: Container(
                  // color: Colors.amber,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       Text(claimDataList[i].claimType == "1"? 'Consultation No.': "Bill No.",
                         textScaleFactor: MediaQuery.of(context).textScaleFactor,
                         style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),),
                      Container(
                          width: 90,
                          child: Text(claimDataList[i].consulationNo,softWrap: true,
                            textScaleFactor: MediaQuery.of(context).textScaleFactor,
                            overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,maxLines: 1, style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic,color: Colors.blue),)),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Container(
                height: 40,
                width: 1,
                decoration: const BoxDecoration(
                    color: Colors.grey
                ),
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   Text('Amount',
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),),
                  Text(claimDataList[i].amtClaimed,
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic),),
                ],
              ),
              const Spacer(),
              Container(
                height: 40,
                width: 1,
                decoration: const BoxDecoration(
                    color: Colors.grey
                ),

              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Claim\nType',
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),),
                   textWidget(claimDataList[i].claimType),
                ],
              ),
            ],
          ),
          leading: GestureDetector(
              onTap: (){
                removeDataDialog(claimDataList[i].claimid.toString(),cid,postModel,'Are you sure to Delete this request?');
              },
              child: const Icon(Icons.delete_forever_outlined,color: Colors.red,)),
        ),
      );
    }

    return columnContent;
  }


  void removeDataDialog(String claimID, String reqNo, HomeProvider postModel, content) {
    showDialog<String>(
      context:  _scaffoldKey.currentContext!,
      builder: (BuildContext context) => AlertDialog(
        // ignore: prefer_const_constructors
        title: Text('Alert'),
        content:  Text(content.toString()),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Container(
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    width: 1, //                   <--- border width here
                  ),
                ),
                // height: 50,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: Text('NO')),
                )),
          ),
          // const Spacer(),
          TextButton(
            onPressed: () async {
              if(claimID == "logout"){
                postModel.getLogout(context);
                Navigator.pop(context, 'OK');

              }else{
                Navigator.pop(context, 'OK');

                postModel.getremovedata( _scaffoldKey.currentContext!,claimID.toString(),reqNo);
              }

            },
            child: Container(
              width: 60,
              decoration: BoxDecoration(
                // color: Colors.green,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  width: 1,
                  //                   <--- border width here
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                      'YES',
                      // style: textStyle12Bold,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textWidget(String claimType) {
    String claimTypeVal = '';
    if(claimType == "1"){
      claimTypeVal = "Consultation";
    }else if(claimType == "2"){
      claimTypeVal = "Medicine";

    }else if(claimType == "5"){
      claimTypeVal = "Others";
    }else if(claimType == "3"){
      claimTypeVal = "Test";
    } else if(claimType == "4"){
      claimTypeVal = "Hospitalisation";
    }
    else{
      claimTypeVal = claimType;
    }
    return Text(claimTypeVal, style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic),);
  }

}


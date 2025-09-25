
import 'package:flutter/material.dart';
import 'package:prms/Provider/medicalclaimstatusprovider.dart';
import 'package:prms/Screens/ClaimDetails/claimDetails_screen.dart';
import 'package:prms/Screens/ClaimDetails/dummyClaimDetailsList.dart';
import 'package:prms/Widget/customAppBar.dart';

import 'package:provider/provider.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';

class ClaimDetailsListScreen extends StatefulWidget {
  const ClaimDetailsListScreen({super.key});

  @override
  State<ClaimDetailsListScreen> createState() => _ClaimDetailsListScreenState();
}

class _ClaimDetailsListScreenState extends State<ClaimDetailsListScreen> {
  String? loggedInUser;

  @override
  void initState() {
    _init();
    super.initState();

  }
  checkUser() async
  {
    SecureSharedPref sharedPref = await SecureSharedPref.getInstance();
    var loggedInUsers = await sharedPref.getString("EMP_NO");
    setState(() {
      loggedInUser =  loggedInUsers;
    });

  }


  Future<void> _init() async {
    await checkUser();
    if(loggedInUser != "Test01"){
      final medicalclaimstatus = Provider.of<MedicalClaimStatusProvider>(context, listen: false);
      medicalclaimstatus.getmedicalClaimDetailsApi(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    final postModel = Provider.of<MedicalClaimStatusProvider>(context);
    return Scaffold(
        appBar: CustomAppBar(title: 'Claim Details',),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: (loggedInUser == "Test01")
              ? ListView.builder(
            itemCount: dummyClaimDetailsList.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final claim = dummyClaimDetailsList[index];
              return GestureDetector(
                onTap: () {
                  // In demo mode, just show dialog instead of navigating
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Demo Mode"),
                      content: Text(
                          "Viewing claim detail for ${claim.requestType} (${claim.requestDate})"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text("Request Date",
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 5,
                          child: Text(claim.requestDate,
                              style:
                              const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text("Request Type",
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        const Expanded(flex: 1, child: Text(":")),
                        Expanded(
                          flex: 5,
                          child: Text(claim.requestType,
                              style:
                              const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const Divider(),
                  ],
                ),
              );
            },
          )
              :
          postModel.isloading == true ?Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.3,
              // color: Color.fromARGB(0, 255, 193, 7),
              child: const Column(
                children: [
                  CircularProgressIndicator(
                    // alphaColor: Color.fromARGB(255, 11, 50, 124),
                    //         color: Color.fromARGB(210, 240, 163, 100),
                    backgroundColor: Color.fromARGB(255, 11, 50, 124),
                    color: Color.fromARGB(210, 240, 163, 100),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  //verticalSpace12,
                  Text(
                    "Loading",
                    style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          ) :

          ListView.builder(
              itemCount: postModel.claimdetailslist!.length,
              shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          // ignore: prefer_const_constructors
                            builder: (context) => ClaimDetailsScreen(reqNo: postModel.claimdetailslist![index].requestno.toString())));
                  },
                  child: Container(
                    // height: MediaQuery.of(context).size.height *
                    //     0.16,
                    // margin: const EdgeInsets.only(
                    //     left: 8.0, right: 8, top: 10),
                    // padding: const EdgeInsets.all(3.0),
                    /*  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color.fromARGB(118, 236, 233, 216),
                        Color.fromARGB(135, 245, 219, 203),
                      ],
                    ),
                    // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
                    boxShadow: [
                      // ignore: prefer_const_constructors
                      BoxShadow(
                        blurRadius: 2.0,
                        // ignore: prefer_const_constructors
                        color: Color.fromARGB(
                            255, 241, 240, 239),
                      )
                    ],
                    // border: Border.all(
                    //     color: const Color.fromARGB(
                    //         255, 221, 228, 239)),
                    // borderRadius: const BorderRadius.only(
                    //   bottomRight: Radius.circular(20),
                    // ),
                  ),*/
                    child:  Column(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Request Date",
                                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Text(":")
                            ),
                            Expanded(
                              flex: 5,
                              child: Text(
                                "${postModel.claimdetailslist![index].entryDate!}",textScaleFactor: MediaQuery.of(context).textScaleFactor,style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Request Type",textScaleFactor: MediaQuery.of(context).textScaleFactor,style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Text(":")
                            ),
                            Expanded(
                              flex: 5,
                              child:  Text(
                                "${postModel.claimdetailslist![index].htype}",textScaleFactor: MediaQuery.of(context).textScaleFactor,style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),

                          ],
                        ),
                        Divider(),
                        //Text("Requestor Name"),
                        //Text("Request Number"),
                      ],
                    ),
                  ),
                );

              }),
        )
    );
  }
}

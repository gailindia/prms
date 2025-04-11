import 'package:flutter/material.dart';
import 'package:prms/Provider/medicalclaimstatusprovider.dart';
import 'package:prms/Screens/ClaimStatus/claim_status_details.dart';
import 'package:prms/Widget/customAppBar.dart';
 
import 'package:provider/provider.dart';

class ClaimStatusListScreen extends StatefulWidget {
  const ClaimStatusListScreen({super.key});

  @override
  State<ClaimStatusListScreen> createState() => _ClaimStatusListScreenState();
}

class _ClaimStatusListScreenState extends State<ClaimStatusListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final medicalclaimstatus =
        Provider.of<MedicalClaimStatusProvider>(context, listen: false);
    medicalclaimstatus.getmedicalClaimStatusApi(context);
  }

  @override
  Widget build(BuildContext context) {
    final postModel = Provider.of<MedicalClaimStatusProvider>(context);
    final mediaQueryData = MediaQuery.of(context);
    final scale = mediaQueryData.textScaleFactor;

    return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: scale), child: Scaffold(
        appBar: CustomAppBar(
          title: 'Claim Status',
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: postModel.isloading == true
              ? Center(
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
                        color: Colors.amber, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
          )
              : ListView.builder(
              itemCount: postModel.claimstatusModelList!.length,
              shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ClaimStatusDetailsScreen(
                              todo: postModel
                                  .claimstatusModelList![index],
                            )));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: const Text(
                              "Claim Date",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ),
                          Expanded(child: Text(":")),
                          Expanded(
                            flex: 4,
                            child: Text(
                              postModel.claimstatusModelList![index]
                                  .REQ_CREATION_DATE
                                  .toString(),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Claim Amount",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ),
                          Expanded(flex: 1, child: Text(":")),
                          Expanded(
                            flex: 4,
                            child: Text(
                              postModel.claimstatusModelList![index]
                                  .REQ_AMOUNT_TOTAL
                                  .toString(),
                            ),
                          ),
                        ],
                      ),
                      postModel.claimstatusModelList![index].CLAIM_STATUS
                          .toString()
                          .toUpperCase() ==
                          "PROCESSING"
                          ? Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: const Text("Claim Status",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                          ),
                          Expanded(flex: 1, child: Text(":")),
                          Expanded(
                              flex: 4,
                              child: Text(
                                  postModel
                                      .claimstatusModelList![
                                  index]
                                      .CLAIM_STATUS
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(210, 240, 163, 100)))),
                        ],
                      )
                          : Container(),
                      postModel.claimstatusModelList![index].CLAIM_STATUS
                          .toString()
                          .toUpperCase() ==
                          "PAID"
                          ? Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: const Text("Claim Status",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                          ),
                          Expanded(flex: 1, child: Text(":")),
                          Expanded(
                            flex: 4,
                            child: Text(
                                postModel
                                    .claimstatusModelList![
                                index]
                                    .CLAIM_STATUS
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.green)),
                          )
                        ],
                      )
                          : Container(),
                      postModel.claimstatusModelList![index].CLAIM_STATUS
                          .toString()
                          .toUpperCase() ==
                          "REJECTED"
                          ? Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: const Text("Claim Status",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                          ),
                          Expanded(flex: 1, child: Text(":")),
                          Expanded(
                              flex: 4,
                              child: Text(
                                  postModel
                                      .claimstatusModelList![
                                  index]
                                      .CLAIM_STATUS
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.red)))

                        ],
                      )
                          : Container(),
                      const Divider(),
                      //Text("Requestor Name"),
                      //Text("Request Number"),
                    ],
                  ),
                );
              }),
        )));
  }
}

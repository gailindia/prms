import 'package:flutter/material.dart';
import 'package:prms/Provider/medicalclaimstatusprovider.dart';
import 'package:prms/Widget/customAppBar.dart';
import 'package:prms/styles/text_style.dart';
 
import 'package:provider/provider.dart';

import '../view_image.dart';

class ClaimDetailsScreen extends StatefulWidget {
  final String reqNo;
  const ClaimDetailsScreen({super.key, required this.reqNo});

  @override
  State<ClaimDetailsScreen> createState() => _ClaimDetailsScreenState();
}

class _ClaimDetailsScreenState extends State<ClaimDetailsScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final detailsreqmodel = Provider.of<MedicalClaimStatusProvider>(context, listen: false);
    detailsreqmodel.getClaimReqDetailsData(context,widget.reqNo);
  }

  @override
  Widget build(BuildContext context) {
    final postModel = Provider.of<MedicalClaimStatusProvider>(context);
    return Scaffold(
        appBar: CustomAppBar(title: 'Claim Details',),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: postModel.isloading == true ?Center(
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
            ) : ListView.builder(
                itemCount: postModel.claimreqDetailsList!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      //
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       // ignore: prefer_const_constructors
                      //         builder: (context) => ClaimDetailsScreen()));
                    },
                    child: Container(
                      // height: MediaQuery.of(context).size.height *
                      //     0.16,
                      decoration: const BoxDecoration(
                          // color: Colors.orange,
                          borderRadius: BorderRadius.all(
                              Radius.circular(10.0)), // Set rounded corner radius// Make rounded corner of border
                      ),

                      child:  Column(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Request No. ",textScaleFactor: MediaQuery.of(context).textScaleFactor,style: textStyle14Bold,
                              ),
                              Spacer(),
                              Container(
                                // width: 200,
                                child: Text(
                                  postModel.claimreqDetailsList![index].requestNo.toString(),
                                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  "Patient Name",textScaleFactor:MediaQuery.of(context).textScaleFactor,style: textStyle14Bold,
                                ),
                              ),
                              // Spacer(),
                              Expanded(
                                child: SizedBox(
                                width: 200,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    postModel.claimreqDetailsList![index].patientName.toString(),
                                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),)
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  "Claim Type",textScaleFactor: MediaQuery.of(context).textScaleFactor,style: textStyle14Bold,
                                ),
                              ),
                              // Spacer(),
                              Expanded(
                                child: Container(
                                  width: 200,
                                  child: Align(
                                    // alignment: Alignment.topRight,
                                    child: Text(
                                      postModel.claimreqDetailsList![index].claimType == null ? "":postModel.claimreqDetailsList![index].claimType.toString(),textAlign: TextAlign.right,textScaleFactor: MediaQuery.of(context).textScaleFactor ,overflow: TextOverflow.ellipsis,maxLines: 3,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Document Date",
                                textScaleFactor:MediaQuery.of(context).textScaleFactor,
                                style: textStyle14Bold,
                              ),
                              Spacer(),
                              Container(
                                // width: 200,
                                child: Text(
                                  postModel.claimreqDetailsList![index].documentDate.toString(),textScaleFactor: MediaQuery.of(context).textScaleFactor,overflow: TextOverflow.ellipsis,maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Prescription Date",
                                textScaleFactor: MediaQuery.of(context).textScaleFactor,style: textStyle14Bold,
                              ),
                              Spacer(),
                              Container(
                                // width: 200,
                                child: Text(
                                  postModel.claimreqDetailsList![index].prescriptionDate.toString() == "null" ? "-":postModel.claimreqDetailsList![index].prescriptionDate.toString(),
                                    textScaleFactor: MediaQuery.of(context).textScaleFactor,overflow: TextOverflow.ellipsis,maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Chronical/Normal",
                                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                                style: textStyle14Bold,
                              ),
                              Spacer(),
                              Container(
                                // width: 200,
                                child: Text(
                                  postModel.claimreqDetailsList![index].illnessType.toString() == "null"? "-":postModel.claimreqDetailsList![index].illnessType.toString(),
                                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                                    overflow: TextOverflow.ellipsis,maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Created Date",
                                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                                style: textStyle14Bold,
                              ),
                              Spacer(),
                              Container(
                                // width: 200,
                                child: Text(
                                  postModel.claimreqDetailsList![index].createdOn.toString(),textScaleFactor: MediaQuery.of(context).textScaleFactor,overflow: TextOverflow.ellipsis,maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Claimed Amount",textScaleFactor:MediaQuery.of(context).textScaleFactor,style: textStyle14Bold,
                              ),
                              Spacer(),
                              Container(
                                // width: 200,
                                child: Text(
                                  postModel.claimreqDetailsList![index].amountClaimed.toString() == "null"?"":postModel.claimreqDetailsList![index].amountClaimed.round().toString(),
                                  textScaleFactor: MediaQuery.of(context).textScaleFactor,overflow: TextOverflow.ellipsis,maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Remarks",textScaleFactor:MediaQuery.of(context).textScaleFactor,style: textStyle14Bold,
                              ),
                              Spacer(),
                              Container(
                                // width: 200,
                                child: Text(
                                  postModel.claimreqDetailsList![index].remarks == null ? "":postModel.claimreqDetailsList![index].remarks.toString(),textScaleFactor: MediaQuery.of(context).textScaleFactor,overflow: TextOverflow.ellipsis,maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "View Document",textScaleFactor: MediaQuery.of(context).textScaleFactor,style: textStyle14Bold,
                              ),
                              Spacer(),
                              Container(
                                // width: 200,
                                child: GestureDetector(
                                  onTap: ()async{
                                    // launch(postModel.claimreqDetailsList![index].uploadedDocument.toString());


                                    var newString = postModel.claimreqDetailsList![index].uploadedDocument.toString().substring(postModel.claimreqDetailsList![index].uploadedDocument.toString().length - 3);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>   ViewImage(imageUrl: postModel.claimreqDetailsList![index].uploadedDocument.toString(),type: newString,)));

                                  },
                                  child: postModel.claimreqDetailsList![index].uploadedDocument.toString()=='' ?  Container()  :Text(
                                    'View Doc',textScaleFactor: MediaQuery.of(context).textScaleFactor,style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Bill No",textScaleFactor: MediaQuery.of(context).textScaleFactor,style: textStyle14Bold,
                              ),
                              Spacer(),
                              Container(
                                // width: 200,
                                child: Text(
                                  postModel.claimreqDetailsList![index].documentNo.toString(),textScaleFactor: MediaQuery.of(context).textScaleFactor,overflow: TextOverflow.ellipsis,maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  );

                }),
          ),
        )
    );
  }
}

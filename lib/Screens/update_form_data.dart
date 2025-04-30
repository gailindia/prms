import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../Model/claim_draft_model.dart';
import '../Model/claim_type_model.dart';
import '../Provider/claimtypeProvider.dart';
import '../Provider/homeprovider.dart';
import '../Screens/view_image.dart';
import '../Widget/bottomsheetwidget.dart';
import '../Widget/claimtypebootomsheet.dart';
import '../Widget/customAppBar.dart';
import '../Widget/patientBottomSheet.dart';
import '../Widget/systemmedicinewidget.dart';
import '../styles/text_style.dart';
 
import 'package:provider/provider.dart';

import '../Model/claim_draft_model.dart';
import '../Widget/alert_dialog.dart';
import 'package:http/http.dart' as http;

class UpdateFormData extends StatefulWidget {
  final ClaimDataList? todo;
  final String? claimType;

  const UpdateFormData(
      {super.key, required this.todo, required this.claimType});

  @override
  State<UpdateFormData> createState() => _UpdateFormDataState();
}

class _UpdateFormDataState extends State<UpdateFormData> {
  bool opdvisibility = true;
  bool hospitalvisibility = false;
  bool consulationops = true,
      medicineopd = false,
      othersopd = false,
      testopd = false;
  DateTime selectedDate = DateTime.now();
  DateTime selectedDate1 = DateTime.now();
  DateTime selectedDate2 = DateTime.now();
  DateTime selectedDate3 = DateTime.now();
  String claim = "OPD CLAIM";
  String? fromDate, toDate;
  List<String> claimtype = ["OPD", "HOSPITALISATION"];
  String claimTypeValue = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final claimTypeProvider =
        Provider.of<ClaimTypeProvider>(context, listen: false);
    claimTypeProvider.getPatientNameData();
    claimTypeProvider.getSystemMedicineData();
    claimTypeProvider.getChronicalData();
    claimTypeProvider.getkGetOtherClaim();
    claimTypeProvider.getTreatmenttypeData();
    claimTypeProvider.getDomiciliaryData();
    claimTypeProvider.getCriticalIllnessData();
    claimTypeProvider.consultationNumberController.text =
        widget.todo!.consulationNo;
    claimTypeProvider.physicianController.text = widget.todo!.physicianName;
    claimTypeProvider.amountController.text = widget.todo!.amtClaimed;
    claimTypeProvider.remarksController.text = widget.todo!.remarks;
    claimTypeProvider.nameOflabController.text = widget.todo!.labName;
    claimTypeProvider.particularoftestController.text =
        widget.todo!.testParticulars;
    claimTypeProvider.illnesstController.text = widget.todo!.illnessDetails;
    claimTypeProvider.consultationDate = widget.todo!.consulationDate;
    claimTypeProvider.billNoController.text = widget.todo!.consulationNo;
    claimTypeProvider.admissiondate = widget.todo!.admDate;
    claimTypeProvider.dischargedate = widget.todo!.dischrgDate;
    claimTypeProvider.billDate = widget.todo!.consulationDate;
    claimTypeProvider.prescriptionDate = widget.todo!.prescriptionDate;
    claimTypeProvider.fin_year = widget.todo!.fin_year;

    claimTypeProvider.base64String = '';
    claimTypeProvider.capturedImage = null;

    claimTypeProvider.base64StringDoc = '';
    claimTypeProvider.capturedImageDoc = null;


    getCheckData();
  }

  Widget build(BuildContext context) {
    final postModel = Provider.of<ClaimTypeProvider>(context);
    // if(widget.todo!.img.isNotEmpty){
    //   print("widget.todo!.img :: ${widget.todo!.img}");
    //   var s = widget.todo!.img.substring(widget.todo!.img.length-3);
    //   if(s == 'pdf' || s=="PDF") {
    //     postModel.filetype = 'pdf';
    //   }else{
    //     postModel.filetype = 'image';
    //   }
    // }
    final mediaQueryData = MediaQuery.of(context);
    final scale = mediaQueryData.textScaleFactor.clamp(1.0, 1.2);

    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
        child: Scaffold(
      appBar: CustomAppBar(
        title: 'Edit PRMS Claim',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                        'Select Your Claim Type',
                        style: textStyle14Bold,
                      )),
                  Expanded(
                    child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.black,
                            ),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(widget.claimType.toString()),
                        )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                        'Claim Type',
                        style: textStyle14Bold,
                      )),
                  Expanded(
                    child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.black,
                            ),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(claimTypeValue),
                        )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                        'Financial Year',
                        style: textStyle14Bold,
                      )),
                  Expanded(
                    child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.black,
                            ),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(postModel.fin_year),
                        )),
                  ),
                ],
              ),
            ),
            const Divider(),
            Visibility(
                visible: opdvisibility,
                child: opdWidget(postModel.claimtypemodel, postModel)),
            Visibility(
                visible: hospitalvisibility, child: hospitalWidget(postModel)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  child: ElevatedButton(
                      onPressed: () {
                        print("postModel.claimtype ${postModel.claimtype}  ${widget.todo!.claimType}");
                        if(widget.todo!.claimType == '2'){
                          if (validationMedicine(postModel)) {
                            postModel.getDataUpdate(
                                context,
                                widget.todo!.claimid,
                                widget.todo!.claimType,
                                widget.todo!.patientName,
                                postModel.treatment);
                          }
                        }else {
                          postModel.getDataUpdate(
                              context,
                              widget.todo!.claimid,
                              widget.todo!.claimType,
                              widget.todo!.patientName,
                              postModel.treatment);
                        }

                        // postModel.getDataToList(postModel.claimtype,postModel.patientname,postModel.consultationNumberController.text,postModel.consultationDate,postModel.systemofmedicine,postModel.physicianController.text,postModel.chronical,postModel.amountController.text,postModel.remarksController.text,postModel.);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                          textStyle: const TextStyle(
                            // fontSize: 30,
                              fontWeight: FontWeight.bold)),
                      child: const Text("UPDATE",
                          style: TextStyle(color: Colors.white)))),
            )
          ],
        ),
      ),
    ));
  }

  Widget opdWidget(
      List<ClaimTypeModel>? claimtypemodel, ClaimTypeProvider postModel) {
    return Column(
      children: [
        Visibility(
            visible: consulationops,
            child: consulatationWidget(claimtypemodel, postModel)),
        Visibility(visible: medicineopd, child: MedicineWidget(postModel)),
        Visibility(visible: othersopd, child: OthersSpecWidget(postModel)),
        Visibility(visible: testopd, child: TestopdWidget(postModel)),
      ],
    );
  }

  Widget hospitalWidget(ClaimTypeProvider postModel) {
    return Column(
      children: [
        /*  Padding(
         padding: const EdgeInsets.all(8.0),
         child: BottomSheetWidget(content:widget.todo!.claimType,heading:"Claim Type",claimtype:postModel.claimtypemodel!,onpressed: (val){
           if(val == "-1"){
             consulationops = true;
             medicineopd = false;
             othersopd = false;
             testopd= false;
             setState(() {
             });
           }else if(val == "1"){
             consulationops = true;
             medicineopd = false;
             othersopd = false;
             testopd= false;
             setState(() {
             });
           }else if(val == "2"){
             consulationops = false;
             medicineopd = true;
             othersopd = false;
             testopd= false;
             setState(() {
             });
           }else if(val == "5"){
             consulationops = false;
             medicineopd = false;
             othersopd = true;
             testopd= false;
             setState(() {
             });
           }else if(val == "3"){
             consulationops = false;
             medicineopd = false;
             othersopd = false;
             testopd= true;
             setState(() {
             });
           }

         },),
       ),*/
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PatientBottomSheetWidget(
            content: widget.todo!.patientName,
            heading: "Patient Name",
            claimtype: postModel.patientList,
            onpressed: (val) {
              postModel.patientname = val;
              setState(() {});
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Bill No.',
                style: textStyle14Bold,
              )),
              Expanded(
                child: Container(
                  height: 45,
                  child: TextField(
                    readOnly: true,
                    controller: postModel.billNoController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Bill No.',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Bill Date',
                style: textStyle14Bold,
              )),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: GestureDetector(
                      onTap: () async {
                        var parts = postModel.fin_year.split('-');
                        var prefix = parts[0].trim();

                        String fromApril = "01/04/${prefix}";
                        String toSeptember = "30/09/${prefix}";
                        String toDecemberM = "31/12/${prefix}";
                        var suffix = parts[1].trim();
                        String fromOct = "01/10/${prefix}";
                        String fromMarch = "31/03/${suffix}";
                        String toJune = "30/06/$suffix";

                        postModel.consultationDate =
                            await admissionDate(context);

                        DateTime fromA =
                            DateFormat("dd/MM/yyyy").parse(fromApril);
                        DateTime fromS =
                            DateFormat("dd/MM/yyyy").parse(toSeptember);
                        DateTime fromO =
                            DateFormat("dd/MM/yyyy").parse(fromOct);
                        DateTime fromM =
                            DateFormat("dd/MM/yyyy").parse(fromMarch);
                        DateTime toDecember =
                            DateFormat("dd/MM/yyyy").parse(toDecemberM);
                        DateTime toJuneM =
                            DateFormat("dd/MM/yyyy").parse(toJune);

                        ///Financial year check
                        if (postModel.consultationDate != '--Select Date--') {
                          DateTime d = DateFormat("dd/MM/yyyy")
                              .parse(postModel.consultationDate);
                          DateTime fromFinancialYear =
                              DateFormat("dd/MM/yyyy").parse(fromApril);
                          DateTime toFinancialYear =
                              DateFormat("dd/MM/yyyy").parse(fromMarch);
                          //&& d.isAfter(fromO) && d.isBefore(fromM)
                          if ((d.isAfter(fromFinancialYear) ||
                                  d.isAtSameMomentAs(fromFinancialYear)) &&
                              (d.isBefore(toFinancialYear) ||
                                  d.isBefore(toFinancialYear))) {
                            if ((d.isBefore(fromS) ||
                                d.isAtSameMomentAs(fromS))) {
                              if ((d.isAfter(fromA) ||
                                      d.isAtSameMomentAs(fromA)) &&
                                  (d.isBefore(fromS) ||
                                      d.isAtSameMomentAs(fromS)) &&
                                  (DateTime.now().isBefore(toDecember) ||
                                      DateTime.now()
                                          .isAtSameMomentAs(toDecember))) {
                                //  postModel.attachFile = false;
                              } else {
                                //   postModel.attachFile = true;
                              }
                            } else {
                              if ((d.isAfter(fromO) ||
                                      d.isAtSameMomentAs(fromO)) &&
                                  (d.isBefore(fromM) ||
                                      d.isAtSameMomentAs(fromM)) &&
                                  (DateTime.now().isBefore(toJuneM) ||
                                      DateTime.now()
                                          .isAtSameMomentAs(toJuneM))) {
                                //   postModel.attachFile = false;
                              } else {
                                //   postModel.attachFile = true;
                              }
                            }
                            postModel.notifyListeners();

                            // if (d.isAfter(fromO) &&
                            //     d.isBefore(fromM) &&
                            //     DateTime.now().isBefore(toJuneM)) {
                            //   postModel.attachFile = false;
                            // } else {
                            //   postModel.attachFile = true;
                            //   print("Alert time is exceed");
                            // }
                            // if (d.isAfter(fromA) &&
                            //     d.isBefore(fromS) &&
                            //     DateTime.now().isBefore(toDecember)) {
                            //   postModel.attachFile = false;
                            // } else {
                            //   postModel.attachFile = true;
                            // }
                          } else {
                            DialogUtils.showCustomDialog(context,
                                title: "PRMS",
                                description:
                                    'Bill Date does not lie within the financial year',
                                onpositivePressed: () {
                              Navigator.pop(context);
                              postModel.consultationDate = "--Select Date--";
                              //   postModel.attachFile = false;
                              postModel.notifyListeners();
                            });
                          }
                        }
                        setState(() {});
                      },
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("${postModel.consultationDate}"),
                          ))),
                  // TextField(
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(),
                  //     hintText: 'Select Consultation Date',
                  //   ),
                  // ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Widgetforsystemmedicine(
            content: widget.todo!.treatmentType,
            heading: "Treatment Type",
            systemMedicine: postModel.traetmenttypeList,
            onpressed: (val) {
              postModel.treatment = val;
              if (val.contains('Domiciliary Treatment')) {
                postModel.domiciliaryvisibility = true;
              } else {
                postModel.domiciliaryvisibility = false;
              }
              setState(() {});
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Admission Date',
                style: textStyle14Bold,
              )),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: GestureDetector(
                      onTap: () async {
                        var parts = postModel.fin_year.split('-');
                        var prefix = parts[0].trim();

                        String fromApril = "01/04/${prefix}";
                        String toSeptember = "30/09/${prefix}";
                        String toDecemberM = "31/12/${prefix}";
                        var suffix = parts[1].trim();
                        String fromOct = "01/10/${prefix}";
                        String fromMarch = "31/03/${suffix}";
                        String toJune = "30/06/$suffix";

                        postModel.admissiondate = await admissionDate(context);

                        DateTime fromA =
                            DateFormat("dd/MM/yyyy").parse(fromApril);
                        DateTime fromS =
                            DateFormat("dd/MM/yyyy").parse(toSeptember);
                        DateTime fromO =
                            DateFormat("dd/MM/yyyy").parse(fromOct);
                        DateTime fromM =
                            DateFormat("dd/MM/yyyy").parse(fromMarch);
                        DateTime toDecember =
                            DateFormat("dd/MM/yyyy").parse(toDecemberM);
                        DateTime toJuneM =
                            DateFormat("dd/MM/yyyy").parse(toJune);

                        ///Financial year check
                        if (postModel.admissiondate != '--Select Date--' &&
                            postModel.consultationDate != '--Select Date--') {
                          DateTime d = DateFormat("dd/MM/yyyy")
                              .parse(postModel.admissiondate);
                          DateTime billD = DateFormat("dd/MM/yyyy")
                              .parse(postModel.consultationDate);
                          DateTime fromFinancialYear =
                              DateFormat("dd/MM/yyyy").parse(fromApril);
                          DateTime toFinancialYear =
                              DateFormat("dd/MM/yyyy").parse(fromMarch);
                          //&& d.isAfter(fromO) && d.isBefore(fromM)
                          if ((d.isAfter(fromFinancialYear) ||
                                  d.isAtSameMomentAs(fromFinancialYear)) &&
                              (d.isBefore(toFinancialYear) ||
                                  d.isAtSameMomentAs(toFinancialYear))) {
                            var billdate =
                                DateFormat('d/M/y').parse(postModel.billDate);
                            var admsndate = DateFormat('d/M/y')
                                .parse(postModel.admissiondate);
                            // var dschrgedate = DateFormat('d/M/y').parse(postModel.dischargedate);
                            if (billdate.isBefore(admsndate)) {
                              DialogUtils.showCustomDialog(context,
                                  title: "PRMS",
                                  description:
                                      'Admission date either should be equal or smaller than bill date',
                                  onpositivePressed: () {
                                postModel.admissiondate = "--Select Date--";
                                postModel.notifyListeners();
                                Navigator.pop(context);
                              });
                            }
                          } else {
                            DialogUtils.showCustomDialog(context,
                                title: "PRMS",
                                description:
                                    'Admission Date does not lie within the financial year',
                                onpositivePressed: () {
                              Navigator.pop(context);
                              postModel.admissiondate = "--Select Date--";
                              //   postModel.attachFile = false;
                              postModel.notifyListeners();
                            });
                          }
                        }
                        setState(() {});
                      },
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("${postModel.admissiondate}"),
                          ))),
                  // TextField(
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(),
                  //     hintText: 'Select Consultation Date',
                  //   ),
                  // ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Discharge Date',
                style: textStyle14Bold,
              )),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: GestureDetector(
                      onTap: () async {
                        var parts = postModel.fin_year.split('-');
                        var prefix = parts[0].trim();

                        String fromApril = "01/04/${prefix}";
                        String toSeptember = "30/09/${prefix}";
                        String toDecemberM = "31/12/${prefix}";
                        var suffix = parts[1].trim();
                        String fromOct = "01/10/${prefix}";
                        String fromMarch = "31/03/${suffix}";
                        String toJune = "30/06/$suffix";

                        postModel.dischargedate = await admissionDate(context);

                        DateTime fromA =
                            DateFormat("dd/MM/yyyy").parse(fromApril);
                        DateTime fromS =
                            DateFormat("dd/MM/yyyy").parse(toSeptember);
                        DateTime fromO =
                            DateFormat("dd/MM/yyyy").parse(fromOct);
                        DateTime fromM =
                            DateFormat("dd/MM/yyyy").parse(fromMarch);
                        DateTime toDecember =
                            DateFormat("dd/MM/yyyy").parse(toDecemberM);
                        DateTime toJuneM =
                            DateFormat("dd/MM/yyyy").parse(toJune);

                        ///Financial year check
                        if (postModel.dischargedate != '--Select Date--' &&
                            postModel.admissiondate != '--Select Date--') {
                          DateTime d = DateFormat("dd/MM/yyyy")
                              .parse(postModel.dischargedate);
                          DateTime fromFinancialYear =
                              DateFormat("dd/MM/yyyy").parse(fromApril);
                          DateTime toFinancialYear =
                              DateFormat("dd/MM/yyyy").parse(fromMarch);
                          //&& d.isAfter(fromO) && d.isBefore(fromM)
                          if ((d.isAfter(fromFinancialYear) ||
                                  d.isAtSameMomentAs(fromFinancialYear)) &&
                              (d.isBefore(toFinancialYear) ||
                                  d.isAtSameMomentAs(toFinancialYear))) {
                            var billdate = DateFormat('d/M/y')
                                .parse(postModel.consultationDate);
                            var admsndate = DateFormat('d/M/y')
                                .parse(postModel.admissiondate);
                            var dschrgedate = DateFormat('d/M/y')
                                .parse(postModel.dischargedate);
                            if (dschrgedate.isBefore(admsndate)) {
                              DialogUtils.showCustomDialog(context,
                                  title: "PRMS",
                                  description:
                                      'Discharge date should be equal or greater than Admission date',
                                  onpositivePressed: () {
                                postModel.dischargedate = "--Select Date--";
                                Navigator.pop(context);
                                postModel.notifyListeners();
                              });
                            }
                            if (dschrgedate.isAfter(billdate)) {
                              DialogUtils.showCustomDialog(context,
                                  title: "PRMS",
                                  description:
                                      'Discharge date should be equal or greater than Bill date',
                                  onpositivePressed: () {
                                postModel.dischargedate = "--Select Date--";
                                Navigator.pop(context);
                                postModel.notifyListeners();
                              });
                            }
                          } else {
                            DialogUtils.showCustomDialog(context,
                                title: "PRMS",
                                description:
                                    'Discharge Date does not lie within the financial year',
                                onpositivePressed: () {
                              Navigator.pop(context);
                              postModel.dischargedate = "--Select Date--";
                              //   postModel.attachFile = false;
                              postModel.notifyListeners();
                            });
                          }
                        }
                      },
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("${postModel.dischargedate}"),
                          ))),
                  // TextField(
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(),
                  //     hintText: 'Select Consultation Date',
                  //   ),
                  // ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: postModel.domiciliaryvisibility,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Widgetforsystemmedicine(
              content: widget.todo!.domicilaryTreatment,
              heading:
                  "Domiciliary treatment as hospitalisation(if selected above)",
              systemMedicine: postModel.domiciliaryDataList,
              onpressed: (val) {
                postModel.domiciliary = val;
                setState(() {});
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Widgetforsystemmedicine(
            content: widget.todo!.saveCriticalIllness,
            heading: "Critical Illness",
            systemMedicine: postModel.criticalIllnessDataList,
            onpressed: (val) {
              postModel.critical = val;
              setState(() {});
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Illness Detail',
                        style: textStyle14Bold,
                      ))),
              Expanded(
                child: Container(
                  height: 45,
                  child: TextField(
                    controller: postModel.illnesstController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Illness Detail',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Amount Claimed',
                        style: textStyle14Bold,
                      ))),
              Expanded(
                child: Container(
                  height: 45,
                  child: TextField(
                    controller: postModel.amountController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Claimed Amount',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Remarks',
                        style: textStyle14Bold,
                      ))),
              Expanded(
                child: Container(
                  height: 45,
                  child: TextField(
                    controller: postModel.remarksController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Remarks',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: widget.todo!.imgDoc.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  'View Approval File',
                  style: textStyle14Bold,
                )),
                Expanded(
                  child: Container(
                    height: 45,
                    child: GestureDetector(
                        onTap: () async {
                          var s = widget.todo!.imgDoc.split(".");
                          //launch("https://gailebank.gail.co.in//GRMED/UploadedDocs/${widget.todo!.imgDoc}");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewImage(
                                        imageUrl:
                                            "https://gailebank.gail.co.in//GRMED/UploadedDocs/${widget.todo!.imgDoc}",
                                        type: s[1],
                                      )));
                        },
                        child: Text(
                          'view',
                          style: TextStyle(color: Colors.blue),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: widget.todo!.imgDoc.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  'Approval File',
                  style: textStyle14Bold,
                )),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      postModel.existingImageDoc = widget.todo!.imgDoc;
                      postModel.notifyListeners();
                      showDialogBoxDoc(postModel, context);
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: const BoxDecoration(
                        color: Colors.amber,

                        borderRadius: BorderRadius.all(Radius.circular(
                            10.0)), // Set rounded corner radius// Make rounded corner of border
                      ),
                      child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Choose File",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        postModel.capturedImageDoc == null
            ? Container()
            : Container(
                child: postModel.filebool == false
                    ? Image.file(
                        postModel.capturedImageDoc!,
                        width: MediaQuery.of(context).size.width * .8,
                      )
                    : Column(
                        children: [
                          Text(
                            postModel.updatedAttachedAppDoc,
                            style: textStyle14Bold,
                          ),
                          const Icon(Icons.file_copy),
                        ],
                      ),
              ),
        Visibility(
          visible: widget.todo!.img.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  'View Attached File',
                  style: textStyle14Bold,
                )),
                Expanded(
                  child: Container(
                    height: 45,
                    child: GestureDetector(
                        onTap: () {
                          var s = widget.todo!.img.split(".");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewImage(
                                        imageUrl:
                                            "https://gailebank.gail.co.in//GRMED/UploadedDocs/${widget.todo!.img}",
                                        type: s[1],
                                      )));
                          //  launch("https://gailebank.gail.co.in//GRMED/UploadedDocs/${widget.todo!.img}");
                        },
                        child: Text(
                          'view',
                          style: TextStyle(color: Colors.blue),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Attachment File',
                style: textStyle14Bold,
              )),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    postModel.existingImage = widget.todo!.img;
                    postModel.notifyListeners();
                    showDialogBox(postModel, context);
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: const BoxDecoration(
                      color: Colors.amber,

                      borderRadius: BorderRadius.all(Radius.circular(
                          10.0)), // Set rounded corner radius// Make rounded corner of border
                    ),
                    child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Choose File",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
        postModel.capturedImage == null
            ? Container()
            : Container(
                child: postModel.filebool == false
                    ? Image.file(
                        postModel.capturedImage!,
                        width: MediaQuery.of(context).size.width * .8,
                      )
                    : Column(
                        children: [
                          Text(
                            postModel.updatedAttachedDoc,
                            style: textStyle14Bold,
                          ),
                          const Icon(Icons.file_copy),
                        ],
                      ),
              )
      ],
    );
  }

  Widget consulatationWidget(
      List<ClaimTypeModel>? claimtypemodel, ClaimTypeProvider postModel) {
    var homeProvider = Provider.of<HomeProvider>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PatientBottomSheetWidget(
            content: widget.todo!.patientName,
            heading: "Patient Name",
            claimtype: postModel.patientList!,
            onpressed: (val) {
              postModel.patientname = val;
              setState(() {});
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Consultation No.',
                style: textStyle14Bold,
              )),
              Expanded(
                child: Container(
                  height: 45,
                  child: TextField(
                    controller: postModel.consultationNumberController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Consulatation no',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Consultation Date',
                style: textStyle14Bold,
              )),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: GestureDetector(
                      onTap: () async {
                        // if (postModel.fin_year == '') {
                        //   postModel.fin_year = homeProvider.fin_year;
                        // }
                        var parts = postModel.fin_year.split('-');
                        var prefix = parts[0].trim();

                        String fromApril = "01/04/${prefix}";
                        String toSeptember = "30/09/${prefix}";
                        String toDecemberM = "31/12/${prefix}";
                        var suffix = parts[1].trim();
                        String fromOct = "01/10/${prefix}";
                        String fromMarch = "31/03/${suffix}";
                        String toJune = "30/06/$suffix";

                        postModel.consultationDate =
                            await _selectConsultationDate(context);

                        DateTime fromA =
                            DateFormat("dd/MM/yyyy").parse(fromApril);
                        DateTime fromS =
                            DateFormat("dd/MM/yyyy").parse(toSeptember);
                        DateTime fromO =
                            DateFormat("dd/MM/yyyy").parse(fromOct);
                        DateTime fromM =
                            DateFormat("dd/MM/yyyy").parse(fromMarch);
                        DateTime toDecember =
                            DateFormat("dd/MM/yyyy").parse(toDecemberM);
                        DateTime toJuneM =
                            DateFormat("dd/MM/yyyy").parse(toJune);

                        ///Financial year check
                        if (postModel.consultationDate != '--Select Date--') {
                          DateTime d = DateFormat("dd/MM/yyyy")
                              .parse(postModel.consultationDate);
                          DateTime fromFinancialYear =
                              DateFormat("dd/MM/yyyy").parse(fromApril);
                          DateTime toFinancialYear =
                              DateFormat("dd/MM/yyyy").parse(fromMarch);
                          //&& d.isAfter(fromO) && d.isBefore(fromM)
                          if ((d.isAfter(fromFinancialYear) ||
                                  d.isAtSameMomentAs(fromFinancialYear)) &&
                              (d.isBefore(toFinancialYear) ||
                                  d.isAtSameMomentAs(toFinancialYear))) {
                            if ((d.isBefore(fromS) ||
                                d.isAtSameMomentAs(fromS))) {
                              if ((d.isAfter(fromA) ||
                                      d.isAtSameMomentAs(fromA)) &&
                                  (d.isBefore(fromS) ||
                                      d.isAtSameMomentAs(fromS)) &&
                                  (DateTime.now().isBefore(toDecember) ||
                                      DateTime.now()
                                          .isAtSameMomentAs(toDecember))) {
                                //    postModel.attachFile = false;
                              } else {
                                //    postModel.attachFile = true;
                              }
                            } else {
                              if ((d.isAfter(fromO) ||
                                      d.isAtSameMomentAs(fromO)) &&
                                  (d.isBefore(fromM) ||
                                      d.isAtSameMomentAs(fromM)) &&
                                  (DateTime.now().isBefore(toJuneM) ||
                                      DateTime.now()
                                          .isAtSameMomentAs(toJuneM))) {
                                //   postModel.attachFile = false;
                              } else {
                                //   postModel.attachFile = true;
                              }
                            }
                            postModel.notifyListeners();
                          } else {
                            DialogUtils.showCustomDialog(context,
                                title: "PRMS",
                                description:
                                    'Consultation Date does not lie within the financial year',
                                onpositivePressed: () {
                              Navigator.pop(context);
                              postModel.consultationDate = "--Select Date--";
                              //     postModel.attachFile = false;
                              postModel.notifyListeners();
                            });
                          }
                        }

                        setState(() {});
                      },
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("${postModel.consultationDate}"),
                          ))),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Widgetforsystemmedicine(
            content: widget.todo!.medicineSystem,
            heading: "System of Medicine",
            systemMedicine: postModel.systemofmedicineList,
            onpressed: (val) {
              postModel.systemofmedicine = val;
              postModel.notifyListeners();
              setState(() {});
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Name of Physician',
                style: textStyle14Bold,
              )),
              Expanded(
                child: Container(
                  height: 45,
                  child: TextField(
                    controller: postModel.physicianController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Physician Name',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: BottomSheetWidget(
            content: widget.todo!.illnessType,
            heading: "Chronical/Normal",
            claimtype: postModel.chronicaldata!,
            onpressed: (val) {
              postModel.chronical = val;
              postModel.notifyListeners();
              setState(() {});
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Amount Claimed',
                style: textStyle14Bold,
              )),
              Expanded(
                child: Container(
                  height: 45,
                  child: TextField(
                    controller: postModel.amountController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Claimed Amount',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Remarks',
                style: textStyle14Bold,
              )),
              Expanded(
                child: Container(
                  height: 45,
                  child: TextField(
                    controller: postModel.remarksController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Remarks',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: widget.todo!.imgDoc.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  'View Approval File',
                  style: textStyle14Bold,
                )),
                Expanded(
                  child: Container(
                    height: 45,
                    child: GestureDetector(
                        onTap: () async {
                          var s = widget.todo!.imgDoc.split(".");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewImage(
                                        imageUrl:
                                            "https://gailebank.gail.co.in//GRMED/UploadedDocs/${widget.todo!.imgDoc}",
                                        type: s[1],
                                      )));
                        },
                        child: Text(
                          'view',
                          style: TextStyle(color: Colors.blue),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: widget.todo!.imgDoc.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  'Approval File',
                  style: textStyle14Bold,
                )),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      postModel.existingImageDoc = widget.todo!.imgDoc;
                      postModel.notifyListeners();
                      showDialogBoxDoc(postModel, context);
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: const BoxDecoration(
                        color: Colors.amber,

                        borderRadius: BorderRadius.all(Radius.circular(
                            10.0)), // Set rounded corner radius// Make rounded corner of border
                      ),
                      child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Choose File",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        postModel.capturedImageDoc == null
            ? Container()
            : Container(
                child: postModel.filebool == false
                    ? Image.file(
                        postModel.capturedImageDoc!,
                        width: MediaQuery.of(context).size.width * .8,
                      )
                    : Column(
                        children: [
                          Text(
                            postModel.updatedAttachedAppDoc,
                            style: textStyle14Bold,
                          ),
                          const Icon(Icons.file_copy),
                        ],
                      ),
              ),
        Visibility(
          visible: widget.todo!.img.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  'View Attached File',
                  style: textStyle14Bold,
                )),
                Expanded(
                  child: Container(
                    height: 45,
                    child: GestureDetector(
                        onTap: () async {
                          var s = widget.todo!.img.split(".");
                          // launch("https://gailebank.gail.co.in//GRMED/UploadedDocs/${widget.todo!.img}");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewImage(
                                        imageUrl:
                                            "https://gailebank.gail.co.in//GRMED/UploadedDocs/${widget.todo!.img}",
                                        type: s[1],
                                      )));
                        },
                        child: Text(
                          'view',
                          style: TextStyle(color: Colors.blue),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Attachment File',
                style: textStyle14Bold,
              )),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    postModel.existingImage = widget.todo!.img;
                    print(
                        "capturedImage :: ${widget.todo!.img}  ${postModel.existingImage}");
                    postModel.notifyListeners();
                    showDialogBox(postModel, context);
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: const BoxDecoration(
                      color: Colors.amber,

                      borderRadius: BorderRadius.all(Radius.circular(
                          10.0)), // Set rounded corner radius// Make rounded corner of border
                    ),
                    child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Choose File",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
        postModel.capturedImage == null
            ? Container()
            : Container(
                child: postModel.filebool == false
                    ? Image.file(
                        postModel.capturedImage!,
                        width: MediaQuery.of(context).size.width * .8,
                      )
                    : Column(
                        children: [
                          Text(
                            postModel.updatedAttachedDoc,
                            style: textStyle14Bold,
                          ),
                          const Icon(Icons.file_copy),
                        ],
                      ),
              )
      ],
    );
  }

  Widget MedicineWidget(ClaimTypeProvider postModel) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PatientBottomSheetWidget(
            content: widget.todo!.patientName,
            heading: "Patient Name",
            claimtype: postModel.patientList!,
            onpressed: (val) {
              postModel.patientname = val;
              setState(() {});
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Bill No.',
                style: textStyle14Bold,
              )),
              Expanded(
                child: Container(
                  child: TextField(
                    readOnly: true,
                    minLines: 1,
                    maxLines: 4,
                    controller: postModel.billNoController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Bill No.',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: BottomSheetWidget(
            content: widget.todo!.illnessType,
            heading: "Chronical/Normal",
            claimtype: postModel.chronicaldata!,
            onpressed: (val) {
              postModel.chronical = val;
              postModel.consultationDate = '--Select Date--';
              postModel.prescriptionDate ='--Select Date--';
              setState(() {});
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Bill Date',
                style: textStyle14Bold,
              )),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: GestureDetector(
                      onTap: () async {
                        var parts = postModel.fin_year.split('-');
                        var prefix = parts[0].trim();

                        String fromApril = "01/04/${prefix}";
                        String toSeptember = "30/09/${prefix}";
                        String toDecemberM = "31/12/${prefix}";
                        var suffix = parts[1].trim();
                        String fromOct = "01/10/${prefix}";
                        String fromMarch = "31/03/${suffix}";
                        String toJune = "30/06/$suffix";

                        postModel.consultationDate =
                            await admissionDate(context);

                        DateTime fromA =
                            DateFormat("dd/MM/yyyy").parse(fromApril);
                        DateTime fromS =
                            DateFormat("dd/MM/yyyy").parse(toSeptember);
                        DateTime fromO =
                            DateFormat("dd/MM/yyyy").parse(fromOct);
                        DateTime fromM =
                            DateFormat("dd/MM/yyyy").parse(fromMarch);
                        DateTime toDecember =
                            DateFormat("dd/MM/yyyy").parse(toDecemberM);
                        DateTime toJuneM =
                            DateFormat("dd/MM/yyyy").parse(toJune);

                        if (postModel.prescriptionDate != '--Select Date--') {
                          DialogUtils.showCustomDialog(context,
                              title: "PRMS",
                              description:
                                  'Prescription date cannot be greater than bill date',
                              onpositivePressed: () {
                            Navigator.pop(context);
                            postModel.prescriptionDate = '--Select Date--';
                            postModel.notifyListeners();
                          });
                        }

                        ///Financial year check
                        if (postModel.consultationDate != '--Select Date--') {
                          DateTime d = DateFormat("dd/MM/yyyy")
                              .parse(postModel.consultationDate);
                          DateTime fromFinancialYear =
                              DateFormat("dd/MM/yyyy").parse(fromApril);
                          DateTime toFinancialYear =
                              DateFormat("dd/MM/yyyy").parse(fromMarch);
                          //&& d.isAfter(fromO) && d.isBefore(fromM)
                          if ((d.isAfter(fromFinancialYear) ||
                                  d.isAtSameMomentAs(fromFinancialYear)) &&
                              (d.isBefore(toFinancialYear) ||
                                  d.isAtSameMomentAs(toFinancialYear))) {
                            if ((d.isBefore(fromS) ||
                                d.isAtSameMomentAs(fromS))) {
                              if ((d.isAfter(fromA) ||
                                      d.isAtSameMomentAs(fromA)) &&
                                  (d.isBefore(fromS) ||
                                      d.isAtSameMomentAs(fromS)) &&
                                  (DateTime.now().isBefore(toDecember) ||
                                      DateTime.now()
                                          .isAtSameMomentAs(toDecember))) {
                                //  postModel.attachFile = false;
                              } else {
                                //  postModel.attachFile = true;
                              }
                            } else {
                              if ((d.isAfter(fromO) ||
                                      d.isAtSameMomentAs(fromO)) &&
                                  (d.isBefore(fromM) ||
                                      d.isAtSameMomentAs(fromM)) &&
                                  (DateTime.now().isBefore(toJuneM) ||
                                      DateTime.now()
                                          .isAtSameMomentAs(toJuneM))) {
                                //  postModel.attachFile = false;
                              } else {
                                //  postModel.attachFile = true;
                              }
                            }
                            postModel.notifyListeners();
                            // if (d.isAfter(fromO) &&
                            //     d.isBefore(fromM) &&
                            //     DateTime.now().isBefore(toJuneM)) {
                            //   postModel.attachFile = false;
                            // } else {
                            //   postModel.attachFile = true;
                            //   print("Alert time is exceed");
                            // }
                            // if (d.isAfter(fromA) &&
                            //     d.isBefore(fromS) &&
                            //     DateTime.now().isBefore(toDecember)) {
                            //   postModel.attachFile = false;
                            // } else {
                            //   postModel.attachFile = true;
                            // }
                          } else {
                            DialogUtils.showCustomDialog(context,
                                title: "PRMS",
                                description:
                                    'Bill Date does not lie within the financial year',
                                onpositivePressed: () {
                              Navigator.pop(context);
                              postModel.consultationDate = "--Select Date--";
                              //   postModel.attachFile = false;
                              postModel.notifyListeners();
                            });
                          }
                        }

                        setState(() {});
                      },
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("${postModel.consultationDate}"),
                          ))),
                  // TextField(
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(),
                  //     hintText: 'Select Consultation Date',
                  //   ),
                  // ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Prescription Date',
                        style: textStyle14Bold,
                      ))),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: GestureDetector(
                      onTap: () async {
                        var parts = postModel.fin_year.split('-');
                        var prefix = parts[0].trim();

                        String fromApril = "01/04/${prefix}";
                        var suffix = parts[1].trim();
                        String fromMarch = "31/03/${suffix}";

                        postModel.prescriptionDate =
                        await _selectPrescriptionDate(context, DateFormat('d/M/y').parse(postModel.consultationDate));

                        var chronical_non = postModel.chronical;
                        print("chronical non chronical :: $chronical_non");

                        var dateTime1 =
                        DateFormat('d/M/y').parse(postModel.consultationDate);
                        var dateTime2 = DateFormat('d/M/y')
                            .parse(postModel.prescriptionDate);
                        DateTime dOneMonth = DateTime(dateTime2.year, dateTime2.month + 1, dateTime2.day);

                        DateTime dSixMonth = DateTime(dateTime2.year, dateTime2.month + 6, dateTime2.day);
                        print(" DATE FROM :: $dSixMonth" );
                        if(chronical_non == "Normal"){
                          if (postModel.prescriptionDate != '--Select Date--' &&
                              postModel.consultationDate != '--Select Date--') {
                            if(dOneMonth.isBefore(dateTime1) || dOneMonth.isAtSameMomentAs(dateTime1)){
                              DialogUtils.showCustomDialog(context,
                                  title: "PRMS",
                                  description:
                                  'Prescription date cannot be greater than One Month to bill date',
                                  onpositivePressed: () {
                                    Navigator.pop(context);
                                    postModel.prescriptionDate = "--Select Date--";
                                    // postModel.attachFile = false;
                                    postModel.notifyListeners();
                                  });
                            }else{

                            }

                          }
                        }else{
                          if (postModel.prescriptionDate != '--Select Date--' &&
                              postModel.consultationDate != '--Select Date--') {
                            if(dSixMonth.isBefore(dateTime1) || dSixMonth.isAtSameMomentAs(dateTime1)){
                              DialogUtils.showCustomDialog(context,
                                  title: "PRMS",
                                  description:
                                  'Prescription date cannot be greater than Six Month to bill date',
                                  onpositivePressed: () {
                                    Navigator.pop(context);
                                    postModel.prescriptionDate = "--Select Date--";
                                    // postModel.attachFile = false;
                                    postModel.notifyListeners();
                                  });
                            }else{

                            }

                          }
                        }

                        // ///Financial year check
                        // if (postModel.prescriptionDate != '--Select Date--' &&
                        //     postModel.consultationDate != '--Select Date--') {
                        //   var dateTime1 = DateFormat('d/M/y')
                        //       .parse(postModel.consultationDate);
                        //   var dateTime2 = DateFormat('d/M/y')
                        //       .parse(postModel.prescriptionDate);
                        //   DateTime d = DateFormat("dd/MM/yyyy")
                        //       .parse(postModel.prescriptionDate);
                        //   DateTime fromFinancialYear =
                        //       DateFormat("dd/MM/yyyy").parse(fromApril);
                        //   DateTime toFinancialYear =
                        //       DateFormat("dd/MM/yyyy").parse(fromMarch);
                        //   if ((d.isAfter(fromFinancialYear) ||
                        //           d.isAtSameMomentAs(fromFinancialYear)) &&
                        //       (d.isBefore(toFinancialYear) ||
                        //           d.isAtSameMomentAs(toFinancialYear))) {
                        //     if (dateTime2.isAfter(dateTime1)) {
                        //       DialogUtils.showCustomDialog(context,
                        //           title: "PRMS",
                        //           description:
                        //               'Prescription date cannot be greater than bill date',
                        //           onpositivePressed: () {
                        //         Navigator.pop(context);
                        //         postModel.prescriptionDate = "--Select Date--";
                        //         // postModel.attachFile = false;
                        //         postModel.notifyListeners();
                        //       });
                        //     }
                        //   } else {
                        //     DialogUtils.showCustomDialog(context,
                        //         title: "PRMS",
                        //         description:
                        //             'Prescription Date does not lie within the financial year',
                        //         onpositivePressed: () {
                        //       Navigator.pop(context);
                        //       postModel.prescriptionDate = "--Select Date--";
                        //       // postModel.attachFile = false;
                        //       postModel.notifyListeners();
                        //     });
                        //   }
                        // } else {
                        //   DialogUtils.showCustomDialog(context,
                        //       title: "PRMS",
                        //       description: 'Bill Date cannot be empty',
                        //       onpositivePressed: () {
                        //     Navigator.pop(context);
                        //     postModel.prescriptionDate = "--Select Date--";
                        //     // postModel.attachFile = false;
                        //     postModel.notifyListeners();
                        //   });
                        // }

                        setState(() {});
                      },
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("${postModel.prescriptionDate}"),
                          ))),
                  // TextField(
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(),
                  //     hintText: 'Select Consultation Date',
                  //   ),
                  // ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Amount Claimed',
                style: textStyle14Bold,
              )),
              Expanded(
                child: Container(
                  // height: 45,
                  child: TextField(
                    controller: postModel.amountController,
                    focusNode: postModel.focusNodeamount,
                    minLines: 1,
                    maxLength: 9,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Enter Claimed Amount',
                      contentPadding: const EdgeInsets.all(12),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(width: 1, color: Colors.indigo),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.indigo),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: widget.todo!.imgDoc.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  'View Approval File',
                  style: textStyle14Bold,
                )),
                Expanded(
                  child: Container(
                    // height: 45,
                    child: GestureDetector(
                        onTap: () {
                          var s = widget.todo!.imgDoc.split(".");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewImage(
                                        imageUrl:
                                            "https://gailebank.gail.co.in//GRMED/UploadedDocs/${widget.todo!.imgDoc}",
                                        type: s[1],
                                      )));
                        },
                        child: Text(
                          'view',
                          style: TextStyle(color: Colors.blue),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: widget.todo!.imgDoc.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  'Approval File',
                  style: textStyle14Bold,
                )),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      postModel.existingImageDoc = widget.todo!.imgDoc;
                      postModel.notifyListeners();
                      showDialogBoxDoc(postModel, context);
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: const BoxDecoration(
                        color: Colors.amber,

                        borderRadius: BorderRadius.all(Radius.circular(
                            10.0)), // Set rounded corner radius// Make rounded corner of border
                      ),
                      child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Choose File",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        postModel.capturedImageDoc == null
            ? Container()
            : Container(
                child: postModel.filebool == false
                    ? Image.file(
                        postModel.capturedImageDoc!,
                        width: MediaQuery.of(context).size.width * .8,
                      )
                    : Column(
                        children: [
                          Text(
                            postModel.updatedAttachedAppDoc,
                            style: textStyle14Bold,
                          ),
                          const Icon(Icons.file_copy),
                        ],
                      ),
              ),
        Visibility(
          visible: widget.todo!.img.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  'View Attachment File',
                  style: textStyle14Bold,
                )),
                Expanded(
                  child: Container(
                    height: 45,
                    child: GestureDetector(
                        onTap: () async {
                          var s = widget.todo!.img.split(".");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewImage(
                                        imageUrl:
                                            "https://gailebank.gail.co.in//GRMED/UploadedDocs/${widget.todo!.img}",
                                        type: s[1],
                                      )));
                        },
                        child: Text(
                          'view',
                          style: TextStyle(color: Colors.blue),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Attachment File',
                style: textStyle14Bold,
              )),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    postModel.existingImage = widget.todo!.img;
                    postModel.notifyListeners();
                    showDialogBox(postModel, context);
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: const BoxDecoration(
                      color: Colors.amber,

                      borderRadius: BorderRadius.all(Radius.circular(
                          10.0)), // Set rounded corner radius// Make rounded corner of border
                    ),
                    child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Choose File",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
        postModel.capturedImage == null
            ? Container()
            : Container(
                child: postModel.filebool == false
                    ? Image.file(
                        postModel.capturedImage!,
                        width: MediaQuery.of(context).size.width * .8,
                      )
                    : Column(
                        children: [
                          Text(
                            postModel.updatedAttachedDoc,
                            style: textStyle14Bold,
                          ),
                          const Icon(Icons.file_copy),
                        ],
                      ),
              )
      ],
    );
  }

  Widget OthersSpecWidget(ClaimTypeProvider postModel) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PatientBottomSheetWidget(
            content: widget.todo!.patientName,
            heading: "Patient Name",
            claimtype: postModel.patientList!,
            onpressed: (val) {
              postModel.patientname = val;
              setState(() {});
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClaimTypeBottomSheetWidget(
            heading: "Claim Type",
            content: widget.todo!.claimOtherType,
            otherclaimModel: postModel.otherclaimmodellist,
            onpressed: (val) {
              postModel.claimtypeother = val;
              setState(() {});
            },
          ),
          // BottomSheetWidget(heading:"Claim Type",claimtype:[],otherclaimModel:postModel.otherclaimmodellist,onpressed: (val){
          //
          // },),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Bill No.',
                style: textStyle14Bold,
              )),
              Expanded(
                child: Container(
                  height: 45,
                  child: TextField(
                    readOnly: true,
                    controller: postModel.billNoController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Bill No.',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Bill Date',
                style: textStyle14Bold,
              )),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: GestureDetector(
                      onTap: () async {
                        var parts = postModel.fin_year.split('-');
                        var prefix = parts[0].trim();

                        String fromApril = "01/04/${prefix}";
                        String toSeptember = "30/09/${prefix}";
                        String toDecemberM = "31/12/${prefix}";
                        var suffix = parts[1].trim();
                        String fromOct = "01/10/${prefix}";
                        String fromMarch = "31/03/${suffix}";
                        String toJune = "30/06/$suffix";

                        postModel.consultationDate =
                            await admissionDate(context);

                        DateTime fromA =
                            DateFormat("dd/MM/yyyy").parse(fromApril);
                        DateTime fromS =
                            DateFormat("dd/MM/yyyy").parse(toSeptember);
                        DateTime fromO =
                            DateFormat("dd/MM/yyyy").parse(fromOct);
                        DateTime fromM =
                            DateFormat("dd/MM/yyyy").parse(fromMarch);
                        DateTime toDecember =
                            DateFormat("dd/MM/yyyy").parse(toDecemberM);
                        DateTime toJuneM =
                            DateFormat("dd/MM/yyyy").parse(toJune);

                        ///Financial year check
                        if (postModel.consultationDate != '--Select Date--') {
                          DateTime d = DateFormat("dd/MM/yyyy")
                              .parse(postModel.consultationDate);
                          DateTime fromFinancialYear =
                              DateFormat("dd/MM/yyyy").parse(fromApril);
                          DateTime toFinancialYear =
                              DateFormat("dd/MM/yyyy").parse(fromMarch);
                          //&& d.isAfter(fromO) && d.isBefore(fromM)
                          if ((d.isAfter(fromFinancialYear) ||
                                  d.isAtSameMomentAs(fromFinancialYear)) &&
                              (d.isBefore(toFinancialYear) ||
                                  d.isAtSameMomentAs(toFinancialYear))) {
                            if ((d.isBefore(fromS) ||
                                d.isAtSameMomentAs(fromS))) {
                              if ((d.isAfter(fromA) ||
                                      d.isAtSameMomentAs(fromA)) &&
                                  (d.isBefore(fromS) ||
                                      d.isAtSameMomentAs(fromS)) &&
                                  (DateTime.now().isBefore(toDecember) ||
                                      DateTime.now()
                                          .isAtSameMomentAs(toDecember))) {
                                //    postModel.attachFile = false;
                              } else {
                                //    postModel.attachFile = true;
                              }
                            } else {
                              if ((d.isAfter(fromO) ||
                                      d.isAtSameMomentAs(fromO)) &&
                                  (d.isBefore(fromM) ||
                                      d.isAtSameMomentAs(fromM)) &&
                                  (DateTime.now().isBefore(toJuneM) ||
                                      DateTime.now()
                                          .isAtSameMomentAs(toJuneM))) {
                                //   postModel.attachFile = false;
                              } else {
                                //    postModel.attachFile = true;
                              }
                            }
                            postModel.notifyListeners();
                            // if (d.isAfter(fromO) &&
                            //     d.isBefore(fromM) &&
                            //     DateTime.now().isBefore(toJuneM)) {
                            //   postModel.attachFile = false;
                            // } else {
                            //   postModel.attachFile = true;
                            //   print("Alert time is exceed");
                            // }
                            // if (d.isAfter(fromA) &&
                            //     d.isBefore(fromS) &&
                            //     DateTime.now().isBefore(toDecember)) {
                            //   postModel.attachFile = false;
                            // } else {
                            //   postModel.attachFile = true;
                            // }
                          } else {
                            DialogUtils.showCustomDialog(context,
                                title: "PRMS",
                                description:
                                    'Bill Date does not lie within the financial year',
                                onpositivePressed: () {
                              Navigator.pop(context);
                              postModel.consultationDate = "--Select Date--";
                              //     postModel.attachFile = false;
                              postModel.notifyListeners();
                            });
                          }
                        }

                        setState(() {});
                      },
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("${postModel.consultationDate}"),
                          ))),
                  // TextField(
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(),
                  //     hintText: 'Select Consultation Date',
                  //   ),
                  // ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Prescription Date',
                style: textStyle14Bold,
              )),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: GestureDetector(
                      onTap: () async {
                        var parts = postModel.fin_year.split('-');
                        var prefix = parts[0].trim();

                        String fromApril = "01/04/${prefix}";
                        var suffix = parts[1].trim();
                        String fromMarch = "31/03/${suffix}";

                        postModel.prescriptionDate =
                            await admissionDate(context);

                        ///Financial year check
                        if (postModel.prescriptionDate != '--Select Date--' &&
                            postModel.consultationDate != '--Select Date--') {
                          var dateTime1 = DateFormat('d/M/y')
                              .parse(postModel.consultationDate);
                          var dateTime2 = DateFormat('d/M/y')
                              .parse(postModel.prescriptionDate);
                          DateTime d = DateFormat("dd/MM/yyyy")
                              .parse(postModel.prescriptionDate);
                          DateTime fromFinancialYear =
                              DateFormat("dd/MM/yyyy").parse(fromApril);
                          DateTime toFinancialYear =
                              DateFormat("dd/MM/yyyy").parse(fromMarch);
                          if ((d.isAfter(fromFinancialYear) ||
                                  d.isAtSameMomentAs(fromFinancialYear)) &&
                              (d.isBefore(toFinancialYear) ||
                                  d.isAtSameMomentAs(toFinancialYear))) {
                            if (dateTime2.isAfter(dateTime1)) {
                              DialogUtils.showCustomDialog(context,
                                  title: "PRMS",
                                  description:
                                      'Prescription date cannot be greater than bill date',
                                  onpositivePressed: () {
                                Navigator.pop(context);
                              });
                            }
                          } else {
                            DialogUtils.showCustomDialog(context,
                                title: "PRMS",
                                description:
                                    'Prescription Date does not lie within the financial year',
                                onpositivePressed: () {
                              Navigator.pop(context);
                              postModel.prescriptionDate = "--Select Date--";
                              //  postModel.attachFile = false;
                              postModel.notifyListeners();
                            });
                          }
                        } else {
                          DialogUtils.showCustomDialog(context,
                              title: "PRMS",
                              description: 'Bill Date cannot be empty',
                              onpositivePressed: () {
                            Navigator.pop(context);
                            postModel.prescriptionDate = "--Select Date--";
                            //  postModel.attachFile = false;
                            postModel.notifyListeners();
                          });
                        }

                        setState(() {});
                      },
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("${postModel.prescriptionDate}"),
                          ))),
                  // TextField(
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(),
                  //     hintText: 'Select Consultation Date',
                  //   ),
                  // ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Amount Claimed',
                style: textStyle14Bold,
              )),
              Expanded(
                child: Container(
                  height: 45,
                  child: TextField(
                    controller: postModel.amountController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Claimed Amount',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Remarks',
                style: textStyle14Bold,
              )),
              Expanded(
                child: Container(
                  height: 45,
                  child: TextField(
                    controller: postModel.remarksController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Remarks',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: widget.todo!.imgDoc.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  'View Approval File',
                  style: textStyle14Bold,
                )),
                Expanded(
                  child: Container(
                    height: 45,
                    child: GestureDetector(
                        onTap: () async {
                          var s = widget.todo!.imgDoc.split(".");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewImage(
                                        imageUrl:
                                            "https://gailebank.gail.co.in//GRMED/UploadedDocs/${widget.todo!.imgDoc}",
                                        type: s[1],
                                      )));
                        },
                        child: Text(
                          'view',
                          style: TextStyle(color: Colors.blue),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: widget.todo!.imgDoc.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  'Attachment File',
                  style: textStyle14Bold,
                )),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      postModel.existingImageDoc = widget.todo!.imgDoc;
                      postModel.notifyListeners();
                      showDialogBoxDoc(postModel, context);
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: const BoxDecoration(
                        color: Colors.amber,

                        borderRadius: BorderRadius.all(Radius.circular(
                            10.0)), // Set rounded corner radius// Make rounded corner of border
                      ),
                      child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Choose File",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        postModel.capturedImageDoc == null
            ? Container()
            : Container(
                child: postModel.filebool == false
                    ? Image.file(
                        postModel.capturedImageDoc!,
                        width: MediaQuery.of(context).size.width * .8,
                      )
                    : Column(
                        children: [
                          Text(
                            postModel.updatedAttachedAppDoc,
                            style: textStyle14Bold,
                          ),
                          const Icon(Icons.file_copy),
                        ],
                      ),
              ),
        Visibility(
          visible: widget.todo!.img.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  'View Attached File',
                  style: textStyle14Bold,
                )),
                Expanded(
                  child: Container(
                    height: 45,
                    child: GestureDetector(
                        onTap: () async {
                          var s = widget.todo!.img.split(".");
                          // launch("https://gailebank.gail.co.in//GRMED/UploadedDocs/${widget.todo!.img}");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewImage(
                                        imageUrl:
                                            "https://gailebank.gail.co.in//GRMED/UploadedDocs/${widget.todo!.img}",
                                        type: s[1],
                                      )));
                        },
                        child: Text(
                          'view',
                          style: TextStyle(color: Colors.blue),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Attachment File',
                style: textStyle14Bold,
              )),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    postModel.existingImage = widget.todo!.img;
                    postModel.notifyListeners();
                    showDialogBox(postModel, context);
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: const BoxDecoration(
                      color: Colors.amber,

                      borderRadius: BorderRadius.all(Radius.circular(
                          10.0)), // Set rounded corner radius// Make rounded corner of border
                    ),
                    child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Choose File",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
        postModel.capturedImage == null
            ? Container()
            : Container(
                child: postModel.filebool == false
                    ? Image.file(
                        postModel.capturedImage!,
                        width: MediaQuery.of(context).size.width * .8,
                      )
                    : Column(
                        children: [
                          Text(
                            postModel.updatedAttachedDoc,
                            style: textStyle14Bold,
                          ),
                          const Icon(Icons.file_copy),
                        ],
                      ),
              )
      ],
    );
  }

  Widget TestopdWidget(ClaimTypeProvider postModel) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: PatientBottomSheetWidget(
            content: widget.todo!.patientName,
            heading: "Patient Name",
            claimtype: postModel.patientList!,
            onpressed: (val) {
              postModel.patientname = val;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Bill No.',
                style: textStyle14Bold,
              )),
              Expanded(
                child: Container(
                  height: 45,
                  child: TextField(
                    readOnly: true,
                    controller: postModel.billNoController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Bill No.',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Bill Date',
                style: textStyle14Bold,
              )),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: GestureDetector(
                      onTap: () async {
                        var parts = postModel.fin_year.split('-');
                        var prefix = parts[0].trim();

                        String fromApril = "01/04/${prefix}";
                        String toSeptember = "30/09/${prefix}";
                        String toDecemberM = "31/12/${prefix}";
                        var suffix = parts[1].trim();
                        String fromOct = "01/10/${prefix}";
                        String fromMarch = "31/03/${suffix}";
                        String toJune = "30/06/$suffix";

                        postModel.consultationDate =
                            await admissionDate(context);

                        DateTime fromA =
                            DateFormat("dd/MM/yyyy").parse(fromApril);
                        DateTime fromS =
                            DateFormat("dd/MM/yyyy").parse(toSeptember);
                        DateTime fromO =
                            DateFormat("dd/MM/yyyy").parse(fromOct);
                        DateTime fromM =
                            DateFormat("dd/MM/yyyy").parse(fromMarch);
                        DateTime toDecember =
                            DateFormat("dd/MM/yyyy").parse(toDecemberM);
                        DateTime toJuneM =
                            DateFormat("dd/MM/yyyy").parse(toJune);

                        ///Financial year check
                        if (postModel.consultationDate != '--Select Date--') {
                          DateTime d = DateFormat("dd/MM/yyyy")
                              .parse(postModel.consultationDate);
                          DateTime fromFinancialYear =
                              DateFormat("dd/MM/yyyy").parse(fromApril);
                          DateTime toFinancialYear =
                              DateFormat("dd/MM/yyyy").parse(fromMarch);
                          //&& d.isAfter(fromO) && d.isBefore(fromM)
                          if ((d.isAfter(fromFinancialYear) ||
                                  d.isAtSameMomentAs(fromFinancialYear)) &&
                              (d.isBefore(toFinancialYear) ||
                                  d.isAtSameMomentAs(toFinancialYear))) {
                            if ((d.isBefore(fromS) ||
                                d.isAtSameMomentAs(fromS))) {
                              if ((d.isAfter(fromA) ||
                                      d.isAtSameMomentAs(fromA)) &&
                                  (d.isBefore(fromS) ||
                                      d.isAtSameMomentAs(fromS)) &&
                                  (DateTime.now().isBefore(toDecember) ||
                                      DateTime.now()
                                          .isAtSameMomentAs(toDecember))) {
                                // postModel.attachFile = false;
                              } else {
                                // postModel.attachFile = true;
                              }
                            } else {
                              if ((d.isAfter(fromO) ||
                                      d.isAtSameMomentAs(fromO)) &&
                                  (d.isBefore(fromM) ||
                                      d.isAtSameMomentAs(fromM)) &&
                                  (DateTime.now().isBefore(toJuneM) ||
                                      DateTime.now()
                                          .isAtSameMomentAs(toJuneM))) {
                                // postModel.attachFile = false;
                              } else {
                                // postModel.attachFile = true;
                              }
                            }
                            postModel.notifyListeners();
                            // if (d.isAfter(fromO) &&
                            //     d.isBefore(fromM) &&
                            //     DateTime.now().isBefore(toJuneM)) {
                            //   postModel.attachFile = false;
                            // } else {
                            //   postModel.attachFile = true;
                            //   print("Alert time is exceed");
                            // }
                            // if (d.isAfter(fromA) &&
                            //     d.isBefore(fromS) &&
                            //     DateTime.now().isBefore(toDecember)) {
                            //   postModel.attachFile = false;
                            // } else {
                            //   postModel.attachFile = true;
                            // }
                          } else {
                            DialogUtils.showCustomDialog(context,
                                title: "PRMS",
                                description:
                                    'Bill Date does not lie within the financial year',
                                onpositivePressed: () {
                              Navigator.pop(context);
                              postModel.consultationDate = "--Select Date--";
                              //   postModel.attachFile = false;
                              postModel.notifyListeners();
                            });
                          }
                        }

                        setState(() {});
                      },
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("${postModel.consultationDate}"),
                          ))),
                  // TextField(
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(),
                  //     hintText: 'Select Consultation Date',
                  //   ),
                  // ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Name Of Lab',
                style: textStyle14Bold,
              )),
              Expanded(
                child: Container(
                  height: 45,
                  child: TextField(
                    controller: postModel.nameOflabController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Name Of Lab',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Particulars of Test',
                style: textStyle14Bold,
              )),
              Expanded(
                child: Container(
                  height: 45,
                  child: TextField(
                    controller: postModel.particularoftestController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Name Of Test',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: BottomSheetWidget(
            content: widget.todo!.illnessType,
            heading: "Chronical/Normal",
            claimtype: postModel.chronicaldata,
            onpressed: (val) {
              postModel.chronical = val;
              setState(() {});
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Amount Claimed',
                style: textStyle14Bold,
              )),
              Expanded(
                child: Container(
                  height: 45,
                  child: TextField(
                    controller: postModel.amountController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Claimed Amount',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Remarks',
                style: textStyle14Bold,
              )),
              Expanded(
                child: Container(
                  height: 45,
                  child: TextField(
                    controller: postModel.remarksController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Remarks',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: widget.todo!.imgDoc.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  'View Approval File',
                  style: textStyle14Bold,
                )),
                Expanded(
                  child: Container(
                    height: 45,
                    child: GestureDetector(
                        onTap: () async {
                          var s = widget.todo!.imgDoc.split(".");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewImage(
                                        imageUrl:
                                            "https://gailebank.gail.co.in//GRMED/UploadedDocs/${widget.todo!.imgDoc}",
                                        type: s[1],
                                      )));
                        },
                        child: Text(
                          'view',
                          style: TextStyle(color: Colors.blue),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: widget.todo!.imgDoc.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  'Attachment File',
                  style: textStyle14Bold,
                )),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      postModel.existingImageDoc = widget.todo!.imgDoc;
                      postModel.notifyListeners();
                      showDialogBoxDoc(postModel, context);
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: const BoxDecoration(
                        color: Colors.amber,

                        borderRadius: BorderRadius.all(Radius.circular(
                            10.0)), // Set rounded corner radius// Make rounded corner of border
                      ),
                      child: const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Choose File",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        postModel.capturedImageDoc == null
            ? Container()
            : Container(
                child: postModel.filebool == false
                    ? Image.file(
                        postModel.capturedImageDoc!,
                        width: MediaQuery.of(context).size.width * .8,
                      )
                    : Column(
                        children: [
                          Text(
                            postModel.updatedAttachedAppDoc,
                            style: textStyle14Bold,
                          ),
                          const Icon(Icons.file_copy),
                        ],
                      ),
              ),
        Visibility(
          visible: widget.todo!.img.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  'View Attached File',
                  style: textStyle14Bold,
                )),
                Expanded(
                  child: Container(
                    height: 45,
                    child: GestureDetector(
                        onTap: () async {
                          var s = widget.todo!.img.split(".");
                          // launch("https://gailebank.gail.co.in//GRMED/UploadedDocs/${widget.todo!.img}");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewImage(
                                        imageUrl:
                                            "https://gailebank.gail.co.in//GRMED/UploadedDocs/${widget.todo!.img}",
                                        type: s[1],
                                      )));
                        },
                        child: Text(
                          'view',
                          style: TextStyle(color: Colors.blue),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                'Attachment File',
                style: textStyle14Bold,
              )),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    postModel.existingImage = widget.todo!.img;
                    postModel.notifyListeners();
                    showDialogBox(postModel, context);
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: const BoxDecoration(
                      color: Colors.amber,

                      borderRadius: BorderRadius.all(Radius.circular(
                          10.0)), // Set rounded corner radius// Make rounded corner of border
                    ),
                    child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Choose File",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
        postModel.capturedImage == null
            ? Container()
            : Container(
                child: postModel.filebool == false
                    ? Image.file(
                        postModel.capturedImage!,
                        width: MediaQuery.of(context).size.width * .8,
                      )
                    : Column(
                        children: [
                          Text(
                            postModel.updatedAttachedDoc,
                            style: textStyle14Bold,
                          ),
                          const Icon(Icons.file_copy),
                        ],
                      ),
              )
      ],
    );
  }

  Future<String> admissionDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate3,
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != selectedDate3)
      setState(() {
        selectedDate3 = selected;
        fromDate = selectedDate3.toString();
      });
    return "${selectedDate3.day}/${selectedDate3.month}/${selectedDate3.year}"
        .toString();
  }

  _selectPrescriptionDate(BuildContext context,DateTime lastdate) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: lastdate,
      firstDate: DateTime(2010),
      lastDate: lastdate,
    );
    if (selected != null && selected != selectedDate1)
      setState(() {
        selectedDate1 = selected;
        toDate = selectedDate1.toString();
      });
    return "${selectedDate1.day}/${selectedDate1.month}/${selectedDate1.year}"
        .toString();
  }


  _selectConsultationDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate2,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate2 = selected;
        fromDate = selectedDate2.toString();
      });
    return "${selectedDate2.day}/${selectedDate2.month}/${selectedDate2.year}"
        .toString();
  }

  void showDialogBox(ClaimTypeProvider postModel, BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Center(child: Text('Choose Option')),
        // content: const Text('AlertDialog description'),
        actions: <Widget>[
          Column(
            children: [
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Cancel');
                    print("-----calling from here------");
                    postModel.galleryImageUpdate();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 1, //                   <--- border width here
                        ),
                      ),
                      // height: 50,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Select photo from gallery',
                            style: TextStyle(fontSize: 13)),
                      )),
                ),
              ),
              // const Spacer(),
              Center(
                child: TextButton(
                  onPressed: () async {
                    Navigator.pop(context, 'OK');
                    postModel.captureImageUpdate();

                    // var status = await Permission.camera.status;
                    // // CaptureImage(id);
                    // if (status.isGranted) {
                    //   CaptureImage(id);

                    //   // We didn't ask for permission yet or the permission has been denied before but not permanently.
                    // } else {
                    //   showCustomDialogBox(
                    //       context: context,
                    //       title: "Alert",
                    //       description: "Permission not granted");
                    // }

                    // Navigator.pop(context, 'OK');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        width: 1, //                   <--- border width here
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(
                          top: 8.0, bottom: 8, left: 6, right: 6),
                      child: Text('Capture photo from camera',
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () async {
                    Navigator.pop(context, 'OK');
                    postModel.chooseFilesUpdate(context);
                    // postModel.captureImage();

                    // var status = await Permission.camera.status;
                    // // CaptureImage(id);
                    // if (status.isGranted) {
                    //   CaptureImage(id);

                    //   // We didn't ask for permission yet or the permission has been denied before but not permanently.
                    // } else {
                    //   showCustomDialogBox(
                    //       context: context,
                    //       title: "Alert",
                    //       description: "Permission not granted");
                    // }

                    // Navigator.pop(context, 'OK');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        width: 1, //                   <--- border width here
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(
                          top: 8.0, bottom: 8, left: 10, right: 15),
                      child: Text(
                        'Select files from phone',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showDialogBoxDoc(ClaimTypeProvider postModel, BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Center(child: Text('Choose Option')),
        // content: const Text('AlertDialog description'),
        actions: <Widget>[
          Column(
            children: [
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Cancel');
                    postModel.galleryImageDocUpdate();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 1, //                   <--- border width here
                        ),
                      ),
                      // height: 50,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Select photo from gallery',
                            style: TextStyle(fontSize: 13)),
                      )),
                ),
              ),
              // const Spacer(),
              Center(
                child: TextButton(
                  onPressed: () async {
                    Navigator.pop(context, 'OK');
                    postModel.captureImageDocUpdate();

                    // var status = await Permission.camera.status;
                    // // CaptureImage(id);
                    // if (status.isGranted) {
                    //   CaptureImage(id);

                    //   // We didn't ask for permission yet or the permission has been denied before but not permanently.
                    // } else {
                    //   showCustomDialogBox(
                    //       context: context,
                    //       title: "Alert",
                    //       description: "Permission not granted");
                    // }

                    // Navigator.pop(context, 'OK');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        width: 1, //                   <--- border width here
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(
                          top: 8.0, bottom: 8, left: 6, right: 6),
                      child: Text('Capture photo from camera',
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () async {
                    Navigator.pop(context, 'OK');
                    postModel.chooseFilesDocUpdate(context);
                    // postModel.captureImage();

                    // var status = await Permission.camera.status;
                    // // CaptureImage(id);
                    // if (status.isGranted) {
                    //   CaptureImage(id);

                    //   // We didn't ask for permission yet or the permission has been denied before but not permanently.
                    // } else {
                    //   showCustomDialogBox(
                    //       context: context,
                    //       title: "Alert",
                    //       description: "Permission not granted");
                    // }

                    // Navigator.pop(context, 'OK');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        width: 1, //                   <--- border width here
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(
                          top: 8.0, bottom: 8, left: 10, right: 15),
                      child: Text(
                        'Select files from phone',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void getCheckData() async {
    if (widget.claimType == "OPD") {
      setState(() {
        opdvisibility = true;
        hospitalvisibility = false;
        claim = "OPD CLAIM";
      });
    } else {
      setState(() {
        opdvisibility = false;
        hospitalvisibility = true;
        claim = "HOSPITALISATION CLAIM";
      });
    }

    if (widget.todo!.claimType == "-1") {
      consulationops = true;
      medicineopd = false;
      othersopd = false;
      testopd = false;
      setState(() {});
    } else if (widget.todo!.claimType == "1") {
      claimTypeValue = "Consultation";
      consulationops = true;
      medicineopd = false;
      othersopd = false;
      testopd = false;
      setState(() {});
    } else if (widget.todo!.claimType == "2") {
      claimTypeValue = "Medicine";
      consulationops = false;
      medicineopd = true;
      othersopd = false;
      testopd = false;
      setState(() {});
    } else if (widget.todo!.claimType == "5") {
      claimTypeValue = "Others";
      consulationops = false;
      medicineopd = false;
      othersopd = true;
      testopd = false;
      setState(() {});
    } else if (widget.todo!.claimType == "3") {
      claimTypeValue = "Test";
      consulationops = false;
      medicineopd = false;
      othersopd = false;
      testopd = true;
      setState(() {});
    } else {
      claimTypeValue = "Hospitalisation";
      setState(() {});
    }
  }

  bool validationMedicine(ClaimTypeProvider postModel) {
    var dateTime1 = DateFormat('d/M/y').parse(postModel.billDate);
    var dateTime2 = DateFormat('d/M/y').parse(postModel.prescriptionDate);

     if (postModel.amountController.text.isEmpty) {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Enter Amount', onpositivePressed: () {
            Navigator.pop(context);
          });
      return false;
    }  else {
      return true;
    }
  }

}



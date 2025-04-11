

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prms/Model/claim_type_model.dart';
import 'package:prms/Provider/claimtypeProvider.dart';
import 'package:prms/Provider/homeprovider.dart';
import 'package:prms/Screens/home_screen.dart';
import 'package:prms/Widget/alert_dialog.dart';
import 'package:prms/Widget/bottomsheetwidget.dart';
import 'package:prms/Widget/claimtypebootomsheet.dart';
import 'package:prms/Widget/customAppBar.dart';
import 'package:prms/Widget/patientBottomSheet.dart';
import 'package:prms/Widget/systemmedicinewidget.dart';
import 'package:prms/styles/text_style.dart';
 
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';

import '../../Model/claim_draft_model.dart';

class ClaimFormScreen extends StatefulWidget {
  const ClaimFormScreen({super.key});

  @override
  State<ClaimFormScreen> createState() => _ClaimFormScreenState();
}

class _ClaimFormScreenState extends State<ClaimFormScreen> {
  bool opdvisibility = false;
  bool hospitalvisibility = false;
  bool consulationops = false,
      medicineopd = false,
      othersopd = false,
      testopd = false;
  DateTime selectedDate = DateTime.now();
  DateTime selectedDate1 = DateTime.now();
  DateTime selectedDate2 = DateTime.now();
  DateTime selectedDate3 = DateTime.now();
  DateTime discharge = DateTime.now();
  String claim = "--Select--";
  String? fromDate, toDate;
  List<String> claimtype = ["--Select--", "OPD", "HOSPITALISATION"];
  List<String> chronicallist = ["Normal", "Chronical"];
  List<String> domicialarylist = [
    "--Select--",
    "HORMONAL THERAPHY",
    "RADIATION"
  ];
  List<String> treatmentlist = [
    "--Select--",
    "Domicialary treat as Hospitalization",
    "Hospitalization"
  ];
  List<String> systemmedicine = [
    "--Select--",
    "Allopathic",
    "Ayurvedic",
    "Homeopathy",
    "Unani & Tibetan"
  ];
  List<String> opdclaimtype = [
    "--Select--",
    "Consultation/Prescription",
    "Medicines,Injections,Dressings & other charge",
    "Others-Spectacle hearing aid artificial dentures",
    "Tests"
  ];
  List<String> otherclaimtype = [
    "--Select--",
    "Artificial Denture Reimbursement",
    "Dental Treatment(Other than Denture)",
    "Health Check up",
    "hearing Aid Reimbursement",
    "Spectacles Reimbursement",
    "Travel"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    final claimTypeProvider =
        Provider.of<ClaimTypeProvider>(context, listen: false);
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    claimTypeProvider.consultationNumberController.clear();
    claimTypeProvider.consultationDate = "--Select Date--";
    claimTypeProvider.physicianController.clear();
    claimTypeProvider.amountController.clear();
    claimTypeProvider.remarksController.clear();
    claimTypeProvider.billNoController.clear();
    claimTypeProvider.billDate = "--Select Date--";
    claimTypeProvider.prescriptionDate = "--Select Date--";
    claimTypeProvider.admissiondate = "--Select Date--";
    claimTypeProvider.dischargedate = "--Select Date--";
    claimTypeProvider.illnesstController.clear();
    claimTypeProvider.nameOflabController.clear();
    claimTypeProvider.particularoftestController.clear();
    claimTypeProvider.base64String = '';
    claimTypeProvider.capturedImage = null;
    claimTypeProvider.financialYearSelect = false;
    homeProvider.fin_year = '';

    // claimTypeProvider.requestPermission();
    claimTypeProvider.getPatientNameData();
    claimTypeProvider.getSystemMedicineData();
    claimTypeProvider.getChronicalData();
    claimTypeProvider.getkGetOtherClaim();
    claimTypeProvider.getTreatmenttypeData();
    claimTypeProvider.getDomiciliaryData();
    claimTypeProvider.getCriticalIllnessData();
    claimTypeProvider.getFinancialYear();
  }

  @override
  Widget build(BuildContext context) {
    final postModel = Provider.of<ClaimTypeProvider>(context);
    final homeModel = Provider.of<HomeProvider>(context);
    final mediaQueryData = MediaQuery.of(context);
    final scale = mediaQueryData.textScaleFactor;

    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'PRMS Claim',
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                            // height: 55,
                            child: DropdownSearch<String>(
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: "Select Claim Type",
                                  //hintText: "Select Duration",
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  // labelStyle: TextStyle( fontSize: 20),
                                ),
                              ),
                              items: claimtype,
                              onChanged: (String? _opdClaim) async {
                                homeModel.fin_year = '';
                                SecureSharedPref preferences =
                                await SecureSharedPref.getInstance();

                                homeModel.isFinancialYear =
                                    homeModel.claimDataType!.contains(_opdClaim);
                                var filteredClaims =
                                homeModel.claimDate!.where((element) {
                                  if (element.containsKey(_opdClaim.toString())) {
                                    homeModel.fin_year = '${element[_opdClaim]}';
                                    postModel.getDataDetailOnDD(homeModel.fin_year);
                                  } else {}
                                  return true;
                                }).toList();

                                if (homeModel.claimDataType!
                                    .contains("HOSPITALISATION") &&
                                    _opdClaim == "HOSPITALISATION") {
                                  DialogUtils.showCustomDialog(context,
                                      title: "PRMS",
                                      description:
                                      'Only one item can be add in Hospitalization',
                                      onpositivePressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => HomeScreen()));
                                      });
                                }

                                preferences.putString("claim_type", _opdClaim!);

                                if (_opdClaim == "OPD") {
                                  postModel.getClaimData(_opdClaim);
                                  setState(() {
                                    opdvisibility = true;
                                    hospitalvisibility = false;
                                    claim = "OPD CLAIM";
                                  });
                                } else if (_opdClaim == "HOSPITALISATION") {
                                  postModel.getClaimData('Hospitalisation');
                                  setState(() {
                                    opdvisibility = false;
                                    hospitalvisibility = true;
                                    claim = "HOSPITALISATION CLAIM";
                                  });
                                } else {
                                  setState(() {
                                    opdvisibility = false;
                                    hospitalvisibility = false;
                                  });
                                }
                              },
                              // =>
                              //     controller.onOpdClaimTypeSelected(opdClaimType: _opdClaim),
                              selectedItem: '--Select--',
                              validator: (value) =>
                              value == null || value == "--Select--"
                                  ? 'field required'
                                  : null,
                              popupProps: PopupProps.menu(
                                  itemBuilder: (context, item, isSelected) {
                                    return Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(item,textScaleFactor: MediaQuery.of(context).textScaleFactor,),
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  homeModel.isFinancialYear
                      ? Visibility(
                    visible: homeModel.isFinancialYear,
                    child: Padding(
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
                              // height: 55,
                                child: Text(
                                  homeModel.fin_year,
                
                                  style: textStyle14Bold,
                                )),
                          ),
                        ],
                      ),
                    ),
                  )
                      : Padding(
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
                            // height: 55,
                            child: DropdownSearch<String>(
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: "Select Financial Year",
                                  //hintText: "Select Duration",
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  // labelStyle: TextStyle( fontSize: 20),
                                ),
                              ),
                              items: postModel.financialYearDataList,
                              selectedItem: '--Select--',
                              onChanged: (String? _opdClaim) async {
                                postModel.fin_year = _opdClaim!;
                                homeModel.fin_year = _opdClaim!;
                                postModel.consultationDate =
                                "--Select Date--";
                                postModel.billDate = "--Select Date--";
                                postModel.admissiondate = "--Select Date--";
                                postModel.dischargedate = "--Select Date--";
                                postModel.prescriptionDate =
                                "--Select Date--";
                                postModel.notifyListeners();
                                postModel.getDataDetailOnDD(_opdClaim!);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: claim == 'OPD CLAIM' && homeModel.fin_year != '',
                    child: Column(
                      children: [
                        Text(
                          'Remaining Entitlement',
        
                          style: textStyle14Bold,
                        ),
                        Visibility(
                          visible: postModel.financialYearSelect,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                      'OPD',
                    
                                      style: textStyle14Bold,
                                    )),
                                Expanded(
                                    child: Text(
                                      '${postModel.opdDetailModel?.opd}',
                    
                                      style: textStyle14Bold,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: postModel.financialYearSelect,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                      'Spectacle',
                    
                                      style: textStyle14Bold,
                                    )),
                                Expanded(
                                    child: Text(
                                      '${postModel.opdDetailModel?.specs} (Block Year: ${postModel.opdDetailModel?.specs_Block_year})',
                    
                                      style: textStyle14Bold,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      // height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xffF6F3F3FF),
                        borderRadius: BorderRadius.all(Radius.circular(
                            10.0)), // Set rounded corner radius// Make rounded corner of border
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            claim.toString(),
          
                            style: textStyle14Bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: opdvisibility,
                      child: opdWidget(postModel.claimtypemodel, postModel)),
                  Visibility(
                      visible: hospitalvisibility,
                      child: hospitalWidget(postModel)),
                  Padding(
                    padding:
                    const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 20.0),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 1,
                        child: ElevatedButton(
                            onPressed: () async {
                              postModel.focusNode.unfocus();
                              postModel.focusNodeamount.unfocus();
                              postModel.focusNoderemarks.unfocus();

                              postModel.notifyListeners();

                              if (postModel.capturedImage == null) {
                                postModel.filetype = '';
                              }

                              await Future.delayed(
                                  const Duration(milliseconds: 500));
                              if (postModel.claimtype == "" ||
                                  postModel.claimtype == null) {
                                DialogUtils.showCustomDialog(context,
                                    title: "PRMS",
                                    description: 'Please Select Claim Type',
                                    onpositivePressed: () {
                                      Navigator.pop(context);
                                    });
                              } else {
                                if (postModel.claimtype == "4") {
                                  if (validationHospitalization(postModel)) {
                                    postModel.getDataToList(context);
                                  }
                                } else if (postModel.claimtype == "1") {
                                  if (validationConsultation(postModel)) {
                                    postModel.getDataToList(context);
                                  }
                                  // postModel.getDataToList(context);
                                } else if (postModel.claimtype == "2") {
                                  if (validationMedicine(postModel)) {
                                    postModel.getDataToList(context);
                                  }
                                } else if (postModel.claimtype == "5") {
                                  if (validationOthers(postModel)) {
                                    int amount = 0;

                                    if (postModel.claimtypeother ==
                                        'Spectacles Reimbursement') {
                                      postModel.opdDetailModel!.specs;
                                      homeModel.claimData!.where((element) {
                                        if (element.claimType == 'OPD') {
                                          var l = element.claimDataList.length;
                                          for (ClaimDataList a
                                          in element.claimDataList) {
                                            amount =
                                                amount + int.parse(a.amtClaimed);
                                          }
                                        }
                                        return false;
                                      }).toList();
                                      int finalAmount = amount +
                                          int.parse(postModel.amountController.text
                                              .toString());
                                      if (postModel.opdDetailModel!.specs! >=
                                          finalAmount) {
                                        postModel.blockYearSelected = postModel
                                            .opdDetailModel!.specs_Block_year!;
                                        postModel.getDataToList(context);
                                      } else {
                                        DialogUtils.showCustomDialog(context,
                                            title: "PRMS",
                                            description:
                                            'Requested Amount exceeds entitlement amount',
                                            onpositivePressed: () {
                                              Navigator.pop(context);
                                              postModel.amountController.clear();
                                              postModel.notifyListeners();
                                            });
                                      }
                                    } else {
                                      postModel.getDataToList(context);
                                    }
                                  }
                                } else if (postModel.claimtype == "3") {
                                  if (validationTest(postModel)) {
                                    postModel.getDataToList(context);
                                  }
                                }
                              }

                              //
                              // if (_formKey.currentState!.validate()) {
                              //   _formKey.currentState!.save();
                              //
                              // }
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => const HomeScreen()));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                textStyle: const TextStyle(
                                  // fontSize: 30,
                                    fontWeight: FontWeight.bold)),
                            child: const Text(
                              "Add to list",
            
                              style: TextStyle(color: Colors.white),
                            ))),
                  )
                ],
              ),
            ),
          ),
        ),);
  }

  Widget opdWidget(
      List<ClaimTypeModel>? claimtypemodel, ClaimTypeProvider postModel) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: BottomSheetWidget(
            content: "--Select Claim Type--",
            heading: "Claim Type",
            claimtype: claimtypemodel != null ? claimtypemodel : [],
            onpressed: (val) {
              postModel.claimtype = val;
              if (val == "-1") {
                consulationops = false;
                medicineopd = false;
                othersopd = false;
                testopd = false;
                setState(() {});
              } else if (val == "1") {
                consulationops = true;
                medicineopd = false;
                othersopd = false;
                testopd = false;
                setState(() {});
              } else if (val == "2") {
                consulationops = false;
                medicineopd = true;
                othersopd = false;
                testopd = false;
                setState(() {});
              } else if (val == "5") {
                consulationops = false;
                medicineopd = false;
                othersopd = true;
                testopd = false;
                setState(() {});
              } else if (val == "3") {
                consulationops = false;
                medicineopd = false;
                othersopd = false;
                testopd = true;
                setState(() {});
              }
            },
          ),
        ),
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
    var homeProvider = Provider.of<HomeProvider>(context);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BottomSheetWidget(
              content: "--Select Claim Type--",
              heading: "Claim Type",
              claimtype: postModel.claimtypemodel!,
              onpressed: (val) {
                postModel.claimtype = val;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PatientBottomSheetWidget(
              content: "--Select Patient Name--",
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
                    // height: 45,
                    child: TextFormField(
                      focusNode: postModel.focusNode,
                      minLines: 1,
                      maxLines: null,
                      autocorrect: false,
                      keyboardType: TextInputType.multiline,
                      controller: postModel.billNoController,
                      toolbarOptions: const ToolbarOptions(
                        copy: false,
                        cut: false,
                        paste: false,
                        selectAll: false,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (_desc) =>
                          _desc!.isEmpty ? "Kindly Enter Bill No" : null,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9 ]')),
                      ],
                      decoration: InputDecoration(
                        labelText: "Enter Bill No.",
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
                          if (postModel.fin_year == '') {
                            postModel.fin_year = homeProvider.fin_year;
                          }
                          var parts = postModel.fin_year.split('-');
                          var prefix = parts[0].trim();

                          String fromApril = "01/04/${prefix}";

                          var suffix = parts[1].trim();
                          String fromMarch = "31/03/${suffix}";

                          postModel.billDate = await admissionDate(context);

                          ///Financial year check
                          if (postModel.billDate != '--Select Date--') {
                            DateTime d = DateFormat("dd/MM/yyyy")
                                .parse(postModel.billDate);
                            DateTime fromFinancialYear =
                                DateFormat("dd/MM/yyyy").parse(fromApril);
                            DateTime toFinancialYear =
                                DateFormat("dd/MM/yyyy").parse(fromMarch);
                            //&& d.isAfter(fromO) && d.isBefore(fromM)
                            if ((d.isAfter(fromFinancialYear) ||
                                    d.isAtSameMomentAs(fromFinancialYear)) &&
                                (d.isBefore(toFinancialYear) ||
                                    d.isAtSameMomentAs(toFinancialYear))) {
                            } else {
                              DialogUtils.showCustomDialog(context,
                                  title: "PRMS",
                                  description:
                                      'Bill Date does not lie within the financial year',
                                  onpositivePressed: () {
                                Navigator.pop(context);
                                postModel.billDate = "--Select Date--";
                                postModel.attachFile = false;
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
                              child: Text("${postModel.billDate}",textScaleFactor: MediaQuery.of(context).textScaleFactor,),
                            ))),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Widgetforsystemmedicine(
              content: "--Select Treatment Type--",
              heading: "Treatment Type",
              systemMedicine: postModel.traetmenttypeList,
              onpressed: (val) {
                postModel.treatment = val;
                if (val.contains('Domicialary')) {
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
                    // height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.black,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(5))),
                    child: GestureDetector(
                        onTap: () async {
                          if (postModel.fin_year == '') {
                            postModel.fin_year = homeProvider.fin_year;
                          }
                          var parts = postModel.fin_year.split('-');
                          var prefix = parts[0].trim();

                          String fromApril = "01/04/${prefix}";

                          var suffix = parts[1].trim();

                          String fromMarch = "31/03/${suffix}";

                          postModel.admissiondate = await admissionDate(context);

                          ///Financial year check
                          if (postModel.admissiondate != '--Select Date--' &&
                              postModel.billDate != '--Select Date--') {
                            DateTime d = DateFormat("dd/MM/yyyy")
                                .parse(postModel.admissiondate);

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
                                postModel.attachFile = false;
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
                              child: Text("${postModel.admissiondate}",textScaleFactor: MediaQuery.of(context).textScaleFactor,),
                            ))),
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
                          if (postModel.fin_year == '') {
                            postModel.fin_year = homeProvider.fin_year;
                          }
                          var parts = postModel.fin_year.split('-');
                          var prefix = parts[0].trim();

                          String fromApril = "01/04/${prefix}";

                          var suffix = parts[1].trim();
                          String fromMarch = "31/03/${suffix}";

                          postModel.dischargedate = await dischargeDate(context);

                          ///Financial year check
                          if (postModel.dischargedate != '--Select Date--' &&
                              postModel.admissiondate != '--Select Date--' &&
                              postModel.billDate != '--Select Date--') {
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
                              var billdate =
                                  DateFormat('d/M/y').parse(postModel.billDate);
                              var admsndate = DateFormat('d/M/y')
                                  .parse(postModel.admissiondate);
                              var dschrgedate = DateFormat('d/M/y')
                                  .parse(postModel.dischargedate);
                              int difference =
                                  daysBetween(dschrgedate, DateTime.now());

                              if (difference <= 90) {
                                postModel.attachFile = false;
                              } else {
                                postModel.attachFile = true;
                              }
                              postModel.notifyListeners();

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
                                        'Discharge date should be equal or less than Bill date',
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
                                postModel.attachFile = false;
                                postModel.notifyListeners();
                              });
                            }
                          } else {
                            DialogUtils.showCustomDialog(context,
                                title: "PRMS",
                                description:
                                    'Please fill bill date and admission date',
                                onpositivePressed: () {
                              postModel.dischargedate = "--Select Date--";
                              postModel.admissiondate = "--Select Date--";
                              postModel.billDate = "--Select Date--";
                              Navigator.pop(context);
                              postModel.notifyListeners();
                            });
                          }
                        },
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${postModel.dischargedate}",textScaleFactor: MediaQuery.of(context).textScaleFactor,),
                            ))),
                  ),
                ),
              ],
            ),
          ),
          // Visibility(
          // visible: postModel.attachFile,
          //     child: Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Text("As the discharge date is more than 3 months prior to today, so please attach approval from the concerned authority"),
          // )),
          Visibility(
            visible: postModel.domiciliaryvisibility,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Widgetforsystemmedicine(
                content: "--Select Domiciliary treatment--",
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
              content: "--Select Critical Illness--",
              heading: "Critical Illness",
              systemMedicine: postModel.criticalIllnessDataList,
              onpressed: (val) {
                postModel.critical = val;
                postModel.illnesstController.text = val;
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
                    // height: 45,
                    child: TextField(
                      controller: postModel.illnesstController,
                      maxLines: 5,
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
                    // height: 45,
                    child: TextFormField(
                      focusNode: postModel.focusNodeamount,
                      minLines: 1,
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      controller: postModel.amountController,
                      toolbarOptions: const ToolbarOptions(
                        copy: false,
                        cut: false,
                        paste: false,
                        selectAll: false,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (_desc) =>
                          _desc!.isEmpty ? "Kindly Enter Amount" : null,
                      decoration: InputDecoration(
                        labelText: "Enter Claimed Amount",
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
                    // height: 45,
                    child: TextFormField(
                      focusNode: postModel.focusNoderemarks,
                      minLines: 1,
                      maxLines: null,
                      autocorrect: false,
                      keyboardType: TextInputType.multiline,
                      controller: postModel.remarksController,
                      toolbarOptions: const ToolbarOptions(
                        copy: false,
                        cut: false,
                        paste: false,
                        selectAll: false,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (_desc) =>
                          _desc!.isEmpty ? "Kindly Enter Remarks" : null,
                      decoration: InputDecoration(
                        // errorBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(10.0),
                        //   // ignore: prefer_const_constructors
                        //   borderSide: BorderSide(
                        //     color: Colors.red,
                        //     width: 2.0,
                        //   ),
                        // ),
                        labelText: "Enter Remarks",
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
            visible: postModel.attachFile,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    '* As the discharge date is more than 3 months prior to today, so please attach approval from the concerned authority',
  
                    style: textStyle14Bold,
                  )),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
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
              : SizedBox(
                  child: postModel.fileboolDoc == false
                      ? Image.file(
                          postModel.capturedImageDoc!,
                          width: MediaQuery.of(context).size.width * .8,
                        )
                      : Column(
                          children: [
                            Text(
                              postModel.attachedAppDoc,
            
                              style: textStyle14Bold,
                            ),
                            const Icon(Icons.file_copy),
                          ],
                        ),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  'Attach File',
                  style: textStyle14Bold,
                )),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      showDialogBox(postModel, context);
                    },
                    child: Container(
                      height: 40,
                      width: 300,
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.all(Radius.circular(
                            10.0)), // Set rounded corner radius// Make rounded corner of border
                      ),
                      child: const Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Choose File",
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
          postModel.capturedImage == null
              ? Container()
              : SizedBox(
                  child: postModel.filebool == false
                      ? Image.file(
                          postModel.capturedImage!,
                          width: MediaQuery.of(context).size.width * .8,
                        )
                      : Column(
                          children: [
                            Text(
                              postModel.attachedDoc,
            
                              style: textStyle14Bold,
                            ),
                            const Icon(Icons.file_copy),
                          ],
                        ),
                ),
          Row(
            children: <Widget>[
              Checkbox(
                checkColor: Colors.greenAccent,
                activeColor: Colors.blue,
                value: postModel.valuefirst,
                onChanged: (value) {
                  setState(() {
                    if (value == false) {
                      postModel.valuefirst = false;
                    } else {
                      postModel.valuefirst = true;
                    }
                  });
                },
              ),
               Text(
                'Prior/Post-Facto Permission Obtained ',
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                maxLines:2,
                style: TextStyle(fontSize: 11.0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  Widget consulatationWidget(
      List<ClaimTypeModel>? claimtypemodel, ClaimTypeProvider postModel) {
    var homeProvider = Provider.of<HomeProvider>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PatientBottomSheetWidget(
              content: "--Select Patient Name--",
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
                  'Consultation No.',
                  style: textStyle14Bold,
                )),
                Expanded(
                  child: Container(
                    // height: 45,
                    child: TextFormField(
                      focusNode: postModel.focusNode,
                      minLines: 1,
                      maxLines: null,
                      autocorrect: false,
                      // keyboardType: TextInputType.multiline,
                      controller: postModel.consultationNumberController,
                      toolbarOptions: const ToolbarOptions(
                        copy: false,
                        cut: false,
                        paste: false,
                        selectAll: false,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9 ]')),
                        // FilteringTextInputFormatter.deny(
                        //     RegExp(r'[!@#$%^&*(),.?":{}|<>]'))
                      ],
                      textCapitalization: TextCapitalization.sentences,
                      validator: (_desc) => _desc!.isEmpty
                          ? "Kindly Enter Consultation No"
                          : null,
                      decoration: InputDecoration(
                        // errorBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(10.0),
                        //   // ignore: prefer_const_constructors
                        //   borderSide: BorderSide(
                        //     color: Colors.red,
                        //     width: 2.0,
                        //   ),
                        // ),
                        labelText: "Consultation No",
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.indigo),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.indigo),
                        ),
                      ),
                    ),

                    // TextField(
                    //   controller: postModel.consultationNumberController,
                    //
                    //   decoration: const InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     hintText: 'Consultation no',
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                    child: GestureDetector(
                        onTap: () async {
                          if (postModel.fin_year == '') {
                            postModel.fin_year = homeProvider.fin_year;
                          }
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
                              await consulationDate(context);

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
                                  postModel.attachFile = false;
                                } else {
                                  postModel.attachFile = true;
                                }
                              } else {
                                if ((d.isAfter(fromO) ||
                                        d.isAtSameMomentAs(fromO)) &&
                                    (d.isBefore(fromM) ||
                                        d.isAtSameMomentAs(fromM)) &&
                                    (DateTime.now().isBefore(toJuneM) ||
                                        DateTime.now()
                                            .isAtSameMomentAs(toJuneM))) {
                                  postModel.attachFile = false;
                                } else {
                                  postModel.attachFile = true;
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
                                postModel.attachFile = false;
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
                              child: Text("${postModel.consultationDate}",
            ),
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
              content: "--Select System of Medicine--",
              heading: "System of Medicine",
              systemMedicine: postModel.systemofmedicineList,
              onpressed: (val) {
                postModel.systemofmedicine = val;
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
                    child: TextField(
                      controller: postModel.physicianController,
                      minLines: 1,
                      maxLines: null,
                      autocorrect: false,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        // errorBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(10.0),
                        //   // ignore: prefer_const_constructors
                        //   borderSide: BorderSide(
                        //     color: Colors.red,
                        //     width: 2.0,
                        //   ),
                        // ),
                        labelText: "Enter Physician Name",
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.indigo),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.indigo),
                        ),
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
              content: "--Select Chronical/Normal--",
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
                    // height: 45,
                    child: TextFormField(
                      focusNode: postModel.focusNodeamount,
                      minLines: 1,
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      controller: postModel.amountController,
                      toolbarOptions: const ToolbarOptions(
                        copy: false,
                        cut: false,
                        paste: false,
                        selectAll: false,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (_desc) =>
                          _desc!.isEmpty ? "Kindly Enter Claimed Amount" : null,
                      decoration: InputDecoration(
                        // errorBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(10.0),
                        //   // ignore: prefer_const_constructors
                        //   borderSide: BorderSide(
                        //     color: Colors.red,
                        //     width: 2.0,
                        //   ),
                        // ),
                        labelText: "Enter Claimed Amount",
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.indigo),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.indigo),
                        ),
                      ),
                    ),

                    // TextField(
                    //   controller: postModel.amountController,
                    //   keyboardType: TextInputType.number,
                    //   decoration: const InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     hintText: 'Enter Claimed Amount',
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
                  'Remarks',

                  style: textStyle14Bold,
                )),
                Expanded(
                  child: Container(
                    // height: 45,
                    child: TextFormField(
                      focusNode: postModel.focusNoderemarks,
                      minLines: 1,
                      maxLines: null,
                      autocorrect: false,
                      keyboardType: TextInputType.multiline,
                      controller: postModel.billNoController,
                      toolbarOptions: const ToolbarOptions(
                        copy: false,
                        cut: false,
                        paste: false,
                        selectAll: false,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (_desc) =>
                          _desc!.isEmpty ? "Kindly Enter Remarks" : null,
                      decoration: InputDecoration(
                        // errorBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(10.0),
                        //   // ignore: prefer_const_constructors
                        //   borderSide: BorderSide(
                        //     color: Colors.red,
                        //     width: 2.0,
                        //   ),
                        // ),
                        labelText: "Enter Remarks",
                        contentPadding: const EdgeInsets.all(12),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.indigo),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 2, color: Colors.indigo),
                        ),
                      ),
                    ),

                    // TextField(
                    //   controller: postModel.remarksController,
                    //   decoration: const InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     hintText: 'Enter Remarks',
                    //   ),
                    // ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: postModel.attachFile,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    '* Please attach approval from concerned authority for late claim submission',
  
                    style: textStyle14Bold,
                  )),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
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
              : SizedBox(
                  child: postModel.fileboolDoc == false
                      ? Image.file(
                          postModel.capturedImageDoc!,
                          width: MediaQuery.of(context).size.width * .8,
                        )
                      : Column(
                          children: [
                            Text(
                              postModel.attachedAppDoc,
            
                              style: textStyle14Bold,
                            ),
                            const Icon(Icons.file_copy),
                          ],
                        ),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  'Attach File',
                  style: textStyle14Bold,
                )),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      showDialogBox(postModel, context);
                    },
                    child: Container(
                      height: 40,
                      width: 300,
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
              : SizedBox(
                  // height: 200,
                  child: postModel.filebool == false
                      ? Image.file(
                          postModel.capturedImage!,
                          width: MediaQuery.of(context).size.width * 0.8,
                        )
                      : Column(
                          children: [
                            Text(
                              postModel.attachedDoc,
            
                              style: textStyle14Bold,
                            ),
                            const Icon(Icons.file_copy),
                          ],
                        ),
                )
        ],
      ),
    );
  }

  Widget MedicineWidget(ClaimTypeProvider postModel) {
    var homeProvider = Provider.of<HomeProvider>(context);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PatientBottomSheetWidget(
              content: "--Select Patient Name--",
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
                    // height: 45,
                    child: TextFormField(
                      focusNode: postModel.focusNode,
                      minLines: 1,
                      maxLines: null,
                      autocorrect: false,
                      // keyboardType: TextInputType.multiline,
                      controller: postModel.billNoController,
                      toolbarOptions: const ToolbarOptions(
                        copy: false,
                        cut: false,
                        paste: false,
                        selectAll: false,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (_desc) =>
                          _desc!.isEmpty ? "Kindly Enter Bill No" : null,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9 ]')),
                        // FilteringTextInputFormatter.deny(
                        //     RegExp(r'[!@#$%^&*(),.?":{}|<>]'))
                      ],
                      decoration: InputDecoration(
                        labelText: "Enter Bill No.",
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
                          if (postModel.fin_year == '') {
                            postModel.fin_year = homeProvider.fin_year;
                          }
                          var parts = postModel.fin_year.split('-');
                          var prefix = parts[0].trim();

                          String fromApril = "01/04/${prefix}";
                          String toSeptember = "30/09/${prefix}";
                          String toDecemberM = "31/12/${prefix}";
                          var suffix = parts[1].trim();
                          String fromOct = "01/10/${prefix}";
                          String fromMarch = "31/03/${suffix}";
                          String toJune = "30/06/$suffix";

                          postModel.billDate = await admissionDate(context);

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
                          if (postModel.billDate != '--Select Date--') {
                            DateTime d = DateFormat("dd/MM/yyyy")
                                .parse(postModel.billDate);
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
                                        d.isAtSameMomentAs(fromS)) &&
                                    (d.isBefore(fromS) ||
                                        d.isAtSameMomentAs(fromS)) &&
                                    (DateTime.now().isBefore(toDecember) ||
                                        DateTime.now()
                                            .isAtSameMomentAs(toDecember))) {
                                  postModel.attachFile = false;
                                } else {
                                  postModel.attachFile = true;
                                }
                              } else {
                                if ((d.isAfter(fromO) ||
                                        d.isAtSameMomentAs(fromO)) &&
                                    (d.isBefore(fromM) ||
                                        d.isAtSameMomentAs(fromM)) &&
                                    (DateTime.now().isBefore(toJuneM) ||
                                        DateTime.now()
                                            .isAtSameMomentAs(toJuneM))) {
                                  postModel.attachFile = false;
                                } else {
                                  postModel.attachFile = true;
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
                                postModel.billDate = "--Select Date--";
                                postModel.attachFile = false;
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
                              child: Text("${postModel.billDate}",
            ),
                            ))),
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
                          if (postModel.fin_year == '') {
                            postModel.fin_year = homeProvider.fin_year;
                          }

                          var parts = postModel.fin_year.split('-');
                          var prefix = parts[0].trim();

                          String fromApril = "01/04/${prefix}";
                          var suffix = parts[1].trim();
                          String fromMarch = "31/03/${suffix}";

                          postModel.prescriptionDate =
                              await _selectPrescriptionDate(context);

                          ///Financial year check
                          if (postModel.prescriptionDate != '--Select Date--' &&
                              postModel.billDate != '--Select Date--') {
                            var dateTime1 =
                                DateFormat('d/M/y').parse(postModel.billDate);
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
                                  postModel.prescriptionDate = "--Select Date--";
                                  // postModel.attachFile = false;
                                  postModel.notifyListeners();
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
                                // postModel.attachFile = false;
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
                              // postModel.attachFile = false;
                              postModel.notifyListeners();
                            });
                          }

                          setState(() {});
                        },
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${postModel.prescriptionDate}",
            ),
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
            child: BottomSheetWidget(
              content: "--Select Chronical/Normal--",
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
                    // height: 45,
                    child: TextFormField(
                      focusNode: postModel.focusNodeamount,
                      minLines: 1,
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      controller: postModel.amountController,
                      toolbarOptions: const ToolbarOptions(
                        copy: false,
                        cut: false,
                        paste: false,
                        selectAll: false,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (_desc) =>
                          _desc!.isEmpty ? "Kindly Enter Claimed Amount" : null,
                      decoration: InputDecoration(
                        // errorBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(10.0),
                        //   // ignore: prefer_const_constructors
                        //   borderSide: BorderSide(
                        //     color: Colors.red,
                        //     width: 2.0,
                        //   ),
                        // ),
                        labelText: "Enter Claimed Amount",
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

                    // TextField(
                    //   controller: postModel.amountController,
                    //   keyboardType: TextInputType.number,
                    //   decoration: const InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     hintText: 'Enter Claimed Amount',
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
                  'Remarks',

                  style: textStyle14Bold,
                )),
                Expanded(
                  child: TextFormField(
                    focusNode: postModel.focusNoderemarks,
                    maxLines: null,
                    minLines: 1,
                    autocorrect: false,
                    // keyboardType: TextInputType.multiline,
                    controller: postModel.remarksController,
                    toolbarOptions: const ToolbarOptions(
                      copy: false,
                      cut: false,
                      paste: false,
                      selectAll: false,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (_desc) =>
                        _desc!.isEmpty ? "Kindly Enter Remarks" : null,
                    decoration: InputDecoration(
                      labelText: "Enter Remarks",
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
              ],
            ),
          ),
          Visibility(
            visible: postModel.attachFile,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    '* Please attach approval from concerned authority for late claim submission',
                    style: textStyle14Bold,
                  )),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
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
              : SizedBox(
                  child: postModel.fileboolDoc == false
                      ? Image.file(
                          postModel.capturedImageDoc!,
                          width: MediaQuery.of(context).size.width * .8,
                        )
                      : Column(
                          children: [
                            Text(
                              postModel.attachedAppDoc,
            
                              style: textStyle14Bold,
                            ),
                            const Icon(Icons.file_copy),
                          ],
                        ),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  'Attach File',

                  style: textStyle14Bold,
                )),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      showDialogBox(postModel, context);
                    },
                    child: Container(
                      height: 40,
                      width: 300,
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
              : SizedBox(
                  child: postModel.filebool == false
                      ? Image.file(
                          postModel.capturedImage!,
                          width: MediaQuery.of(context).size.width * .8,
                        )
                      : Column(
                          children: [
                            Text(
                              postModel.attachedDoc,
            
                              style: textStyle14Bold,
                            ),
                            const Icon(Icons.file_copy),
                          ],
                        ),
                )
        ],
      ),
    );
  }

  Widget OthersSpecWidget(ClaimTypeProvider postModel) {
    var homeProvider = Provider.of<HomeProvider>(context);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PatientBottomSheetWidget(
              content: "--Select Patient Name--",
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
            child: ClaimTypeBottomSheetWidget(
              heading: "Claim Type",
              content: "--Select--",
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
                    // height: 45,
                    child: TextFormField(
                      focusNode: postModel.focusNode,
                      minLines: 1,
                      maxLines: null,
                      autocorrect: false,
                      keyboardType: TextInputType.multiline,
                      controller: postModel.billNoController,
                      toolbarOptions: const ToolbarOptions(
                        copy: false,
                        cut: false,
                        paste: false,
                        selectAll: false,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9 ]')),
                        // FilteringTextInputFormatter.deny(
                        //     RegExp(r'[!@#$%^&*(),.?":{}|<>]'))
                      ],
                      textCapitalization: TextCapitalization.sentences,
                      validator: (_desc) =>
                          _desc!.isEmpty ? "Kindly Enter Bill No" : null,
                      decoration: InputDecoration(
                        // errorBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(10.0),
                        //   // ignore: prefer_const_constructors
                        //   borderSide: BorderSide(
                        //     color: Colors.red,
                        //     width: 2.0,
                        //   ),
                        // ),
                        labelText: "Enter Bill No.",
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

                    // TextField(
                    //   controller: postModel.billNoController,
                    //   decoration: const InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     hintText: 'Enter Bill No.',
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
                          if (postModel.fin_year == '') {
                            postModel.fin_year = homeProvider.fin_year;
                          }
                          var parts = postModel.fin_year.split('-');
                          var prefix = parts[0].trim();

                          String fromApril = "01/04/${prefix}";
                          String toSeptember = "30/09/${prefix}";
                          String toDecemberM = "31/12/${prefix}";
                          var suffix = parts[1].trim();
                          String fromOct = "01/10/${prefix}";
                          String fromMarch = "31/03/${suffix}";
                          String toJune = "30/06/$suffix";

                          postModel.billDate = await admissionDate(context);

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
                          if (postModel.billDate != '--Select Date--') {
                            DateTime d = DateFormat("dd/MM/yyyy")
                                .parse(postModel.billDate);
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
                                  postModel.attachFile = false;
                                } else {
                                  postModel.attachFile = true;
                                }
                              } else {
                                if ((d.isAfter(fromO) ||
                                        d.isAtSameMomentAs(fromO)) &&
                                    (d.isBefore(fromM) ||
                                        d.isAtSameMomentAs(fromM)) &&
                                    (DateTime.now().isBefore(toJuneM) ||
                                        DateTime.now()
                                            .isAtSameMomentAs(toJuneM))) {
                                  postModel.attachFile = false;
                                } else {
                                  postModel.attachFile = true;
                                }
                              }
                              postModel.notifyListeners();
                            } else {
                              DialogUtils.showCustomDialog(context,
                                  title: "PRMS",
                                  description:
                                      'Bill Date does not lie within the financial year',
                                  onpositivePressed: () {
                                Navigator.pop(context);
                                postModel.billDate = "--Select Date--";
                                postModel.attachFile = false;
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
                              child: Text("${postModel.billDate}",textScaleFactor: MediaQuery.of(context).textScaleFactor,),
                            ))),
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
                          if (postModel.fin_year == '') {
                            postModel.fin_year = homeProvider.fin_year;
                          }

                          var parts = postModel.fin_year.split('-');
                          var prefix = parts[0].trim();

                          String fromApril = "01/04/${prefix}";
                          var suffix = parts[1].trim();
                          String fromMarch = "31/03/${suffix}";

                          postModel.prescriptionDate =
                              await admissionDate(context);

                          ///Financial year check
                          if (postModel.prescriptionDate != '--Select Date--' &&
                              postModel.billDate != '--Select Date--') {
                            var dateTime1 =
                                DateFormat('d/M/y').parse(postModel.billDate);
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
                              if ((dateTime2.isAfter(dateTime1) ||
                                  dateTime2.isAtSameMomentAs(dateTime1))) {
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
                                postModel.attachFile = false;
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
                              postModel.attachFile = false;
                              postModel.notifyListeners();
                            });
                          }
                          setState(() {});
                        },
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${postModel.prescriptionDate}",textScaleFactor: MediaQuery.of(context).textScaleFactor,),
                            ))),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: Text('Amount Claimed',textScaleFactor: MediaQuery.of(context).textScaleFactor ,style: textStyle14Bold)),
                Expanded(
                  child: Container(
                    // height: 45,
                    child: TextFormField(
                      focusNode: postModel.focusNodeamount,
                      minLines: 1,
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      controller: postModel.amountController,
                      toolbarOptions: const ToolbarOptions(
                        copy: false,
                        cut: false,
                        paste: false,
                        selectAll: false,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (_desc) =>
                          _desc!.isEmpty ? "Kindly Enter Claimed Amount" : null,
                      decoration: InputDecoration(
                        labelText: "Enter Claimed Amount",
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

                    // TextField(
                    //   controller: postModel.amountController,
                    //   keyboardType: TextInputType.number,
                    //   decoration: const InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     hintText: 'Enter Claimed Amount',
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
                Expanded(child: Text('Remarks',textScaleFactor: MediaQuery.of(context).textScaleFactor, style: textStyle14Bold)),
                Expanded(
                  child: Container(
                    // height: 45,
                    child: TextFormField(
                      focusNode: postModel.focusNoderemarks,
                      minLines: 1,
                      maxLines: null,
                      autocorrect: false,
                      keyboardType: TextInputType.multiline,
                      controller: postModel.remarksController,
                      toolbarOptions: const ToolbarOptions(
                        copy: false,
                        cut: false,
                        paste: false,
                        selectAll: false,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (_desc) =>
                          _desc!.isEmpty ? "Kindly Enter Remarks" : null,
                      decoration: InputDecoration(
                        // errorBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(10.0),
                        //   // ignore: prefer_const_constructors
                        //   borderSide: BorderSide(
                        //     color: Colors.red,
                        //     width: 2.0,
                        //   ),
                        // ),
                        labelText: "Enter Remarks",
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

                    // TextField(
                    //   controller: postModel.remarksController,
                    //   decoration: const InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     hintText: 'Enter Remarks',
                    //   ),
                    // ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: postModel.attachFile,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    '* Please attach approval from concerned authority for late claim submission',
  
                    style: textStyle14Bold,
                  )),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
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
              : SizedBox(
                  child: postModel.fileboolDoc == false
                      ? Image.file(
                          postModel.capturedImageDoc!,
                          width: MediaQuery.of(context).size.width * .8,
                        )
                      : Column(
                          children: [
                            Text(
                              postModel.attachedAppDoc,
            
                              style: textStyle14Bold,
                            ),
                            const Icon(Icons.file_copy),
                          ],
                        ),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  'Attach File',

                  style: textStyle14Bold,
                )),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      showDialogBox(postModel, context);
                    },
                    child: Container(
                      height: 40,
                      width: 300,
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)), // Set rounded corner radius// Make rounded corner of border
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
              : SizedBox(
                  child: postModel.filebool == false
                      ? Image.file(
                          postModel.capturedImage!,
                          width: MediaQuery.of(context).size.width * .8,
                        )
                      : Column(
                          children: [
                            Text(
                              postModel.attachedDoc,
            
                              style: textStyle14Bold,
                            ),
                            const Icon(Icons.file_copy),
                          ],
                        ),
                )
        ],
      ),
    );
  }

  Widget TestopdWidget(ClaimTypeProvider postModel) {
    var homeProvider = Provider.of<HomeProvider>(context);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PatientBottomSheetWidget(
              content: "--Select Patient Name--",
              heading: "Patient Name",
              claimtype: postModel.patientList,
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
                    // height: 45,
                    child: TextFormField(
                      focusNode: postModel.focusNode,
                      minLines: 1,
                      maxLines: null,
                      autocorrect: false,
                      keyboardType: TextInputType.multiline,
                      controller: postModel.billNoController,
                      toolbarOptions: const ToolbarOptions(
                        copy: false,
                        cut: false,
                        paste: false,
                        selectAll: false,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9 ]')),
                        // FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),

                        // FilteringTextInputFormatter.allow(RexExp(r' [a-zA-Z 0-9]'))
                        // FilteringTextInputFormatter.deny(
                        //     RegExp(r'[!@#$%^&*(),.?":{}|<>]'))
                      ],
                      textCapitalization: TextCapitalization.sentences,
                      validator: (_desc) =>
                          _desc!.isEmpty ? "Kindly Enter Bill No." : null,
                      decoration: InputDecoration(
                        // errorBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(10.0),
                        //   // ignore: prefer_const_constructors
                        //   borderSide: BorderSide(
                        //     color: Colors.red,
                        //     width: 2.0,
                        //   ),
                        // ),
                        labelText: "Enter Bill No.",
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
                    // TextField(
                    //   controller: postModel.billNoController,
                    //   decoration: const InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     hintText: 'Enter Bill No.',
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
                          if (postModel.fin_year == '') {
                            postModel.fin_year = homeProvider.fin_year;
                          }
                          var parts = postModel.fin_year.split('-');
                          var prefix = parts[0].trim();

                          String fromApril = "01/04/${prefix}";
                          String toSeptember = "30/09/${prefix}";
                          String toDecemberM = "31/12/${prefix}";
                          var suffix = parts[1].trim();
                          String fromOct = "01/10/${prefix}";
                          String fromMarch = "31/03/${suffix}";
                          String toJune = "30/06/$suffix";

                          postModel.billDate = await admissionDate(context);

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
                          if (postModel.billDate != '--Select Date--') {
                            DateTime d = DateFormat("dd/MM/yyyy")
                                .parse(postModel.billDate);
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
                                  postModel.attachFile = false;
                                } else {
                                  postModel.attachFile = true;
                                }
                              } else {
                                if (d.isAfter(fromO) &&
                                    d.isBefore(fromM) &&
                                    DateTime.now().isBefore(toJuneM)) {
                                  postModel.attachFile = false;
                                } else {
                                  postModel.attachFile = true;
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
                                postModel.billDate = "--Select Date--";
                                postModel.attachFile = false;
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
                              child: Text("${postModel.billDate}",textScaleFactor: MediaQuery.of(context).textScaleFactor,),
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
                    // height: 45,
                    child: TextFormField(
                      // focusNode: postModel.focusNode,
                      minLines: 1,
                      maxLines: null,
                      autocorrect: false,
                      keyboardType: TextInputType.multiline,
                      controller: postModel.nameOflabController,
                      toolbarOptions: const ToolbarOptions(
                        copy: false,
                        cut: false,
                        paste: false,
                        selectAll: false,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (_desc) =>
                          _desc!.isEmpty ? "Kindly Enter Name Of Lab" : null,
                      decoration: InputDecoration(
                        // errorBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(10.0),
                        //   // ignore: prefer_const_constructors
                        //   borderSide: BorderSide(
                        //     color: Colors.red,
                        //     width: 2.0,
                        //   ),
                        // ),
                        labelText: "Enter Name Of Lab",
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

                    // TextField(
                    //   controller: postModel.nameOflabController,
                    //   decoration: const InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     hintText: 'Enter Name Of Lab',
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
                  'Particulars of Test',

                  style: textStyle14Bold,
                )),
                Expanded(
                  child: Container(
                    // height: 45,
                    child: TextFormField(
                      // focusNode: postModel.focusNode,
                      minLines: 1,
                      maxLines: null,
                      autocorrect: false,
                      keyboardType: TextInputType.multiline,
                      controller: postModel.particularoftestController,
                      toolbarOptions: const ToolbarOptions(
                        copy: false,
                        cut: false,
                        paste: false,
                        selectAll: false,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (_desc) =>
                          _desc!.isEmpty ? "Kindly Enter Name Of Test" : null,
                      decoration: InputDecoration(
                        // errorBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(10.0),
                        //   // ignore: prefer_const_constructors
                        //   borderSide: BorderSide(
                        //     color: Colors.red,
                        //     width: 2.0,
                        //   ),
                        // ),
                        labelText: "Enter Name Of Test",
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

                    // TextField(
                    //   controller: postModel.particularoftestController,
                    //   decoration: const InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     hintText: 'Enter Name Of Test',
                    //   ),
                    // ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: BottomSheetWidget(
              content: "--Select Chronical/Normal--",
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
                    // height: 45,
                    child: TextFormField(
                      focusNode: postModel.focusNodeamount,
                      minLines: 1,
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                      controller: postModel.amountController,
                      toolbarOptions: const ToolbarOptions(
                        copy: false,
                        cut: false,
                        paste: false,
                        selectAll: false,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (_desc) =>
                          _desc!.isEmpty ? "Kindly Enter Amount" : null,
                      decoration: InputDecoration(
                        // errorBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(10.0),
                        //   // ignore: prefer_const_constructors
                        //   borderSide: BorderSide(
                        //     color: Colors.red,
                        //     width: 2.0,
                        //   ),
                        // ),
                        labelText: "Enter Claimed Amount",
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

                    // TextField(
                    //   controller: postModel.amountController,
                    //   keyboardType: TextInputType.number,
                    //   decoration: const InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     hintText: 'Enter Claimed Amount',
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
                  'Remarks',

                  style: textStyle14Bold,
                )),
                Expanded(
                  child: Container(
                    // height: 45,
                    child: TextFormField(
                      focusNode: postModel.focusNoderemarks,
                      minLines: 1,
                      maxLines: null,
                      autocorrect: false,
                      keyboardType: TextInputType.multiline,
                      controller: postModel.remarksController,
                      toolbarOptions: const ToolbarOptions(
                        copy: false,
                        cut: false,
                        paste: false,
                        selectAll: false,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (_desc) =>
                          _desc!.isEmpty ? "Kindly Enter Remarks" : null,
                      decoration: InputDecoration(
                        // errorBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(10.0),
                        //   // ignore: prefer_const_constructors
                        //   borderSide: BorderSide(
                        //     color: Colors.red,
                        //     width: 2.0,
                        //   ),
                        // ),
                        labelText: "Enter Remarks",
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

                    // TextField(
                    //   controller: postModel.remarksController,
                    //   decoration: const InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     hintText: 'Enter Remarks',
                    //   ),
                    // ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: postModel.attachFile,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    '* Please attach approval from concerned authority for late claim submission',
  
                    style: textStyle14Bold,
                  )),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
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
              : SizedBox(
                  child: postModel.fileboolDoc == false
                      ? Image.file(
                          postModel.capturedImageDoc!,
                          width: MediaQuery.of(context).size.width * .8,
                        )
                      : Column(
                          children: [
                            Text(
                              postModel.attachedAppDoc,
            
                              style: textStyle14Bold,
                            ),
                            const Icon(Icons.file_copy),
                          ],
                        ),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  'Attach File',

                  style: textStyle14Bold,
                )),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      showDialogBox(postModel, context);
                    },
                    child: Container(
                      height: 40,
                      width: 300,
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
              : SizedBox(
                  child: postModel.filebool == false
                      ? Image.file(
                          postModel.capturedImage!,
                          width: MediaQuery.of(context).size.width * .8,
                        )
                      : Column(
                          children: [
                            Text(
                              postModel.attachedDoc,
            
                              style: textStyle14Bold,
                            ),
                            const Icon(Icons.file_copy),
                          ],
                        ),
                )
        ],
      ),
    );
  }

  Future<String> consulationDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
        fromDate = selectedDate.toString();
      });
    return "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
        .toString();
  }

  Future<String> admissionDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
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

  Future<String> dischargeDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != discharge)
      setState(() {
        discharge = selected;
        fromDate = discharge.toString();
      });
    return "${discharge.day}/${discharge.month}/${discharge.year}".toString();
  }

  _selectPrescriptionDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
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
                    postModel.galleryImage();
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
                    postModel.captureImage();

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
                    postModel.chooseFiles(context);
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
                    postModel.galleryImageDoc();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 1, //                   <--- border width here
                        ),
                      ),
                      // height: 50,
                      child:  Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Select photo from gallery',textScaleFactor: MediaQuery.of(context).textScaleFactor,
                            style: TextStyle(fontSize: 13)),
                      )),
                ),
              ),
              // const Spacer(),
              Center(
                child: TextButton(
                  onPressed: () async {
                    Navigator.pop(context, 'OK');
                    postModel.captureImageDoc();

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
                    postModel.chooseFilesDoc(context);
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

  bool validationConsultation(ClaimTypeProvider postModel) {
    if (postModel.patientname == '') {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Select Patient', onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.consultationNumberController.text.isEmpty) {
      DialogUtils.showCustomDialog(context,
          title: "PRMS", description: 'Please Enter Consultation Number',
          onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.consultationDate == '--Select Date--') {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Enter Consultation Date', onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.physicianController.text.isEmpty) {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Enter Physician Name', onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.amountController.text.isEmpty) {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Enter Amount', onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.attachFile && postModel.base64StringDoc.isEmpty) {
      DialogUtils.showCustomDialog(context,
          title: "PRMS", description: 'Approval attachment is mandatory',
          onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else {
      return true;
    }
  }

  bool validationMedicine(ClaimTypeProvider postModel) {
    var dateTime1 = DateFormat('d/M/y').parse(postModel.billDate);
    var dateTime2 = DateFormat('d/M/y').parse(postModel.prescriptionDate);

    if (postModel.patientname == '') {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Select Patient', onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.billNoController.text.isEmpty) {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Enter Bill Number', onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.billDate == '--Select Date--') {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Enter Bill Date', onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.prescriptionDate == '--Select Date--') {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Enter Prescription Date', onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.amountController.text.isEmpty) {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Enter Amount', onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (dateTime2.isAfter(dateTime1)) {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Prescription date cannot be greater than bill date',
          onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.attachFile && postModel.base64StringDoc.isEmpty) {
      DialogUtils.showCustomDialog(context,
          title: "PRMS", description: 'Approval attachment is mandatory',
          onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else {
      return true;
    }
  }

  bool validationOthers(ClaimTypeProvider postModel) {
    var dateTime1 = DateFormat('d/M/y').parse(postModel.billDate);
    var dateTime2 = DateFormat('d/M/y').parse(postModel.prescriptionDate);
    if (postModel.patientname == '') {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Select Patient', onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.billNoController.text.isEmpty) {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Enter Bill Number', onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.billDate == '--Select Date--') {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Enter Bill Date', onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.prescriptionDate == '--Select Date--') {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Enter Prescription Date', onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.amountController.text.isEmpty) {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Enter Amount', onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (dateTime2.isAfter(dateTime1)) {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Prescription date cannot be greater than bill date',
          onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.attachFile && postModel.base64StringDoc.isEmpty) {
      DialogUtils.showCustomDialog(context,
          title: "PRMS", description: 'Approval attachment is mandatory',
          onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else {
      return true;
    }
  }

  bool validationTest(ClaimTypeProvider postModel) {
    if (postModel.patientname == '') {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Select Patient', onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.billNoController.text.isEmpty) {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Enter Bill Number', onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.billDate == '--Select Date--') {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Enter Bill Date', onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.nameOflabController.text.isEmpty) {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Enter Name Of Lab', onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.particularoftestController.text.isEmpty) {
      DialogUtils.showCustomDialog(context,
          title: "PRMS", description: 'Please Enter Particular Of Test',
          onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.amountController.text.isEmpty) {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Enter Amount', onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.attachFile && postModel.base64StringDoc.isEmpty) {
      DialogUtils.showCustomDialog(context,
          title: "PRMS", description: 'Approval attachment is mandatory',
          onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else {
      return true;
    }
  }

  bool validationHospitalization(ClaimTypeProvider postModel) {
    var billdate = DateFormat('d/M/y').parse(postModel.billDate);
    var admsndate = DateFormat('d/M/y').parse(postModel.admissiondate);
    var dschrgedate = DateFormat('d/M/y').parse(postModel.dischargedate);
    if (postModel.patientname == '') {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Select Patient', onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.billNoController.text.isEmpty) {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Enter Bill Number', onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.admissiondate == '--Select Date--') {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Enter Admission Date', onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.dischargedate == '--Select Date--') {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Enter Discharge Date', onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.billDate == '--Select Date--') {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Enter Bill Date', onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.amountController.text.isEmpty) {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Enter Amount', onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.valuefirst == false) {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description: 'Please Check Prior/Post-Facto Permission Obtained',
          onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (admsndate.isAfter(billdate) || admsndate.isAfter(dschrgedate)) {
      DialogUtils.showCustomDialog(context,
          title: "PRMS",
          description:
              'Admission date either should be equal or smaller than bill  & Discharge date',
          onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else if (postModel.attachFile && postModel.base64StringDoc.isEmpty) {
      DialogUtils.showCustomDialog(context,
          title: "PRMS", description: 'Approval attachment is mandatory',
          onpositivePressed: () {
        Navigator.pop(context);
      });
      return false;
    } else {
      return true;
    }
  }
}


import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prms/Model/claim_type_model.dart';
import 'package:prms/Model/other_claim_model.dart';
import 'package:prms/Model/system_of_medicine_model.dart';
import 'package:prms/Rest/api_services.dart';
 

import '../Widget/alert_dialog.dart';


class ClaimTypeProvider extends ChangeNotifier{
  TextEditingController consultationNumberController = TextEditingController();
  TextEditingController physicianController = TextEditingController();
  TextEditingController billNoController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  TextEditingController nameOflabController = TextEditingController();
  TextEditingController particularoftestController = TextEditingController();
  TextEditingController illnesstController = TextEditingController();
  HomeModel? homeModel;
  SystemMedicineModel? systemMedicineModel;
  final focusNode = FocusNode();
  final focusNodeamount = FocusNode();
  final focusNoderemarks = FocusNode();
  // final focusNode = FocusNode();
  // final focusNode = FocusNode();

  // ClaimTypeModel? claimtypemodel;
  List<ClaimTypeModel>? claimtypemodel = [];
  List<ClaimTypeModel>? patientList = [];
  List<ClaimTypeModel>? chronicaldata = [];
  List<SystemOfMedicine>? systemofmedicineList = [];
  List<SystemOfMedicine>? traetmenttypeList = [];
  List<SystemOfMedicine>? domiciliaryDataList = [];
  List<SystemOfMedicine>? criticalIllnessDataList = [];
  List<String> financialYearDataList = [];
  ClaimOtherModel? claimOtherModel;
  OPDDetailModel? opdDetailModel;
  List<OtherClaimModel> otherclaimmodellist = [];
  String claimtype = '',patientname= '',billDate = '--Select date--',prescriptionDate='--Select date--',chronical = '',systemofmedicine = '',consultationDate='--Select date--',
  claimtypeother = '',treatment = '',admissiondate='--Select date--',dischargedate='--Select date--',domiciliary='',critical = '';
  bool domiciliaryvisibility = false;
  // XFile? capturedImage;
  File? capturedImage;
  String base64String= '';
  String filetype='';
  String fin_year = '';
  bool? filebool = false;
  bool valuefirst = false;
  File? capturedImageDoc;
  String base64StringDoc= '';
  String filetypeDoc='';
  bool? fileboolDoc = false;
  int approvalTaken = 0;

  String attachedDoc = "";
  String attachedAppDoc = "";

  String existingImage = "";
  String existingImageDoc = "";
  String updatedAttachedDoc ='';
  String updatedAttachedAppDoc = '';

  bool financialYearSelect = false;

  bool attachFile = false;
  String blockYearSelected = "";

  ApiService apiService = ApiService();


  getClaimData(String? opdClaim) async{
    claimtypemodel!.clear();
    homeModel = await apiService.getAll(opdClaim);
    claimtypemodel = homeModel?.data;
    notifyListeners();

  }
  getPatientNameData()async{
    homeModel = await apiService.getPatientName();
    patientList = homeModel?.data;
    notifyListeners();
  }

  getSystemMedicineData()async{
    systemMedicineModel = await apiService.getSystemMedicine();
    systemofmedicineList = systemMedicineModel?.data;
    notifyListeners();
  }
  getChronicalData()async{
    homeModel = await apiService.getChronicalNormal();
    chronicaldata = homeModel?.data;
    notifyListeners();
  }
  getkGetOtherClaim()async{
    claimOtherModel = await apiService.getkGetOtherClaimlist();
    otherclaimmodellist = claimOtherModel!.data!;
    notifyListeners();
  }
  getTreatmenttypeData()async{
    systemMedicineModel = await apiService.gettreatementType();
    traetmenttypeList = systemMedicineModel?.data;
    notifyListeners();
  }
  getDomiciliaryData()async{
    systemMedicineModel = await apiService.getDomiciliaryAPi();
    domiciliaryDataList = systemMedicineModel?.data;
    notifyListeners();
  }
  getCriticalIllnessData()async{
    systemMedicineModel = await apiService.getGetCriticalApi();
    criticalIllnessDataList = systemMedicineModel?.data;
    notifyListeners();
  }
  getFinancialYear() async{
    var response = await apiService.getFinancialYearApi();
    financialYearDataList = response;
    notifyListeners();
  }

  getDataDetailOnDD(String year) async{
    var response = await apiService.getDataDetailOnDDApi(year);

    opdDetailModel = response;
    if(opdDetailModel?.StatusCode == 200){
      financialYearSelect = true;
    }
    print("response getDataDetailOnDD:: ${opdDetailModel?.opd}  $fin_year");
    notifyListeners();
  }

  getDataToList(BuildContext context)async{

    var response = await apiService.getAddtoList(context,claimtype,patientname,consultationNumberController.text,consultationDate,systemofmedicine,physicianController.text,chronical,amountController.text,remarksController.text,base64String,billNoController.text,
    dischargedate,admissiondate,domiciliary,critical,illnesstController.text,claimtypeother,treatment,filetype,billDate,prescriptionDate,nameOflabController.text,particularoftestController.text,fin_year,base64StringDoc,filetypeDoc,approvalTaken.toString(),blockYearSelected);

    patientname = '';
    consultationNumberController.clear();
    consultationDate = "--Select Date--";
    physicianController.clear();
    amountController.clear();
    remarksController.clear();
    billNoController.clear();
    billDate = "--Select Date--";
    prescriptionDate = "--Select Date--";
    admissiondate = "--Select Date--";
    dischargedate = "--Select Date--";
    illnesstController.clear();
    nameOflabController.clear();
    particularoftestController.clear();
    base64String='';
    capturedImage = null;
    fin_year = '';
    base64StringDoc='';
    capturedImageDoc = null;
    filetype='';
    filetypeDoc = '';
    existingImage = "";
     existingImageDoc = "";
     attachedDoc ='';
     attachedAppDoc = '';

    // if(result['status_code'] == 200){
    //
    //   amountController.clear();
    //   remarksController.clear();
    // }

    notifyListeners();

  }


  captureImage() async {
    try {

      final ImagePicker _imagePicker = ImagePicker();

      final XFile? photo = await _imagePicker.pickImage(source: ImageSource.camera);
      capturedImage = File(photo!.path);
      capturedImage = await getCompressedBase64(photo!);

      if(capturedImage == '' || capturedImage == null ){
        filetype = '';
      }else{
        filetype = 'image';
      }
      //
      // if(existingImage.isNotEmpty){
      //   filetype = 'image';
      // }
      final bytes = capturedImage!.readAsBytesSync();
      base64String = base64.encode(bytes);
      filebool = false;
      notifyListeners();

    } catch (e, s) {

    }
  }
  galleryImage() async {
    try {
      final ImagePicker _imagePicker = ImagePicker();
      final XFile? photo = await _imagePicker.pickImage(source: ImageSource.gallery);
      print("capturedImage before:: $existingImage");
      capturedImage = File(photo!.path);

      capturedImage = await getCompressedBase64(photo!);


      if(capturedImage == '' || capturedImage == null){
        filetype = '';
      }else{
        filetype = 'image';
      }


      final bytes = capturedImage!.readAsBytesSync();

     base64String = base64.encode(bytes);
      filebool = false;

      notifyListeners();
    } catch (e, s) {
    }
  }
  chooseFiles(BuildContext context) async {
    try {
      final FilePickerResult? _result = await FilePicker.platform.pickFiles(
        // type: FileType.image,
        allowMultiple: true,
        // allowedExtensions: ['jpg', 'jpeg', 'pdf'],
      );

      print("_result :: ${_result!.files[0].name}");

      _result!.files[0].name.substring(_result!.files[0].name.length - 3);
      var nameFile =_result!.files[0].name.substring(_result!.files[0].name.length - 3);

      if (_result != null && nameFile == 'pdf') {
        final bytes = File(_result.files[0].path!).readAsBytesSync();
        base64String = base64.encode(bytes);
        filetype = nameFile;
        filebool = true;
        capturedImage = File('assets/images/gaillogo.png');
        attachedDoc = _result!.files[0].name;
      }
      notifyListeners();
    } catch (e, s) {

    }
  }
  captureImageDoc() async {
    try {

      final ImagePicker _imagePicker = ImagePicker();

      final XFile? photo = await _imagePicker.pickImage(source: ImageSource.camera);
      capturedImageDoc = File(photo!.path);
      capturedImageDoc = await getCompressedBase64(photo!);
      if(capturedImageDoc == '' || capturedImageDoc == null){
        filetypeDoc = '';
      }else{
        filetypeDoc = 'image';
      }

      final bytes = File(photo.path).readAsBytesSync();
      base64StringDoc = base64.encode(bytes);
      fileboolDoc = false;
      approvalTaken = 1;
      notifyListeners();

    } catch (e, s) {

    }
  }
  galleryImageDoc() async {
    try {
      final ImagePicker _imagePicker = ImagePicker();
      final XFile? photo = await _imagePicker.pickImage(source: ImageSource.gallery);

      // compressFile(photo!.path);
      capturedImageDoc = File(photo!.path);
      capturedImageDoc = await getCompressedBase64(photo!);
      if(capturedImageDoc == '' || capturedImageDoc == null){
        filetypeDoc = '';
      }else{
        filetypeDoc = 'image';
      }

      final bytes = capturedImageDoc!.readAsBytesSync();

      base64StringDoc = base64.encode(bytes);
      fileboolDoc = false;
      approvalTaken = 1;
      notifyListeners();
    } catch (e, s) {
    }
  }
  chooseFilesDoc(BuildContext context) async {
    try {
      final FilePickerResult? _result = await FilePicker.platform.pickFiles(
        // type: FileType.image,
        allowMultiple: true,
        // allowedExtensions: ['jpg', 'jpeg', 'pdf'],
      );
      _result!.files[0].name.substring(_result!.files[0].name.length - 3);
      var nameFile =_result!.files[0].name.substring(_result!.files[0].name.length - 3);
      print("nameFile :: $nameFile");
      if (_result != null && nameFile == 'pdf') {
        final bytes = File(_result.files[0].path!).readAsBytesSync();
        base64StringDoc = base64.encode(bytes);
        filetypeDoc = nameFile;
        fileboolDoc = true;
        capturedImageDoc = File('assets/images/gaillogo.png');
        attachedAppDoc = _result!.files[0].name;
      }
      approvalTaken = 1;
      notifyListeners();
    } catch (e, s) {
      // handleException(
      //   exception: e,
      //   stackTrace: s,
      //   exceptionClass: _tag,
      //   exceptionMsg: 'exception while choosing files',
      // );
    }
  }

  getDataUpdate(BuildContext context, String claimid, String claimType, String patientName, String treatmentval)async{
    if(patientname == ""){
      patientname = patientName;
    }

    if(treatment == ""){
      treatment = treatmentval;
    }

    var response = await apiService.getUpdateData(context,claimType,patientname,consultationNumberController.text,consultationDate,systemofmedicine,physicianController.text,chronical,amountController.text,remarksController.text,base64String,billNoController.text,
        dischargedate,admissiondate,domiciliary,critical,illnesstController.text,claimtypeother,treatment,claimid,filetype,prescriptionDate,billDate,base64StringDoc,filetypeDoc,approvalTaken.toString(),blockYearSelected);
    capturedImage = null;
    capturedImageDoc=null;
    filetype='';
    filetypeDoc = '';
    updatedAttachedDoc ='';
    updatedAttachedAppDoc = '';
    notifyListeners();

  }

  Future<File> getCompressedBase64(XFile? photo) async {
    final File file = File(photo!.path);

    final double fileSizeInKiloByte = file.lengthSync() / 1000;
    if (fileSizeInKiloByte > 500) {
      final double compress = (500 / fileSizeInKiloByte) * 100;
      final XFile? result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        "${file.path}com.jpg",
        minHeight: 640,
        minWidth: 1136,
        quality: (compress.toInt()),
      );
      final File comFile = File(result!.path);
      final double comLengthKB = comFile.lengthSync() / 1000;
      return File(result.path);
    } else {
      return file;
    }
  }

  //UPDATE IMAGES

  captureImageUpdate() async {
    try {

      final ImagePicker _imagePicker = ImagePicker();

      final XFile? photo = await _imagePicker.pickImage(source: ImageSource.camera);
      if(photo == null){
        capturedImage = null;
      }else{
        capturedImage = File(photo!.path);
        capturedImage = await getCompressedBase64(photo);
      }

      print("galleryImageUpdate :: $capturedImage  $existingImage");

      if(existingImage != ''){
        print("existingImage if condition::   $existingImage");
        if(capturedImage == '' || capturedImage == null){
          filetype = '';
          print("capturedImage existingImage is not null:: $filetype");
        }else{
          filetype = 'image';
        }
      }else{
        if(capturedImage == '' || capturedImage == null ){
          filetype = '';
          print("capturedImage existingImage is not null:: $filetype");
        }else{
          filetype = 'image';
        }

      }

      final bytes = capturedImage!.readAsBytesSync();
      base64String = base64.encode(bytes);
      filebool = false;
      notifyListeners();

    } catch (e, s) {

    }
  }
  galleryImageUpdate() async {
    try {
      print("galleryImageUpdate :: $capturedImage ");
      print("existingImage ::   $existingImage");
      final ImagePicker _imagePicker = ImagePicker();
      final XFile? photo = await _imagePicker.pickImage(source: ImageSource.gallery);
      if(photo == null){
        capturedImage = null;
      }else{
        capturedImage = File(photo!.path);
        capturedImage = await getCompressedBase64(photo);
      }

      print("galleryImageUpdate :: $capturedImage  $existingImage");

      if(existingImage != ''){
        print("existingImage if condition::   $existingImage");
        if(capturedImage == '' || capturedImage == null){
          filetype = '';
          print("capturedImage existingImage is not null:: $filetype");
        }else{
          filetype = 'image';
        }
      }else{
        if(capturedImage == '' || capturedImage == null ){
          filetype = '';
          print("capturedImage existingImage is not null:: $filetype");
        }else{
          filetype = 'image';
        }

      }

      final bytes = capturedImage!.readAsBytesSync();

      base64String = base64.encode(bytes);
      filebool = false;

      notifyListeners();
    } catch (e, s) {
    }
  }
  chooseFilesUpdate(BuildContext context) async {
    try {
      print("existingPDF ::   $existingImage");
      final FilePickerResult? _result = await FilePicker.platform.pickFiles(
        // type: FileType.image,
        allowMultiple: true,
        // allowedExtensions: ['jpg', 'jpeg', 'pdf'],
      );


      var nameFile = '';
      if(_result != null){
        print("_result null :: ${_result}");
        print("_result null :: ${_result!.files[0].name}");
        _result!.files[0].name.substring(_result!.files[0].name.length - 3);
         nameFile =_result!.files[0].name.substring(_result!.files[0].name.length - 3);
        if(existingImage != ''){
          print("capturedImage existingImage is not null:: $filetype");

          if (nameFile == 'pdf') {
            final bytes = File(_result.files[0].path!).readAsBytesSync();
            base64String = base64.encode(bytes);
            filetype = nameFile;
            filebool = true;
            capturedImage = File('assets/images/gaillogo.png');
            updatedAttachedDoc = _result!.files[0].name;
            print("capturedImage existingImage is not null if:: $filetype");
          }else{
            filetype = 'pdf';
            updatedAttachedDoc = existingImage;
            print("capturedImage existingImage is not null else:: $filetype");
          }
        }else{
          print("capturedImage existingImage is null else:: $filetype");
          if (nameFile == 'pdf') {
            final bytes = File(_result.files[0].path!).readAsBytesSync();
            base64String = base64.encode(bytes);
            filetype = nameFile;
            filebool = true;
            capturedImage = File('assets/images/gaillogo.png');
            updatedAttachedDoc = _result!.files[0].name;
          }

        }
      }else{
        nameFile = '';
        print("_result :: ${_result}");

        if(existingImage != ''){
          print("capturedImage existingImage is not null===:: $filetype");
            filetype = 'pdf';
            updatedAttachedDoc = existingImage;
        }else{
          print("capturedImage existingImage is null else:: $filetype");
          filetype = '';

        }
      }






      notifyListeners();
    } catch (e, s) {

    }
  }
  captureImageDocUpdate() async {
    try {

      final ImagePicker _imagePicker = ImagePicker();

      final XFile? photo = await _imagePicker.pickImage(source: ImageSource.camera);
      // capturedImageDoc = File(photo!.path);
      // capturedImageDoc = await getCompressedBase64(photo!);
      // if(capturedImageDoc == '' || capturedImageDoc == null){
      //   filetypeDoc = '';
      // }else{
      //   filetypeDoc = 'image';
      // }

      if(photo == null){
        capturedImageDoc = null;
      }else{
        capturedImageDoc = File(photo!.path);
        capturedImageDoc = await getCompressedBase64(photo);
      }

      print("galleryImageUpdate :: $capturedImageDoc  $existingImage");

      if(existingImage != ''){
        print("existingImage if condition::   $existingImage");
        if(capturedImageDoc == '' ){
          filetypeDoc = '';
          print("capturedImage existingImage is not null:: $filetypeDoc");
        }else{
          filetypeDoc = 'image';
        }
      }else{
        if(capturedImageDoc == '' ){
          filetypeDoc = '';
          print("capturedImage existingImage is not null:: $filetypeDoc");
        }else{
          filetypeDoc = 'image';
        }

      }

      final bytes = capturedImageDoc!.readAsBytesSync();
      base64StringDoc = base64.encode(bytes);
      fileboolDoc = false;
      approvalTaken = 1;
      notifyListeners();

    } catch (e, s) {

    }
  }
  galleryImageDocUpdate() async {
    try {
      final ImagePicker _imagePicker = ImagePicker();
      final XFile? photo = await _imagePicker.pickImage(source: ImageSource.gallery);

      // compressFile(photo!.path);
      if(photo == null){
        capturedImageDoc = null;
      }else{
        capturedImageDoc = File(photo!.path);
        capturedImageDoc = await getCompressedBase64(photo);
      }

      print("galleryImageUpdate :: $capturedImageDoc  $existingImage");

      if(existingImage != ''){
        print("existingImage if condition::   $existingImage");
        if(capturedImageDoc == '' ){
          filetypeDoc = '';
          print("capturedImage existingImage is not null:: $filetypeDoc");
        }else{
          filetypeDoc = 'image';
        }
      }else{
        if(capturedImageDoc == '' ){
          filetypeDoc = '';
          print("capturedImage existingImage is not null:: $filetypeDoc");
        }else{
          filetypeDoc = 'image';
        }

      }
      final bytes = capturedImageDoc!.readAsBytesSync();

      base64StringDoc = base64.encode(bytes);
      fileboolDoc = false;
      approvalTaken = 1;
      notifyListeners();
    } catch (e, s) {
    }
  }
  chooseFilesDocUpdate(BuildContext context) async {
    try {
      final FilePickerResult? _result = await FilePicker.platform.pickFiles(
        // type: FileType.image,
        allowMultiple: true,
        // allowedExtensions: ['jpg', 'jpeg', 'pdf'],
      );
      var nameFile = '';
      if(_result != null){
        print("_result null :: ${_result}");
        print("_result null :: ${_result!.files[0].name}");
        _result!.files[0].name.substring(_result!.files[0].name.length - 3);
        nameFile =_result!.files[0].name.substring(_result!.files[0].name.length - 3);
        if(existingImage != ''){
          print("capturedImage existingImage is not null:: $filetype");

          if (nameFile == 'pdf') {
            final bytes = File(_result.files[0].path!).readAsBytesSync();
            base64String = base64.encode(bytes);
            filetype = nameFile;
            filebool = true;
            capturedImage = File('assets/images/gaillogo.png');
            updatedAttachedAppDoc = _result!.files[0].name;
            print("capturedImage existingImage is not null if:: $filetype");
          }else{
            filetype = 'pdf';
            updatedAttachedAppDoc = existingImage;
            print("capturedImage existingImage is not null else:: $filetype");
          }
        }else{
          print("capturedImage existingImage is null else:: $filetype");
          if (nameFile == 'pdf') {
            final bytes = File(_result.files[0].path!).readAsBytesSync();
            base64String = base64.encode(bytes);
            filetype = nameFile;
            filebool = true;
            capturedImage = File('assets/images/gaillogo.png');
            updatedAttachedAppDoc = _result!.files[0].name;
          }

        }
      }else{
        nameFile = '';
        print("_result :: ${_result}");

        if(existingImage != ''){
          print("capturedImage existingImage is not null===:: $filetype");
          filetype = 'pdf';
          updatedAttachedAppDoc = existingImage;

        }else{
          print("capturedImage existingImage is null else:: $filetype");
          filetype = '';

        }
      }

      approvalTaken = 1;
      notifyListeners();
    } catch (e, s) {
      // handleException(
      //   exception: e,
      //   stackTrace: s,
      //   exceptionClass: _tag,
      //   exceptionMsg: 'exception while choosing files',
      // );
    }
  }


}
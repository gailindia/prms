// To parse this JSON data, do
//
//     final claimDraftModel = claimDraftModelFromJson(jsonString);

import 'dart:convert';

ClaimReqDetailsModel ClaimReqDetailsModelFromJson(String str) => ClaimReqDetailsModel.fromJson(json.decode(str));

String ClaimReqDetailsModelToJson(ClaimReqDetailsModel data) => json.encode(data.toJson());

class ClaimReqDetailsModel {
  List<Datum> data;
  int statusCode;
  String empCpf;
  String empName;
  String grade;
  String location;
  String vendorCode;
  String vendorMobile;
  String vendorPhone;

  ClaimReqDetailsModel({
    required this.data,
    required this.statusCode,
    required this.empCpf,
    required this.empName,
    required this.grade,
    required this.location,
    required this.vendorCode,
    required this.vendorMobile,
    required this.vendorPhone,
  });

  factory ClaimReqDetailsModel.fromJson(Map<String, dynamic> json) => ClaimReqDetailsModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    statusCode: json["status_code"],
    empCpf: json["EMP_CPF"],
    empName: json["EMP_NAME"],
    grade: json["GRADE"],
    location: json["LOCATION"],
    vendorCode: json["VENDOR_CODE"],
    vendorMobile: json["VENDOR_MOBILE"],
    vendorPhone: json["VENDOR_PHONE"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "status_code": statusCode,
    "EMP_CPF": empCpf,
    "EMP_NAME": empName,
    "GRADE": grade,
    "LOCATION": location,
    "VENDOR_CODE": vendorCode,
    "VENDOR_MOBILE": vendorMobile,
    "VENDOR_PHONE": vendorPhone,
  };
}

class Datum {
  dynamic remarks;
  dynamic chkprior;
  double requestNo;
  String cpfNo;
  String vendorCode;
  String claimType;
  String documentNo;
  String documentDate;
  String patientName;
  double amountClaimed;
  dynamic diseaseSeverity;
  String? medicineSystem;
  String? physicianName;
  String? prescriptionDate;
  dynamic labName;
  dynamic testParticulars;
  dynamic admissionDate;
  dynamic dischargeDate;
  dynamic treatmentType;
  dynamic domiciliaryTreatment;
  String uploadedDocument;
  dynamic criticalIllness;
  String createdOn;
  dynamic illnessType;
  dynamic claimTypeOther;
  dynamic illnessDetail;
  dynamic dentalNormal;

  Datum({
    required this.remarks,
    required this.chkprior,
    required this.requestNo,
    required this.cpfNo,
    required this.vendorCode,
    required this.claimType,
    required this.documentNo,
    required this.documentDate,
    required this.patientName,
    required this.amountClaimed,
    required this.diseaseSeverity,
    required this.medicineSystem,
    required this.physicianName,
    required this.prescriptionDate,
    required this.labName,
    required this.testParticulars,
    required this.admissionDate,
    required this.dischargeDate,
    required this.treatmentType,
    required this.domiciliaryTreatment,
    required this.uploadedDocument,
    required this.criticalIllness,
    required this.createdOn,
    required this.illnessType,
    required this.claimTypeOther,
    required this.illnessDetail,
    required this.dentalNormal,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    remarks: json["REMARKS"],
    chkprior: json["CHKPRIOR"],
    requestNo: json["REQUEST_NO"],
    cpfNo: json["CPF_NO"],
    vendorCode: json["VENDOR_CODE"]??'',
    claimType: json["CLAIM_TYPE"],
    documentNo: json["DOCUMENT_NO"],
    documentDate: json["DOCUMENT_DATE"],
    patientName: json["PATIENT_NAME"],
    amountClaimed: json["AMOUNT_CLAIMED"],
    diseaseSeverity: json["DISEASE_SEVERITY"],
    medicineSystem: json["MEDICINE_SYSTEM"],
    physicianName: json["PHYSICIAN_NAME"],
    prescriptionDate: json["PRESCRIPTION_DATE"],
    labName: json["LAB_NAME"],
    testParticulars: json["TEST_PARTICULARS"],
    admissionDate: json["ADMISSION_DATE"],
    dischargeDate: json["DISCHARGE_DATE"],
    treatmentType: json["TREATMENT_TYPE"],
    domiciliaryTreatment: json["DOMICILIARY_TREATMENT"],
    uploadedDocument: json["UPLOADED_DOCUMENT"]??'',
    criticalIllness: json["CRITICAL_ILLNESS"],
    createdOn: json["CREATED_ON"],
    illnessType: json["ILLNESS_TYPE"],
    claimTypeOther: json["CLAIM_TYPE_OTHER"],
    illnessDetail: json["ILLNESS_DETAIL"],
    dentalNormal: json["DENTAL_NORMAL"],
  );

  Map<String, dynamic> toJson() => {
    "REMARKS": remarks,
    "CHKPRIOR": chkprior,
    "REQUEST_NO": requestNo,
    "CPF_NO": cpfNo,
    "VENDOR_CODE": vendorCode,
    "CLAIM_TYPE": claimType,
    "DOCUMENT_NO": documentNo,
    "DOCUMENT_DATE": documentDate,
    "PATIENT_NAME": patientName,
    "AMOUNT_CLAIMED": amountClaimed,
    "DISEASE_SEVERITY": diseaseSeverity,
    "MEDICINE_SYSTEM": medicineSystem,
    "PHYSICIAN_NAME": physicianName,
    "PRESCRIPTION_DATE": prescriptionDate,
    "LAB_NAME": labName,
    "TEST_PARTICULARS": testParticulars,
    "ADMISSION_DATE": admissionDate,
    "DISCHARGE_DATE": dischargeDate,
    "TREATMENT_TYPE": treatmentType,
    "DOMICILIARY_TREATMENT": domiciliaryTreatment,
    "UPLOADED_DOCUMENT": uploadedDocument,
    "CRITICAL_ILLNESS": criticalIllness,
    "CREATED_ON": createdOn,
    "ILLNESS_TYPE": illnessType,
    "CLAIM_TYPE_OTHER": claimTypeOther,
    "ILLNESS_DETAIL": illnessDetail,
    "DENTAL_NORMAL": dentalNormal,
  };
}

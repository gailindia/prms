// To parse this JSON data, do
//
//     final claimDraftModel = claimDraftModelFromJson(jsonString);

import 'dart:convert';

ClaimDraftModel claimDraftModelFromJson(String str) => ClaimDraftModel.fromJson(json.decode(str));

String claimDraftModelToJson(ClaimDraftModel data) => json.encode(data.toJson());

class ClaimDraftModel {
  Data data;
  int statusCode;

  ClaimDraftModel({
    required this.data,
    required this.statusCode,
  });

  factory ClaimDraftModel.fromJson(Map<String, dynamic> json) => ClaimDraftModel(
    data: Data.fromJson(json["data"]),
    statusCode: json["status_code"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "status_code": statusCode,
  };
}

class Data {
  List<ClaimDatum> claimData;

  Data({
    required this.claimData,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    claimData: List<ClaimDatum>.from(json["ClaimData"].map((x) => ClaimDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ClaimData": List<dynamic>.from(claimData.map((x) => x.toJson())),
  };
}

class ClaimDatum {
  String cid;
  String claimType;
  dynamic status;
  dynamic consulationNo;
  String totalamount;
  List<ClaimDataList> claimDataList;

  ClaimDatum({
    required this.cid,
    required this.claimType,
    required this.status,
    required this.consulationNo,
    required this.totalamount,
    required this.claimDataList,
  });

  factory ClaimDatum.fromJson(Map<String, dynamic> json) => ClaimDatum(
    cid: json["cid"],
    claimType: json["claimType"],
    status: json["status"],
    consulationNo: json["consulationNO"],
    totalamount: json["totalamount"],
    claimDataList: List<ClaimDataList>.from(json["claimDataList"].map((x) => ClaimDataList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "cid": cid,
    "claimType": claimType,
    "status": status,
    "consulationNO": consulationNo,
    "totalamount": totalamount,
    "claimDataList": List<dynamic>.from(claimDataList.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'ClaimDatum{cid: $cid, claimType: $claimType, status: $status, consulationNo: $consulationNo, totalamount: $totalamount, claimDataList: $claimDataList}';
  }
}

class ClaimDataList {
  dynamic requestNo;
  String userid;
  String claimType;
  String patientName;
  String consulationNo;
  String consulationDate;
  String vendorId;
  String claimOtherType;
  String amtClaimed;
  String medicineSystem;
  String physicianName;
  String illnessType;
  String remarks;
  String admDate;
  String dischrgDate;
  String treatmentType;
  String saveCriticalIllness;
  String illnessDetails;
  String domicilaryTreatment;
  String claimCheckprior;
  String dentalNormal;
  String prescriptionDate;
  String claimid;
  String img;
  String imgDoc;
  dynamic filetype;
  dynamic createdOn;
  String labName;
  String testParticulars;
  String majorclaim;
  String fin_year;

  ClaimDataList({
    required this.requestNo,
    required this.userid,
    required this.claimType,
    required this.patientName,
    required this.consulationNo,
    required this.consulationDate,
    required this.vendorId,
    required this.claimOtherType,
    required this.amtClaimed,
    required this.medicineSystem,
    required this.physicianName,
    required this.illnessType,
    required this.remarks,
    required this.admDate,
    required this.dischrgDate,
    required this.treatmentType,
    required this.saveCriticalIllness,
    required this.illnessDetails,
    required this.domicilaryTreatment,
    required this.claimCheckprior,
    required this.dentalNormal,
    required this.prescriptionDate,
    required this.claimid,
    required this.img,
    required this.imgDoc,
    required this.filetype,
    required this.createdOn,
    required this.labName,
    required this.testParticulars,
    required this.majorclaim,
    required this.fin_year,
  });

  factory ClaimDataList.fromJson(Map<String, dynamic> json) => ClaimDataList(
    requestNo: json["requestNo"],
    userid: json["userid"],
    claimType: json["claimType"],
    patientName: json["patientName"],
    consulationNo: json["consulationNo"],
    consulationDate: json["consulationDate"],
    vendorId: json["vendorId"],
    claimOtherType: json["claimOtherType"],
    amtClaimed: json["amtClaimed"],
    medicineSystem: json["medicineSystem"],
    physicianName: json["physicianName"],
    illnessType: json["illnessType"],
    remarks: json["remarks"],
    admDate: json["admDate"],
    dischrgDate: json["dischrgDate"],
    treatmentType: json["treatmentType"],
    saveCriticalIllness: json["saveCriticalIllness"],
    illnessDetails: json["illnessDetails"],
    domicilaryTreatment: json["domicilaryTreatment"],
    claimCheckprior: json["claimCheckprior"],
    dentalNormal: json["dentalNormal"],
    prescriptionDate: json["prescriptionDate"],
    claimid: json["claimid"],
    img: json["img"],
    imgDoc: json["imgDoc"],
    filetype: json["Filetype"],
    createdOn: json["CREATED_ON"],
    labName: json["labName"],
    testParticulars: json["testParticulars"],
    majorclaim: json["majorclaim"],
    fin_year: json["fin_year"],
  );

  Map<String, dynamic> toJson() => {
    "requestNo": requestNo,
    "userid": userid,
    "claimType": claimType,
    "patientName": patientName,
    "consulationNo": consulationNo,
    "consulationDate": consulationDate,
    "vendorId": vendorId,
    "claimOtherType": claimOtherType,
    "amtClaimed": amtClaimed,
    "medicineSystem": medicineSystem,
    "physicianName": physicianName,
    "illnessType": illnessType,
    "remarks": remarks,
    "admDate": admDate,
    "dischrgDate": dischrgDate,
    "treatmentType": treatmentType,
    "saveCriticalIllness": saveCriticalIllness,
    "illnessDetails": illnessDetails,
    "domicilaryTreatment": domicilaryTreatment,
    "claimCheckprior": claimCheckprior,
    "dentalNormal": dentalNormal,
    "prescriptionDate": prescriptionDate,
    "claimid": claimid,
    "img": img,
    "imgDoc": imgDoc,
    "Filetype": filetype,
    "CREATED_ON": createdOn,
    "labName": labName,
    "testParticulars": testParticulars,
    "majorclaim": majorclaim,
    "fin_year": fin_year,
  };

}

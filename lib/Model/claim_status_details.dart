import 'dart:convert';

ClaimDetailsModel ClaimDetailsModelFromJson(String str) => ClaimDetailsModel.fromJson(json.decode(str));

String ClaimDetailsModelToJson(ClaimDetailsModel data) => json.encode(data.toJson());

class ClaimDetailsModel {
  ClaimDetailsModel({
    // this.status_code,
    this.data,
  });

  // String? status_code;
  List<ClaimDetailsModelAPI>? data;

  factory ClaimDetailsModel.fromJson(Map<String, dynamic> json) => ClaimDetailsModel(
    // status_code: json["status_code"],
    data: List<ClaimDetailsModelAPI>.from(json["data"].map((x) => ClaimDetailsModelAPI.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    // "status_code":js
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}


class ClaimDetailsModelAPI {
  String? cpfno,vendorcode,empname,grade,designation,department,htype,entryDate;
  double? requestno;
  ClaimDetailsModelAPI({
    required this.cpfno,required this.department,required this.designation,required this.empname,required this.grade,required this.htype,required this.requestno,required this.vendorcode,
    required this.entryDate

  });
  factory ClaimDetailsModelAPI.fromJson(Map<String, dynamic> _claimstatusAJson) =>
      ClaimDetailsModelAPI(
        cpfno: _claimstatusAJson["CPF_NO"],
        vendorcode: _claimstatusAJson["VENDOR_CODE"],
        empname: _claimstatusAJson["EMP_NAME"],
        grade: _claimstatusAJson["GRADE"],
        designation: _claimstatusAJson["DESIGNATION"],
        department: _claimstatusAJson["DEPARTMENT"],
        htype: _claimstatusAJson["H_TYPE"],
        requestno: _claimstatusAJson["REQUEST_NO"],
        entryDate: _claimstatusAJson["ENTRY_DATE"],

      );

  // ClaimTypeModel.fromJson(Map<String, dynamic> json) {
  //   value = json['value'];
  //   text = json['text'];
  //
  // }
  //
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CPF_NO'] = this.cpfno;
    data['VENDOR_CODE'] = this.vendorcode;
    data['EMP_NAME'] = this.empname;
    data['GRADE'] = this.grade;
    data['DESIGNATION'] = this.designation;
    data['DEPARTMENT'] = this.department;
    data['H_TYPE'] = this.htype;
    data['REQUEST_NO'] = this.requestno;
    data['ENTRY_DATE'] = this.entryDate;

    return data;
  }

}

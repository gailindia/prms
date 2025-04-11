import 'dart:convert';

ClaimOtherModel ClaimOtherModelFromJson(String str) => ClaimOtherModel.fromJson(json.decode(str));

String ClaimOtherModelToJson(ClaimOtherModel data) => json.encode(data.toJson());

class ClaimOtherModel {
  ClaimOtherModel({
    // this.status_code,
    this.data,
  });

  // String? status_code;
  List<OtherClaimModel>? data;

  factory ClaimOtherModel.fromJson(Map<String, dynamic> json) => ClaimOtherModel(
    // status_code: json["status_code"],
    data: List<OtherClaimModel>.from(json["data"].map((x) => OtherClaimModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    // "status_code":js
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}



class OtherClaimModel {
  String? name;
  String? id;
  OtherClaimModel({
    required this.name,required this.id
  });

  factory OtherClaimModel.fromJson(Map<String, dynamic> _claimTypeAJson) =>
      OtherClaimModel(
        name: _claimTypeAJson["Name"],
        id: _claimTypeAJson["ID"],
      );

  // ClaimTypeModel.fromJson(Map<String, dynamic> json) {
  //   value = json['value'];
  //   text = json['text'];
  //
  // }
  //
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['ID'] = this.id;
    return data;
  }
}

OPDDetailModel OPDDetailModelFromJson(String str) => OPDDetailModel.fromJson(json.decode(str));

String OPDDetailModelToJson(OPDDetailModel data) => json.encode(data.toJson());
class OPDDetailModel {
  int? opd;
  int? hosp;
  int? specs;
  int? StatusCode;
  String? specs_Block_year;
  // String? hosp;
  OPDDetailModel({
    required this.opd,required this.hosp,required this.specs, required this.specs_Block_year,required this.StatusCode
  });

  factory OPDDetailModel.fromJson(Map<String, dynamic> _claimTypeAJson) =>
      OPDDetailModel(
        opd: _claimTypeAJson["opd"],
        hosp: _claimTypeAJson["hosp"],
        specs: _claimTypeAJson["specs"],
        StatusCode: _claimTypeAJson["StatusCode"],
        specs_Block_year: _claimTypeAJson["specs_Block_year"],
      );

  // ClaimTypeModel.fromJson(Map<String, dynamic> json) {
  //   value = json['value'];
  //   text = json['text'];
  //
  // }
  //
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['opd'] = this.opd;
    data['hosp'] = this.hosp;
    data['specs'] = this.specs;
    data['StatusCode'] = this.StatusCode;
    data['specs_Block_year'] = this.specs_Block_year;
    return data;
  }
}
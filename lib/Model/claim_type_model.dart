import 'dart:convert';

HomeModel HomeModelFromJson(String str) => HomeModel.fromJson(json.decode(str));

String HomeModelToJson(HomeModel data) => json.encode(data.toJson());

class HomeModel {
  HomeModel({
    // this.status_code,
    this.data,
  });

  // String? status_code;
  List<ClaimTypeModel>? data;

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
    // status_code: json["status_code"],
    data: List<ClaimTypeModel>.from(json["data"].map((x) => ClaimTypeModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    // "status_code":js
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}



class ClaimTypeModel {
  String? value;
  String? text;
  ClaimTypeModel({
    required this.value,required this.text
  });

  factory ClaimTypeModel.fromJson(Map<String, dynamic> _claimTypeAJson) =>
      ClaimTypeModel(
        value: _claimTypeAJson["Value"],
        text: _claimTypeAJson["Text"],
      );

  // ClaimTypeModel.fromJson(Map<String, dynamic> json) {
  //   value = json['value'];
  //   text = json['text'];
  //
  // }
  //
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Value'] = this.value;
    data['Text'] = this.text;

    return data;
  }
}




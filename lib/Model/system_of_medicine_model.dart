import 'dart:convert';

SystemMedicineModel SystemMedicineModelFromJson(String str) => SystemMedicineModel.fromJson(json.decode(str));

String SystemMedicineModelToJson(SystemMedicineModel data) => json.encode(data.toJson());

class SystemMedicineModel {
  SystemMedicineModel({
    // this.status_code,
    this.data,
  });

  // String? status_code;
  List<SystemOfMedicine>? data;

  factory SystemMedicineModel.fromJson(Map<String, dynamic> json) => SystemMedicineModel(
    // status_code: json["status_code"],
    data: List<SystemOfMedicine>.from(json["data"].map((x) => SystemOfMedicine.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    // "status_code":js
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}



class SystemOfMedicine {
  String? code;
  String? type;
  SystemOfMedicine({
    required this.code,required this.type
  });

  factory SystemOfMedicine.fromJson(Map<String, dynamic> _claimTypeAJson) =>
      SystemOfMedicine(
        code: _claimTypeAJson["CODE"],
        type: _claimTypeAJson["TYPE"],
      );

  // ClaimTypeModel.fromJson(Map<String, dynamic> json) {
  //   value = json['value'];
  //   text = json['text'];
  //
  // }
  //
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CODE'] = this.code;
    data['TYPE'] = this.type;
    return data;
  }
}

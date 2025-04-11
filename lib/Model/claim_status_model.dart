import 'dart:convert';

ClaimModel ClaimModelFromJson(String str) => ClaimModel.fromJson(json.decode(str));

String ClaimModelToJson(ClaimModel data) => json.encode(data.toJson());

class ClaimModel {
  ClaimModel({
    // this.status_code,
    this.data,
  });

  // String? status_code;
  List<ClaimStatusModel>? data;

  factory ClaimModel.fromJson(Map<String, dynamic> json) => ClaimModel(
    // status_code: json["status_code"],
    data: List<ClaimStatusModel>.from(json["data"].map((x) => ClaimStatusModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    // "status_code":js
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}



class ClaimStatusModel {
  String? EMP_NO,
      EMP_NAME,
      EMP_GRADE,
      VENDOR_CODE,
      CLAIM_REQ_NO_PORTAL,
      REQ_CREATION_DATE,
      REQ_TYPE,
      // CLAIM_NO_SAP,
      // CLAIM_CREATION_DATE,
      REQUEST_STATUS,
      CLAIM_STATUS,
      // HR_REMARK,
      // CLAIM_CREATED_BY_HR,
      F_AND_A_REMARK,
      CLAIM_APPROVED_BY_F_AND_A,
      // CLAIM_APPROVED_ON,
      // POSTINGDATE,
      // DOCUMENT_NUMBER,
      // COMPANY_CODE,
      REJECTEDBY,
      REJECTEDON,REJECTION_REASON,REJECTION_DEPARTMENT,ADDDATE,UPDATEDATE,ISACTIVE;
  double? ID,REQ_AMOUNT_TOTAL,AMMT_PASSED_BY_HR,AMT_PASSED_BY_F_AND_A;
  ClaimStatusModel({
    required this.EMP_NO,required this.ADDDATE, required this.AMMT_PASSED_BY_HR,required this.AMT_PASSED_BY_F_AND_A,required this.CLAIM_APPROVED_BY_F_AND_A,
    // required this.CLAIM_APPROVED_ON,required this.CLAIM_CREATED_BY_HR,required this.CLAIM_CREATION_DATE,required this.CLAIM_NO_SAP,
    required this.CLAIM_REQ_NO_PORTAL,required this.CLAIM_STATUS,
    // required this.COMPANY_CODE,required this.DOCUMENT_NUMBER,
    required this.EMP_GRADE,required this.EMP_NAME,
    required this.F_AND_A_REMARK,
    // required this.HR_REMARK,
    required this.ID,required this.ISACTIVE,
    // required this.POSTINGDATE,
    required this.REJECTEDBY,required this.REJECTEDON,required this.REJECTION_DEPARTMENT,required this.REJECTION_REASON,required this.REQ_AMOUNT_TOTAL,required this.REQ_CREATION_DATE,required this.REQ_TYPE,required this.REQUEST_STATUS,required this.UPDATEDATE,required this.VENDOR_CODE
  });

  factory ClaimStatusModel.fromJson(Map<String, dynamic> _claimstatusAJson) =>
      ClaimStatusModel(
        EMP_NO: _claimstatusAJson["EMP_NO"],
        EMP_NAME: _claimstatusAJson["EMP_NAME"],
        EMP_GRADE: _claimstatusAJson["EMP_GRADE"],
        VENDOR_CODE: _claimstatusAJson["VENDOR_CODE"],
        CLAIM_REQ_NO_PORTAL: _claimstatusAJson["CLAIM_REQ_NO_PORTAL"],
        REQ_CREATION_DATE: _claimstatusAJson["REQ_CREATION_DATE"],
        REQ_TYPE: _claimstatusAJson["REQ_TYPE"],
        // CLAIM_NO_SAP: _claimstatusAJson["CLAIM_NO_SAP"],
        // CLAIM_CREATION_DATE: _claimstatusAJson["CLAIM_CREATION_DATE"],
        REQUEST_STATUS: _claimstatusAJson["REQUEST_STATUS"],
        CLAIM_STATUS: _claimstatusAJson["CLAIM_STATUS"],
        // HR_REMARK: _claimstatusAJson["HR_REMARK"],
        // CLAIM_CREATED_BY_HR: _claimstatusAJson["CLAIM_CREATED_BY_HR"],
        F_AND_A_REMARK: _claimstatusAJson["F_AND_A_REMARK"],
        CLAIM_APPROVED_BY_F_AND_A: _claimstatusAJson["CLAIM_APPROVED_BY_F_AND_A"],
        // CLAIM_APPROVED_ON: _claimstatusAJson["CLAIM_APPROVED_ON"],
        // POSTINGDATE: _claimstatusAJson["POSTINGDATE"],
        // DOCUMENT_NUMBER: _claimstatusAJson["DOCUMENT_NUMBER"],
        // COMPANY_CODE: _claimstatusAJson["COMPANY_CODE"],
        REJECTEDBY: _claimstatusAJson["REJECTEDBY"],
        REJECTEDON: _claimstatusAJson["REJECTEDON"],
        REJECTION_REASON: _claimstatusAJson["REJECTION_REASON"],
        REJECTION_DEPARTMENT: _claimstatusAJson["REJECTION_DEPARTMENT"],
        ADDDATE: _claimstatusAJson["ADDDATE"],
        UPDATEDATE: _claimstatusAJson["UPDATEDATE"],
        ISACTIVE: _claimstatusAJson["ISACTIVE"],
        ID: _claimstatusAJson["ID"],
        REQ_AMOUNT_TOTAL: _claimstatusAJson["REQ_AMOUNT_TOTAL"],
        AMMT_PASSED_BY_HR: _claimstatusAJson["AMMT_PASSED_BY_HR"],
        AMT_PASSED_BY_F_AND_A: _claimstatusAJson["AMMT_PASSED_BY_HR"],

      );

  // ClaimTypeModel.fromJson(Map<String, dynamic> json) {
  //   value = json['value'];
  //   text = json['text'];
  //
  // }
  //
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EMP_NO'] = this.EMP_NO;
    data['EMP_NAME'] = this.EMP_NAME;
    data['EMP_GRADE'] = this.EMP_GRADE;
    data['VENDOR_CODE'] = this.VENDOR_CODE;
    data['CLAIM_REQ_NO_PORTAL'] = this.CLAIM_REQ_NO_PORTAL;
    data['REQ_CREATION_DATE'] = this.REQ_CREATION_DATE;
    data['REQ_TYPE'] = this.REQ_TYPE;
    // data['CLAIM_NO_SAP'] = this.CLAIM_NO_SAP;
    // data['CLAIM_CREATION_DATE'] = this.CLAIM_CREATION_DATE;
    data['REQUEST_STATUS'] = this.REQUEST_STATUS;
    data['CLAIM_STATUS'] = this.CLAIM_STATUS;
    // data['HR_REMARK'] = this.HR_REMARK;
    // data['CLAIM_CREATED_BY_HR'] = this.CLAIM_CREATED_BY_HR;
    data['F_AND_A_REMARK'] = this.F_AND_A_REMARK;
    data['CLAIM_APPROVED_BY_F_AND_A'] = this.CLAIM_APPROVED_BY_F_AND_A;
    // data['CLAIM_APPROVED_ON'] = this.CLAIM_APPROVED_ON;
    // data['POSTINGDATE'] = this.POSTINGDATE;
    // data['DOCUMENT_NUMBER'] = this.DOCUMENT_NUMBER;
    // data['COMPANY_CODE'] = this.COMPANY_CODE;
    data['REJECTEDBY'] = this.REJECTEDBY;
    data['REJECTEDON'] = this.REJECTEDON;
    data['REJECTION_REASON'] = this.REJECTION_REASON;
    data['REJECTION_DEPARTMENT'] = this.REJECTION_DEPARTMENT;
    data['ADDDATE'] = this.ADDDATE;
    data['UPDATEDATE'] = this.UPDATEDATE;
    data['UPDATEDATE'] = this.UPDATEDATE;
    data['ISACTIVE'] = this.ISACTIVE;
    data['ID'] = this.ID;
    data['REQ_AMOUNT_TOTAL'] = this.REQ_AMOUNT_TOTAL;
    data['AMT_PASSED_BY_F_AND_A'] = this.AMT_PASSED_BY_F_AND_A;
    return data;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:prms/Model/claim_status_details.dart';
import 'package:prms/Model/claim_status_model.dart';
import 'package:prms/Model/req_details_model.dart';
import 'package:prms/Rest/api_services.dart';
 
// import 'package:sn_progress_dialog/progress_dialog.dart';

class MedicalClaimStatusProvider extends ChangeNotifier{
  ApiService apiService = ApiService();
  ClaimModel? claimModel;
  List<ClaimStatusModel>? claimstatusModelList = [];
  ClaimDetailsModel? claimDetailsModel;
  List<ClaimDetailsModelAPI>? claimdetailslist = [];
  ClaimReqDetailsModel? claimDraftModel;
  List<Datum>? claimreqDetailsList = [];
  bool? isloading = false;


  changeColorStatus(){

  }


  getmedicalClaimStatusApi(BuildContext context)async{
    // onlyMessageProgress(context);
    isloading = true;
    claimModel = await apiService.medicalClaimStatusData();
    isloading = false;
    // pd.close();
    claimstatusModelList = claimModel!.data;
    notifyListeners();
  }
  getmedicalClaimDetailsApi(BuildContext context)async{
    isloading = true;
    claimDetailsModel = await apiService.medicalClaimDetailsData();
    isloading = false;
    claimdetailslist = claimDetailsModel!.data;
    notifyListeners();
  }

  void getClaimReqDetailsData(BuildContext context, String reqNo) async{
    isloading = true;
    claimDraftModel = await apiService.claimReqDetailsData(context,reqNo);
    isloading = false;
    claimreqDetailsList = claimDraftModel!.data;
    notifyListeners();
  }
  // onlyMessageProgress(context) async {
  //   ProgressDialog pd = ProgressDialog(context: context);
  //   pd.show(
  //     barrierDismissible: true,
  //     msg: "Please waiting...",
  //     hideValue: true,
  //   );
  //
  //   /** You can update the message value after a certain action **/
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   pd.update(msg: "Almost done...");
  //
  //   await Future.delayed(Duration(milliseconds: 1000));
  //   pd.close();
  // }

}
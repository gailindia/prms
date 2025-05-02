import 'package:flutter/material.dart';
import '/Model/claim_status_model.dart';
import '/Widget/customAppBar.dart';

class ClaimStatusDetailsScreen extends StatefulWidget {
  final ClaimStatusModel? todo;
  const ClaimStatusDetailsScreen({super.key, required this.todo});


  @override
  State<ClaimStatusDetailsScreen> createState() => _ClaimStatusDetailsScreenState();
}

class _ClaimStatusDetailsScreenState extends State<ClaimStatusDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Claim Status Detail',),
      body:
      ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 40,
            decoration: const BoxDecoration(
                color: Colors.amber
            ),
            child:  Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Claim Request No. Portal',textScaleFactor: MediaQuery.of(context).textScaleFactor,),
            ),

          ),
          Padding(padding: EdgeInsets.all(8),
            child: Text(widget.todo!.CLAIM_REQ_NO_PORTAL.toString(),textScaleFactor: 1.2,),
          ),
          Container(
            height: 40,
            decoration: const BoxDecoration(
                color: Colors.amber
            ),
            child:  Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Request Creation Date',textScaleFactor: MediaQuery.of(context).textScaleFactor,),
            ),

          ),
          Padding(padding: EdgeInsets.all(8),
            child: Text(widget.todo!.REQ_CREATION_DATE.toString(),textScaleFactor: MediaQuery.of(context).textScaleFactor,),
          ),
          Container(
            height: 40,
            decoration: const BoxDecoration(
                color: Colors.amber
            ),
            child:  Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Request Type',textScaleFactor: MediaQuery.of(context).textScaleFactor,),
            ),

          ),
          Padding(padding: EdgeInsets.all(8),
            child: Text(widget.todo!.REQ_TYPE.toString(),textScaleFactor: MediaQuery.of(context).textScaleFactor,),
          )
          ,Container(
            height: 40,
            decoration: const BoxDecoration(
                color: Colors.amber
            ),
            child:  Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Request Total Amount',textScaleFactor: MediaQuery.of(context).textScaleFactor,),
            ),

          ),
          Padding(padding: EdgeInsets.all(8),
            child: Text(widget.todo!.REQ_AMOUNT_TOTAL.toString(),textScaleFactor: MediaQuery.of(context).textScaleFactor,),
          ),Container(
            height: 40,
            decoration: const BoxDecoration(
                color: Colors.amber
            ),
            child:  Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Amount Passed By HR',textScaleFactor: MediaQuery.of(context).textScaleFactor,),
            ),

          ),
          Padding(padding: EdgeInsets.all(8),
            child: Text(widget.todo!.AMMT_PASSED_BY_HR.toString(),textScaleFactor: MediaQuery.of(context).textScaleFactor,),
          ),Container(
            height: 40,
            decoration: const BoxDecoration(
                color: Colors.amber
            ),
            child:  Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Amount Passed By Finance',textScaleFactor: MediaQuery.of(context).textScaleFactor,),
            ),

          ),
          Padding(padding: EdgeInsets.all(8),
            child: Text(widget.todo!.AMT_PASSED_BY_F_AND_A.toString(),textScaleFactor: MediaQuery.of(context).textScaleFactor,),
          ),Container(
            height: 40,
            decoration: const BoxDecoration(
                color: Colors.amber
            ),
            child:  Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Claim Status',textScaleFactor: MediaQuery.of(context).textScaleFactor,),
            ),

          ),
          Padding(padding: EdgeInsets.all(8),
            child: Text(widget.todo!.CLAIM_STATUS.toString(),textScaleFactor: MediaQuery.of(context).textScaleFactor,),
          ),Container(
            height: 40,
            decoration: const BoxDecoration(
                color: Colors.amber
            ),
            child:  Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('HR Remark',textScaleFactor: MediaQuery.of(context).textScaleFactor,),
            ),

          ),
           Padding(padding: EdgeInsets.all(8),
            child: Text('',textScaleFactor: MediaQuery.of(context).textScaleFactor,),
          ),Container(
            height: 40,
            decoration: const BoxDecoration(
                color: Colors.amber
            ),
            child:  Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Finance Remark',textScaleFactor: MediaQuery.of(context).textScaleFactor,),
            ),

          ),
           Padding(padding: EdgeInsets.all(8),
            child: Text('',textScaleFactor: MediaQuery.of(context).textScaleFactor,),
          )
        ],
      ),
    );
  }
}

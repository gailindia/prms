import 'package:flutter/material.dart';
import '../Model/claim_type_model.dart';
import '../styles/text_style.dart';
 

class PatientBottomSheetWidget extends StatefulWidget {
  String? content;
  String? heading;
  List<ClaimTypeModel>? claimtype ;

  final Function(String) onpressed;

  PatientBottomSheetWidget({Key? key,required this.content, required this.heading,required this.claimtype,required this.onpressed}) : super(key: key);

  @override
  State<PatientBottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<PatientBottomSheetWidget> {
  String? value='';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    value = widget.content;
  }

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Expanded(child: Text(widget.heading ?? "",style: textStyle14Bold,)),
        Expanded(
          child: GestureDetector(
            onTap: (){
              showModalBottomSheet(context: context, builder: (context){
                return  Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                            Radius.circular(10.0)), // Set rounded corner radius// Make rounded corner of border
                      ),
                      height: 40,
                      child:  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap:(){
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel',style: TextStyle(color: Colors.blue,fontSize: 12,fontWeight: FontWeight.w600))),
                            const Spacer(),
                            Text('Select ${widget.heading}',style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w600),),
                            const Spacer(),
                            // GestureDetector(
                            //     onTap: (){
                            //       Navigator.pop(context);
                            //     },
                            //     child: const Text('Done',style: TextStyle(color: Colors.blue,fontSize: 14,fontWeight: FontWeight.w600))),
                          ],
                        ),
                      ),
                    ),

                    ListView.builder(
                        itemCount: widget.claimtype!.length,
                        shrinkWrap: true,
                        physics:  const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return  Center(
                            child: GestureDetector(
                                onTap: (){
                                  // print("fzrdgxftcgvyhbjkn ${claimtype[index]}");
                                  widget.onpressed(widget.claimtype![index].text!);
                                  value = widget.claimtype![index].text!;
                                  setState(() {

                                  });
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    // height: 40,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Center(child: Text(widget.claimtype![index].text.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 18),)),
                                    ))),
                          );
                        }),
                  ],
                );

              });
            },
            child: Container(
              height: 40,
              decoration:  BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                      Radius.circular(10.0)),
                  border: Border.all(width: 1,color: Colors.black)  // Set rounded corner radius// Make rounded corner of border
              ),
              child:  Padding(
                padding:  const EdgeInsets.only(left:5.0,right: 5),
                child:  Row(
                  children: [
                    Container(
                        width: 120,
                        child: Text(value.toString(),overflow: TextOverflow.ellipsis,maxLines: 1)),
                    // const Spacer(),
                    const Icon(Icons.arrow_drop_down,size: 20,)
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


}
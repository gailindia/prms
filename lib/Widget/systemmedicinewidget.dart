import 'package:flutter/material.dart';
import '../Model/system_of_medicine_model.dart';
import '../styles/text_style.dart';

 



class Widgetforsystemmedicine extends StatefulWidget {
  String? heading;
  String? content;
  List<SystemOfMedicine>? systemMedicine;
  final Function(String) onpressed;

  Widgetforsystemmedicine({Key? key,required this.content, required this.heading,required this.systemMedicine, required this.onpressed}) : super(key: key);

  @override
  State<Widgetforsystemmedicine> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<Widgetforsystemmedicine> {
  String? value="";

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
                return  ListView(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                            Radius.circular(10.0)), // Set rounded corner radius// Make rounded corner of border
                      ),
                      height: 40,
                      child:  Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap:(){
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel',style: TextStyle(color: Colors.blue,fontSize: 12,fontWeight: FontWeight.w600))),
                            const Spacer(),
                             Text('Select ${widget.heading!.contains('Domiciliary') ? 'Domicialiary Treatment' : widget.heading}',style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w600),),
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
                        itemCount: widget.systemMedicine?.length,
                        shrinkWrap: true,
                        physics:  const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return  Center(
                            child: GestureDetector(
                                onTap: (){
                                  // print("fzrdgxftcgvyhbjkn ${claimtype[index]}");
                                  widget.onpressed(widget.systemMedicine![index].type!);
                                  value = widget.systemMedicine![index].type!;
                                  setState(() {

                                  });
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    // height: 40,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(widget.systemMedicine![index].type!,textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),
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




/*class BottomSheetWidget extends StatelessWidget {
  String? heading;
  List<String> claimtype;
  final Function(String) onpressed;
  String? value="";
  BottomSheetWidget({Key? key, required this.heading, required this.claimtype, required this.onpressed,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
         Expanded(child: Text(heading ?? "")),
        Expanded(
          child: GestureDetector(
            onTap: (){
              showModalBottomSheet(context: context, builder: (context){
                return  Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(
                            Radius.circular(10.0)), // Set rounded corner radius// Make rounded corner of border
                      ),
                      height: 40,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text('Cancel'),
                            Spacer(),
                            Text('Select Permit Type'),
                            Spacer(),
                            Text('Done'),
                          ],
                        ),
                      ),
                    ),
                    ListView.builder(
                        itemCount: claimtype.length,
                        shrinkWrap: true,
                        physics:  NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return  Center(
                            child: GestureDetector(
                              onTap: (){
                                // print("fzrdgxftcgvyhbjkn ${claimtype[index]}");
                                onpressed(claimtype[index]);
                                value = claimtype[index];

                                Navigator.pop(context);
                              },
                                child: Container(
                                    height: 40,
                                    child: Text(claimtype[index]))),
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
                padding:  EdgeInsets.only(left:5.0,right: 5),
                child:  Row(
                  children: [
                    Text(value ?? ""),
                    Spacer(),
                    Icon(Icons.arrow_drop_down)
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}*/

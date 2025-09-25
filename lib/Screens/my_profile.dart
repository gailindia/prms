import 'package:flutter/material.dart';
import '/Widget/customAppBar.dart';
import 'package:secure_shared_preferences/secure_shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';


class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String? name,cpf,location,vendorcode,grade;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedPrefData();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final scale = mediaQueryData.textScaleFactor;

    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
        child: Scaffold(
          appBar: CustomAppBar(title: "My Profile",),
          body:  Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Icon(Icons.supervised_user_circle,size: 100,),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 2,
                        child: const Text("Name",style: TextStyle(fontWeight: FontWeight.w600),)),
                    // const Spacer(),
                    Expanded(
                        flex: 1,
                        child: const Text(":")),
                    // const Spacer(),
                    Expanded(
                        flex: 4,
                        child: Text(name ?? "NA",style: TextStyle(fontWeight: FontWeight.w400,),)),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 2,
                        child: const Text("CPF Number",style: TextStyle(fontWeight: FontWeight.w600))),
                    // const Spacer(),
                    Expanded(
                        flex: 1,
                        child: const Text(":")),
                    // const Spacer(),
                    Expanded(
                        flex: 4,
                        child: Text(cpf ?? "NA",style: TextStyle(fontWeight: FontWeight.w400))),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Expanded(
                        flex: 2,
                        child: Text("Location",style: TextStyle(fontWeight: FontWeight.w600))),
                    // const Spacer(),
                    Expanded(
                        flex: 1,
                        child: const Text(":")),
                    // const Spacer(),
                    Expanded(
                        flex: 4,
                        child: Text(location ?? "NA",style: TextStyle(fontWeight: FontWeight.w400))),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Expanded(
                        flex: 2,
                        child: Text("Vendor Code",style: TextStyle(fontWeight: FontWeight.w600))),
                    // const Spacer(),
                    Expanded(
                        flex: 1,
                        child: const Text(":")),
                    // const Spacer(),
                    Expanded(
                        flex: 4,
                        child: Text(vendorcode ?? "NA",style: TextStyle(fontWeight: FontWeight.w400))),
                  ],
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                // Row(
                //   children: [
                //     const Text("Grade at the time of",style: TextStyle(fontWeight: FontWeight.w600)),
                //     const Spacer(),
                //     const Text(":"),
                //     const Spacer(),
                //     Text(grade.toString()),
                //   ],
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                // const Row(
                //   children: [
                //     Text("superannuation/ Separation",style: TextStyle(fontWeight: FontWeight.w600)),
                //     Spacer(),
                //     Text(":"),
                //     Spacer(),
                //     Text(""),
                //   ],
                // ),


              ],
            ),
          ),
        ));
  }

  void getSharedPrefData() async{
    SecureSharedPref preferences = await SecureSharedPref.getInstance();
    try{
      // print(await preferences.getString('EMP_NO'));
      cpf = (await preferences.getString('EMP_NO'));
      name = (await  preferences.getString('EMP_NAME',isEncrypted: true));
      grade = (await preferences.getString('GRADE'));
      location = (await preferences.getString('LOCATION',isEncrypted: true));
      vendorcode = (await preferences.getString('VENDOR_CODE',isEncrypted: true));
    }catch(e){

    }

    // SharedPreferences preferences  = await SharedPreferences.getInstance();



    setState(() {

    });

  }
}

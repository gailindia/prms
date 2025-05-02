// ignore_for_file: prefer_const_constructors, unused_local_variable, unused_field, use_build_context_synchronously
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '/Provider/loginProvider.dart';
import 'package:provider/provider.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LoginScreen> with SingleTickerProviderStateMixin{

  TextEditingController userIDController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  TabController? _tabController;
  List bannerImages = [
    'assets/images/prms_banner.png',
    'assets/images/prmsbanner.png',
    'assets/images/banner_prms.png',
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: Column(
            children: [
              CarouselSlider.builder(
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 1,
                  aspectRatio: 1.4,
                  initialPage: 0,
                ),
                itemCount: 3,
                itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                    Stack(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(bannerImages[itemIndex]),
                        Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                                width: 80,
                                height: 80,
                                child: Image.asset("assets/images/gaillogo.png",))),
                        Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 25.0,right: 20),
                              child: Opacity(
                                  opacity: 0.5,
                                  child: Text("PRMS",textScaleFactor: MediaQuery.of(context).textScaleFactor,style: const TextStyle(color: Colors.orangeAccent,fontWeight: FontWeight.w400,fontSize: 60),)),
                            )),

                      ],
                    ),
              ),
              // give the tab bar a height [can change hheight to preferred height]
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TabBar(
                      controller: _tabController,
                      // give the indicator a decoration (color and border radius)
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ),
                        color: Colors.white,
                      ),
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelPadding: const EdgeInsets.only(left: 5,right: 5),
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        // first tab [you can add an icon using the icon property]
                        Tab(
                          text: 'Mobile OTP',
                        ),

                        // second tab [you can add an icon using the icon property]
                        Tab(
                          text: 'User ID/Password',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // tab bar view here
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // first tab bar view widget
                    Container(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 30, right: 30, bottom: 4),
                            child: TextFormField(
                              minLines: 1,
                              // maxLines: 4,

                              maxLength: 10,
                              autocorrect: false,
                              cursorColor: Colors.grey,
                              keyboardType: TextInputType.number,
                              controller: mobileController,
                              textCapitalization:
                              TextCapitalization.sentences,
                              toolbarOptions: ToolbarOptions(
                                copy: false,
                                cut: false,
                                paste: false,
                                selectAll: false,
                              ),
                              // validator: (_desc) => _desc!.isEmpty
                              //     ? "Kindly Enter Mobile No"
                              //     : null,
                              decoration: InputDecoration(
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  // ignore: prefer_const_constructors
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                                labelText: "Enter Mobile Number/User ID",
                                labelStyle: TextStyle(
                                    color: Colors.grey
                                ),
                                // prefixIcon:
                                // Icon(Icons.person_outline_rounded),
                                contentPadding: const EdgeInsets.all(12),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),


                          Padding(
                            padding:  EdgeInsets.only(left: 20.0,right: 20,top: 0),
                            child: Container(
                                width: MediaQuery.of(context).size.width*1,

                                child: ElevatedButton(

                                    onPressed: (){
                                      if(mobileController.text.isNotEmpty){
                                        loginProvider.sednOTP(context,mobileController.text);
                                      }else{
                                        final snackBar = SnackBar(
                                          content:  Text('Please Enter UserID',textScaleFactor: MediaQuery.of(context).textScaleFactor,),
                                          action: SnackBarAction(
                                            label: '',
                                            onPressed: () {
                                              // Some code to undo the change.
                                            },
                                          ),
                                        );

                                        // Find the ScaffoldMessenger in the widget tree
                                        // and use it to show a SnackBar.
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                      }


                                      // if (_formKey.currentState!.validate()) {
                                      //   _formKey.currentState!.save();
                                      //   loginProvider.getLoginApi(context,userIDController.text,passwordController.text);
                                      // }
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => const OTPScreen()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.amber,
                                        // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                        textStyle: TextStyle(
                                          // fontSize: 30,
                                            fontWeight: FontWeight.bold)),
                                    child:  Text("Request OTP",textScaleFactor: MediaQuery.of(context).textScaleFactor,style: TextStyle(color: Colors.white),))),
                          ),

                        ],
                      ),
                    ),
                    // second tab bar view widget
                    Container(
                      child: SingleChildScrollView(
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0, left: 30, right: 30, bottom: 4),
                              child: TextFormField(
                                minLines: 1,
                                // maxLines: 4,
                                // maxLength: 10,
                                toolbarOptions: ToolbarOptions(
                                  copy: false,
                                  cut: false,
                                  paste: false,
                                  selectAll: false,
                                ),
                                autocorrect: false,
                                cursorColor: Colors.grey,
                                keyboardType: TextInputType.multiline,
                                controller: userIDController,
                                textCapitalization:
                                TextCapitalization.sentences,
                                validator: (_desc) => _desc!.isEmpty
                                    ? "Kindly Enter UserID"
                                    : null,
                                decoration: InputDecoration(
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    // ignore: prefer_const_constructors
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2.0,
                                    ),
                                  ),
                                  labelText: "User ID",
                                  labelStyle: TextStyle(
                                      color: Colors.grey
                                  ),
                                  // prefixIcon:
                                  // Icon(Icons.person_outline_rounded),
                                  contentPadding: const EdgeInsets.all(12),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 30, right: 30, bottom: 4),
                              child: TextFormField(
                                minLines: 1,
                                // maxLines: 4,
                                // maxLength: 10,
                                toolbarOptions: ToolbarOptions(
                                  copy: false,
                                  cut: false,
                                  paste: false,
                                  selectAll: false,
                                ),
                                autocorrect: false,
                                cursorColor: Colors.grey,
                                keyboardType: TextInputType.text,
                                obscureText: _obscureText,
                                controller: passwordController,
                                textCapitalization:
                                TextCapitalization.sentences,
                                validator: (_desc) => _desc!.isEmpty
                                    ? "Kindly Enter Password"
                                    : null,
                                decoration: InputDecoration(
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    // ignore: prefer_const_constructors
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2.0,
                                    ),
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                    child:
                                    new Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                                  ),
                                  labelText: "Password",
                                  labelStyle: TextStyle(
                                      color: Colors.grey
                                  ),
                                  // prefixIcon:
                                  // Icon(Icons.person_outline_rounded),
                                  contentPadding: const EdgeInsets.all(12),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  focusedBorder:  OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 20.0,right: 20,top: 20),
                              child: Container(
                                  width: MediaQuery.of(context).size.width*1,

                                  child: ElevatedButton(

                                      onPressed: (){
                                        if(userIDController.text.isEmpty || passwordController.text.isEmpty){
                                          final snackBar = SnackBar(
                                            content: const Text('Please Enter Credentials'),
                                            action: SnackBarAction(
                                              label: '',
                                              onPressed: () {
                                                // Some code to undo the change.
                                              },
                                            ),
                                          );

                                          // Find the ScaffoldMessenger in the widget tree
                                          // and use it to show a SnackBar.
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                        }else{
                                          loginProvider.getLoginApi(context,userIDController.text,passwordController.text);
                                        }

                                        //
                                        // if (_formKey.currentState!.validate()) {
                                        //   _formKey.currentState!.save();
                                        //
                                        // }
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) => const HomeScreen()));
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.amber,
                                          // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                          textStyle: TextStyle(
                                            // fontSize: 30,
                                              fontWeight: FontWeight.bold)),
                                      child:  Text("Login",textScaleFactor: MediaQuery.of(context).textScaleFactor,style: TextStyle(color: Colors.white),))),
                            ),

                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



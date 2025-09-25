import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart' hide ChangeNotifierProvider;
// import 'package:freerasp/freerasp.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import '../Provider/claimtypeProvider.dart';
import '../Provider/homeprovider.dart';
import '../Provider/loginProvider.dart';
import '../Provider/medicalclaimstatusprovider.dart';
import '../splash_screen.dart';

import 'package:provider/provider.dart';

// import 'jailbreak/threat_notifier.dart';
// import 'jailbreak/threat_state.dart';

/// Represents current state of the threats detectable by freeRASP
// final threatProvider =
//     riverpod.NotifierProvider.autoDispose<ThreatNotifier, ThreatState>(() {
//   return ThreatNotifier();
// });

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  String sha256Hex = "0E:88:63:95:D8:FB:B4:5D:2A:0A:A0:5D:84:B7:69:42:E3:39:32:CF:41:3B:F4:14:DA:71:F2:76:37:BF:1D:78";

  // String base64Hash = hashConverter.fromSha256toBase64(sha256Hex);
  // print(base64Hash);

  // _initializeTalsec(base64Hash);
  // runApp(ProviderScope(
  //   child: MultiProvider(providers: [
  //     ChangeNotifierProvider(create: (_) => ClaimTypeProvider()),
  //     ChangeNotifierProvider(create: (_) => LoginProvider()),
  //     ChangeNotifierProvider(create: (_) => MedicalClaimStatusProvider()),
  //     ChangeNotifierProvider(create: (_) => HomeProvider()),
  //
  //   ], child:const MyApp()),
  // ));

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ClaimTypeProvider()),
    ChangeNotifierProvider(create: (_) => LoginProvider()),
    ChangeNotifierProvider(create: (_) => MedicalClaimStatusProvider()),
    ChangeNotifierProvider(create: (_) => HomeProvider()),
  ], child:const MyApp()));

}

/// Initialize Talsec configuration for Android and iOS
// Future<void> _initializeTalsec(String base64Hash) async {
//   final config = TalsecConfig(
//     androidConfig: AndroidConfig(
//       packageName: 'com.gail.gailprms',
//       signingCertHashes: [base64Hash],
//       supportedStores: ['com.sec.android.app.samsungapps'],
//       malwareConfig: MalwareConfig(
//         blacklistedPackageNames: ['com.gail.gailprms'],
//         suspiciousPermissions: [
//           ['android.permission.READ_SMS', 'android.permission.READ_CONTACTS'],
//         ],
//       ),
//     ),
//     iosConfig: IOSConfig(
//       bundleIds: ['com.gail.PRMS'],
//       teamId: 'YF4NDNJ4TE',
//     ),
//     watcherMail: 'surbhi.1.jain@coforge.com',
//     isProd: true,
//   );
//
//   await Talsec.instance.start(config);
// }

class MyApp extends StatelessWidget{//ConsumerWidget
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {//, WidgetRef ref
    // final threatState = ref.watch(threatProvider);
    // Listen for changes in the threatProvider and show the malware modal

    // ref.listen(threatProvider, (prev, next) {
    //   if (prev?.detectedThreats == next.detectedThreats) {
    //     print("prev.detectedThreats :: ${prev?.detectedThreats}");
    //     print("next.detectedThreats :: ${next?.detectedThreats}");
    //   }
    // });

    // var s = threatState.detectedThreats.where((element) {
    //   print("detectedThreats :: ${element.name}");
    //   if(element.name == 'privilegedAccess'){
    //     return true;
    //   }
    //   return false;
    // }).toList();

    // s.isNotEmpty
    //     ? Container(
    //   child: Center(
    //     child: Text("You cannot access this app"),
    //   ),
    // )
    //     : SplashScreen(),

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:   SplashScreen()
    );
  }





}

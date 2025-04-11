import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:freerasp/freerasp.dart';
import 'package:prms/Provider/claimtypeProvider.dart';
import 'package:prms/Provider/homeprovider.dart';
import 'package:prms/Provider/loginProvider.dart';
import 'package:prms/Provider/medicalclaimstatusprovider.dart';
import 'package:prms/splash_screen.dart';

 

import 'package:provider/provider.dart';

import 'jailbreak/threat_notifier.dart';
import 'jailbreak/threat_state.dart';
import 'jailbreak/widgets/malware_bottom_sheet.dart';

/// Represents current state of the threats detectable by freeRASP
// final threatProvider =
//     riverpod.NotifierProvider.autoDispose<ThreatNotifier, ThreatState>(() {
//   return ThreatNotifier();
// });

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // String sha256Hex = "2C:93:84:DF:2D:5F:2A:03:FB:73:D5:14:14:78:9E:4C:46:36:C8:97:85:89:C8:87:87:4A:20:34:D5:D3:30:36";
  //
  //
  // String base64Hash = hashConverter.fromSha256toBase64(sha256Hex);
  // print(base64Hash);

  // await _initializeTalsec(base64Hash);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ClaimTypeProvider()),
    ChangeNotifierProvider(create: (_) => LoginProvider()),
    ChangeNotifierProvider(create: (_) => MedicalClaimStatusProvider()),
    ChangeNotifierProvider(create: (_) => HomeProvider()),
  ], child:const MyApp()));
}

/// Initialize Talsec configuration for Android and iOS
Future<void> _initializeTalsec(String base64Hash) async {
  final config = TalsecConfig(
    androidConfig: AndroidConfig(
      packageName: 'com.gail.gailprms',
      signingCertHashes: [base64Hash],
      supportedStores: ['com.sec.android.app.samsungapps'],
      malwareConfig: MalwareConfig(
        blacklistedPackageNames: ['com.gail.gailprms'],
        suspiciousPermissions: [
          ['android.permission.READ_SMS', 'android.permission.READ_CONTACTS'],
        ],
      ),
    ),
    iosConfig: IOSConfig(
      bundleIds: ['com.gail.PRMS'],
      teamId: 'YF4NDNJ4TE',
    ),
    watcherMail: 'surbhi.1.jain@coforge.com',
    isProd: true,
  );

  await Talsec.instance.start(config);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final threatState = ref.watch(threatProvider);
    // // Listen for changes in the threatProvider and show the malware modal
    //
    // ref.listen(threatProvider, (prev, next) {
    //   if (prev?.detectedMalware != next.detectedMalware) {
    //   //  _showMalwareBottomSheet(context, next.detectedMalware);
    //   }
    // });
    //
    // threatState.detectedThreats.where((element) {
    //   return false;
    // }).toList();

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }

}

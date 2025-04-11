import 'package:get/get.dart';

class Services extends GetConnect {
  static Services get to => Get.find<Services>();

  @override
  void onInit() {
    super.onInit();
    httpClient.timeout = const Duration(seconds: 30);
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Connection'] = 'keep-alive';
      return request;
    });
  }
}
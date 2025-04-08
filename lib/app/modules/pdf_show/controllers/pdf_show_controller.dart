import 'package:get/get.dart';

class PdfShowController extends GetxController {
  //
  final RxString _pdfUrl = "".obs;
  String get pdfUrl => _pdfUrl.value;
  set pdfUrl(String str) => _pdfUrl.value = str;

  final RxString _filepath = "".obs;
  String get filepath => _filepath.value;
  set filepath(String str) => _filepath.value = str;

  @override
  void onInit() {
    super.onInit();
    pdfUrl = Get.arguments[0];
    filepath = Get.arguments[1];
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

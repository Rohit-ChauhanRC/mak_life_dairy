import 'package:get/get.dart';

import '../controllers/pdf_show_controller.dart';

class PdfShowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PdfShowController>(
      () => PdfShowController(),
    );
  }
}

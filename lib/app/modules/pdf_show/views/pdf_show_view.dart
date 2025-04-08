import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../controllers/pdf_show_controller.dart';
import 'package:share_plus/share_plus.dart';

class PdfShowView extends GetView<PdfShowController> {
  const PdfShowView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mak Life Dairy',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.green,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.share,
              color: Colors.green,
              semanticLabel: 'Share',
            ),
            onPressed: () {
              debugPrint(controller.filepath);
              Share.shareXFiles([(XFile(controller.filepath))]);
            },
          ),
          const SizedBox(
            width: 20,
          )
        ],
        centerTitle: true,
      ),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Obx(
          () => controller.pdfUrl.isNotEmpty
              ? SfPdfViewer.file(
                  File(controller.filepath),
                )
              // SfPdfViewer.network(
              //     controller.pdfUrl,
              //   )
              : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                ),
        ),
      ),
    );
  }
}

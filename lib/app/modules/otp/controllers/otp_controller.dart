import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:webview_mak_inapp/app/constants/constants.dart';
import 'package:webview_mak_inapp/app/routes/app_pages.dart';
import 'package:webview_mak_inapp/app/utils/utils.dart';

import '../../../data/dio_client.dart';
import '../../../data/models/send_otp_model.dart';
import 'package:get_storage/get_storage.dart';

class OtpController extends GetxController {
  //
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final DioClient client = DioClient();

  final box = GetStorage();

  final RxString _otp = ''.obs;
  String get otp => _otp.value;
  set otp(String str) => _otp.value = str;

  final RxBool _circularProgress = true.obs;
  bool get circularProgress => _circularProgress.value;
  set circularProgress(bool v) => _circularProgress.value = v;

  final RxString _mobileNumber = ''.obs;
  String get mobileNumber => _mobileNumber.value;
  set mobileNumber(String mobileNumber) => _mobileNumber.value = mobileNumber;

  final RxInt _count = 0.obs;
  int get count => _count.value;
  set count(int i) => _count.value = i;

  final RxBool _resend = true.obs;
  bool get resend => _resend.value;
  set resend(bool v) => _resend.value = v;

  @override
  void onInit() {
    super.onInit();
    mobileNumber = Get.arguments.toString();
    counter();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    _mobileNumber.close();
    _count.close();
    _otp.close();
  }

  void counter() {
    for (var i = 1; i <= 80; i++) {
      count += 1;
    }
    if (count == 80) {
      resend = true;
    }
  }

  Future<dynamic> resendOtp() async {
    Utils.closeKeyboard();
    if (!loginFormKey!.currentState!.validate()) {
      return null;
    }
    SendOtpModel? sendOtpModel = SendOtpModel(status: "", message: "");

    await client.postApi(endPointApi: Constants.sendOtp, data: {
      "MobileNo": mobileNumber,
    }).then((value) => sendOtpModel = value!);
    count = 0;
    resend = false;
    circularProgress = true;
  }

  Future<dynamic> otpVerify() async {
    Utils.closeKeyboard();
    if (!loginFormKey!.currentState!.validate()) {
      return null;
    }
    SendOtpModel? sendOtpModel = SendOtpModel(status: "", message: "");
    circularProgress = false;

    await client.postApi(endPointApi: Constants.verifyOtp, data: {
      "MobileNo": mobileNumber,
      "OtpNo": otp
    }).then((value) => sendOtpModel = value!);

    debugPrint(sendOtpModel!.status.toString());
    if (sendOtpModel!.status == "200") {
      circularProgress = true;
      box.write(Constants.cred, mobileNumber);
      Get.offAllNamed(
        Routes.HOME,
        arguments: mobileNumber,
      );
    } else {
      circularProgress = true;
      Utils.showDialog(Constants.error);
    }
  }
}

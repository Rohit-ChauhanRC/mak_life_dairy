import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:webview_mak_inapp/app/routes/app_pages.dart';

import '../../../constants/constants.dart';
import '../../../widgets/check_box_widget.dart';
import '../../../widgets/check_form_field.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          // resizeToAvoidBottomInset: false,
          body: Container(
            height: Get.height,
            width: Get.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/images/bg_pg.jpg",
                  ),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter),
            ),
            child: SingleChildScrollView(
              child: Column(
                // physics: const BouncingScrollPhysics(),
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 120,
                    ),
                    // height: ScreenUtil().screenHeight / 8,
                    // width: ScreenUtil().screenWidth / 1.5,
                    child: Image.asset(
                      "assets/images/app_logo.png",
                      height: 200,
                      width: 200,
                      // color: AppColor.kLogoColor,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 30,
                      left: 20,
                      right: 20,
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Form(
                      key: controller.loginFormKey,
                      child: Column(
                        children: [
                          Text(
                            "Welcome to Mak Life",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[900],
                              fontFamily: "Raleway",
                              letterSpacing: 1.5,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              top: 30,
                            ),
                            child: TextFormField(
                              validator: (value) => value!.length < 10
                                  ? "Please enter valid mobile no."
                                  : null,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              autovalidateMode: AutovalidateMode.always,
                              onChanged: (val) {
                                controller.mobileNumber = val;
                              },
                              decoration: InputDecoration(
                                label: const Text("Please enter mobile no."),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // CheckboxFormField(
                          //   title: const Text(Constants.agreeTerms),
                          //   initialValue: controller.agreeCheck,
                          //   onSaved: (val) {
                          //     controller.agreeCheck = val!;
                          //     debugPrint("${controller.agreeCheck}");
                          //   },
                          // ),
                          Obx(() => CheckBoxWidget(
                                onChanged: (val) {
                                  controller.agreeCheck = val!;
                                  debugPrint("${controller.agreeCheck}");
                                  debugPrint("${controller.agreeCheck}");
                                },
                                title: Constants.agreeTerms,
                                value: controller.agreeCheck,
                                width: Get.width * .6,
                                onTap: () {},
                              )),
                          controller.circularProgress
                              ? Container(
                                  margin: const EdgeInsets.only(
                                    top: 30,
                                  ),
                                  width: Get.width / 2,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple[900],
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      fixedSize: const Size(120, 30),
                                    ),
                                    onPressed: () async {
                                      // Get.toNamed(Routes.OTP);

                                      if (controller.agreeCheck) {
                                        await controller.login();
                                      }
                                    },
                                    child: const Text(
                                      Constants.next,
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                )
                              : const CircularProgressIndicator(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

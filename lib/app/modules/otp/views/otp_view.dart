import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../constants/constants.dart';
import '../controllers/otp_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/background.jpeg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 100,
              ),
              child: Image.asset(
                "assets/images/makdairy.png",
                height: 200,
                width: 200,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
              ),
              padding: const EdgeInsets.all(15),
              child: Form(
                key: controller.loginFormKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: Get.width - 40,
                      child: RichText(
                        overflow: TextOverflow.visible,
                        text: TextSpan(
                            text: Constants.plsOtp,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontFamily: "Raleway",
                              letterSpacing: 1.5,
                            ),
                            children: [
                              TextSpan(
                                text: "\t\t${controller.mobileNumber}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[900],
                                ),
                              ),
                              const TextSpan(
                                text: "\n${Constants.regenerate}",
                              ),
                              const TextSpan(
                                text: "\n${Constants.yourOtp}",
                              ),
                              TextSpan(
                                text: "\t\t${Constants.remaining}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[900],
                                ),
                              ),
                            ]),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 30,
                      ),
                      child: TextFormField(
                        validator: (value) =>
                            value!.length < 4 || value!.length > 5
                                ? "Please enter valid otp"
                                : null,
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        autovalidateMode: AutovalidateMode.always,
                        onChanged: (val) {
                          controller.otp = val;
                        },
                        decoration: InputDecoration(
                          label: const Text("Please enter OTP..."),
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
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        if (controller.resend) controller.resendOtp();
                      },
                      child: Text(
                        Constants.dontReceive,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[900],
                        ),
                      ),
                    ),
                    // controller.circularProgress
                    //     ?
                    Container(
                      margin: const EdgeInsets.only(
                        top: 30,
                      ),
                      // width: Get.width / 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[900],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          // fixedSize: const Size(120, 30),
                        ),
                        onPressed: () async {
                          await controller.otpVerify();
                        },
                        child: const Text(
                          Constants.verifyProceed,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    // : const CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

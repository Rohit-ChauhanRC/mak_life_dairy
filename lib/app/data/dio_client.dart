import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:webview_mak_inapp/app/constants/constants.dart';

import 'models/send_otp_model.dart';

class DioClient {
  // const Services._();

  final dio = Dio();
  final _baseUrl = Constants.baseUrl;

  Future<SendOtpModel?> postApi(
      {required Map<String, String> data, required String endPointApi}) async {
    try {
      Response response = await dio.post(_baseUrl + endPointApi, data: data);
      debugPrint(
        _baseUrl + Constants.sendOtp,
      );
      debugPrint(
        data.toString(),
      );
      debugPrint(
        response.toString(),
      );
      return SendOtpModel(
        status: response.statusCode.toString(),
        message: response.data.toString(),
      );
    } on DioException catch (e) {
      return SendOtpModel(
        status: e.type.toString(),
        message: e.message.toString(),
      );
    }
  }

  // final options = BaseOptions(
  //   baseUrl: 'https://api.pub.dev',
  //   connectTimeout: Duration(seconds: 5),
  //   receiveTimeout: Duration(seconds: 3),
  // );

  // final anotherDio = Dio(options);
}

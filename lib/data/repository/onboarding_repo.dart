import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_grocery/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_grocery/data/model/response/base/api_response.dart';
import 'package:flutter_grocery/data/model/response/onboarding_model.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/utill/images.dart';

class OnBoardingRepo {
  final DioClient dioClient;

  OnBoardingRepo({@required this.dioClient});

  Future<ApiResponse> getOnBoardingList(BuildContext context) async {
    try {
      List<OnBoardingModel> onBoardingList = [
        OnBoardingModel(Images.on_boarding_1, getTranslated('select_your_items_to_buy', context), getTranslated('onboarding_1_text', context)),
        OnBoardingModel(Images.on_boarding_2, getTranslated('order_item_from_your_shopping_bag', context), getTranslated('onboarding_2_text', context)),
        OnBoardingModel(Images.on_boarding_3, getTranslated('our_system_delivery_item_to_you', context), getTranslated('onboarding_3_text', context)),
      ];

      Response response = Response(requestOptions: RequestOptions(path: ''), data: onBoardingList, statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}

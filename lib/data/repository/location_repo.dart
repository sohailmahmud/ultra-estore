import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_grocery/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_grocery/data/model/response/address_model.dart';
import 'package:flutter_grocery/data/model/response/base/api_response.dart';
import 'package:flutter_grocery/localization/language_constrants.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  LocationRepo({this.dioClient, this.sharedPreferences});

  Future<ApiResponse> getAllAddress() async {
    try {
      final response = await dioClient.get(AppConstants.ADDRESS_LIST_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> removeAddressByID(int id) async {
    try {
      final response = await dioClient.post('${AppConstants.REMOVE_ADDRESS_URI}$id', data: {"_method": "delete"});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addAddress(AddressModel addressModel) async {
    try {
      Response response = await dioClient.post(
        AppConstants.ADD_ADDRESS_URI,
        data: addressModel.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateAddress(AddressModel addressModel, int addressId) async {
    try {
      Response response = await dioClient.post(
        '${AppConstants.UPDATE_ADDRESS_URI}$addressId',
        data: addressModel.toJson(),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  List<String> getAllAddressType({BuildContext context}) {
    return [
      getTranslated('home', context),
      getTranslated('workplace', context),
      getTranslated('other', context),
    ];
  }
}

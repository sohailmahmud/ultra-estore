import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart';

import 'package:flutter/material.dart';
import 'package:flutter_grocery/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_grocery/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_grocery/data/model/response/base/api_response.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ChatRepo {
  final DioClient dioClient;
  ChatRepo({@required this.dioClient});

  Future<ApiResponse> getChatList() async {
    try {
      final response = await dioClient.get(AppConstants.MESSAGE_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<http.StreamedResponse> sendMessage(String message, PickedFile file, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.BASE_URL}${AppConstants.SEND_MESSAGE_URI}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    if(file != null && ResponsiveHelper.isMobilePhone()) {
      File _file = File(file.path);
      request.files.add(http.MultipartFile('image', _file.readAsBytes().asStream(), _file.lengthSync(), filename: _file.path.split('/').last));
    }else if(file != null && ResponsiveHelper.isWeb()) {
      Uint8List _list = await file.readAsBytes();
      http.MultipartFile part = http.MultipartFile('image', file.readAsBytes().asStream(), _list.length, filename: basename(file.path));
      request.files.add(part);
    }
    Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'message': message
    });
    request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    return response;
  }
}
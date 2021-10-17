import 'package:flutter_grocery/data/model/response/base/api_response.dart';
import 'package:flutter_grocery/data/model/response/chat_model.dart';
import 'package:flutter_grocery/data/repository/chat_repo.dart';
import 'package:flutter_grocery/helper/api_checker.dart';
import 'package:flutter_grocery/helper/date_converter.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepo chatRepo;
  ChatProvider({@required this.chatRepo});

  List<ChatModel> _chatList;
  List<bool> _showDate;
  List<DateTime> _dateList;
  bool _isSendButtonActive = false;

  List<ChatModel> get chatList => _chatList;
  List<bool> get showDate => _showDate;
  bool get isSendButtonActive => _isSendButtonActive;


  void getChatList(BuildContext context) async {
    _chatList = null;
    _file = null;
    ApiResponse apiResponse = await chatRepo.getChatList();
    if (apiResponse.response != null && apiResponse.response.statusCode == 200) {
      _chatList = [];
      _showDate = [];
      _dateList = [];
      List<dynamic> _chats = apiResponse.response.data[0].reversed.toList();
      _chats.forEach((chat) {
        ChatModel chatModel = ChatModel.fromJson(chat);
        DateTime _originalDateTime = DateConverter.isoStringToLocalDate(chatModel.createdAt);
        DateTime _convertedDate = DateTime(_originalDateTime.year, _originalDateTime.month, _originalDateTime.day);
        bool _addDate = false;
        if(!_dateList.contains(_convertedDate)) {
          _addDate = true;
          _dateList.add(_convertedDate);
        }
        _chatList.add(chatModel);
        _showDate.add(_addDate);
      });
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
  }

  Future<void> sendMessage(String message, String token, int userID, BuildContext context) async {
    PickedFile _imageFile = _file;
    _file = null;
    notifyListeners();
    http.StreamedResponse response = await chatRepo.sendMessage(message, _imageFile, token);
    if (response.statusCode == 200) {
      if(_imageFile != null) {
        getChatList(context);
      }else {
        ChatModel _chatModel = ChatModel(
          userId: userID, image: null, message: message, reply: null,
          createdAt: DateTime.now().toUtc().toIso8601String(),
        );
        DateTime _originalDateTime = DateConverter.isoStringToLocalDate(_chatModel.createdAt);
        DateTime _convertedDate = DateTime(_originalDateTime.year, _originalDateTime.month, _originalDateTime.day);
        bool _addDate = false;
        if(!_dateList.contains(_convertedDate)) {
          _addDate = true;
          _dateList.add(_convertedDate);
        }
        _chatList.add(_chatModel);
        _showDate.add(_addDate);
      }
    } else {
      print('${response.statusCode} ${response.reasonPhrase}');
    }
    _isSendButtonActive = false;
    notifyListeners();
  }

  void toggleSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    notifyListeners();
  }

  void setImage(PickedFile image) {
    _file = image;
    notifyListeners();
  }


  PickedFile _file;
  PickedFile get file => _file;
  final picker = ImagePicker();

  void choosePhotoFromGallery() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _file = pickedFile;
    } else {
      print('No image selected.');
    }
    _isSendButtonActive = true;

    notifyListeners();
  }
  void choosePhotoFromCamera() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _file = pickedFile;
    } else {
      print('No image selected.');
    }
    _isSendButtonActive = true;
    notifyListeners();
  }

  void removeImage(String text) {
    _file = null;
    text.isEmpty ? _isSendButtonActive = false : _isSendButtonActive = true;
    notifyListeners();
  }

}
import 'package:flutter/material.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationProvider extends ChangeNotifier {
  final SharedPreferences sharedPreferences;

  LocalizationProvider({@required this.sharedPreferences}) {
    _loadCurrentLanguage();
  }

  int _languageIndex;
  Locale _locale = Locale(AppConstants.languages[0].languageCode, AppConstants.languages[0].countryCode);
  bool _isLtr = true;

  Locale get locale => _locale;
  bool get isLtr => _isLtr;
  int get languageIndex => _languageIndex;

  void _loadCurrentLanguage() async {
    _locale = Locale(sharedPreferences.getString(AppConstants.LANGUAGE_CODE) ?? AppConstants.languages[0].languageCode,
        sharedPreferences.getString(AppConstants.COUNTRY_CODE) ?? AppConstants.languages[0].countryCode);
    _isLtr = _locale.languageCode != 'ar';
    notifyListeners();
  }

  void _saveLanguage(Locale locale) async {
    sharedPreferences.setString(AppConstants.LANGUAGE_CODE, locale.languageCode);
    sharedPreferences.setString(AppConstants.COUNTRY_CODE, locale.countryCode);
  }


  void setLanguage(Locale locale) {
    _locale = locale;
    if(_locale.languageCode == 'ar') {
      _isLtr = false;
    }else {
      _isLtr = true;
    }
    AppConstants.languages.forEach((language) {
      if(language.languageCode == _locale.languageCode) {
        _languageIndex = AppConstants.languages.indexOf(language);
      }
    });

    _saveLanguage(_locale);
    notifyListeners();
  }
}
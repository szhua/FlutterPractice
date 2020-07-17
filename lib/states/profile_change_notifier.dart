
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_client_app/common/Global.dart';
import 'package:github_client_app/models/index.dart';

class ProfileChangeNotifier extends ChangeNotifier{
   Profile get _profile => Global.profile;
   @override
   void notifyListeners() {
    Global.saveProfile();
    super.notifyListeners();
  }
}


class UserModel extends ProfileChangeNotifier{
    User get user =>_profile.user;
    bool get isLogin => user != null ;
    set user(User user){
      //登录的用户名不相同的情况下;
      if(user?.login != _profile.user?.login){
        _profile.lastLogin = _profile.user?.login;
        _profile.user = user;
        notifyListeners();
      }
    }

}


class ThemeModel extends ProfileChangeNotifier{
   ColorSwatch get theme => Global.themes.firstWhere((e) => e.value==_profile.theme,orElse: ()=>Colors.blue);

   set theme(ColorSwatch color){
     if(color != theme){
       _profile.theme = color[500].value;
       notifyListeners();
     }
   }
}

class LocaleModel extends ProfileChangeNotifier{
    Locale getLocale(){
      if(_profile.locale == null) return null ;
      var t = _profile.locale.split('_');
      return Locale(t[0],t[1]);
    }
    String get locale => _profile.locale;

    set locale(String locale){
      _profile.locale = locale;
      notifyListeners();
    }
}


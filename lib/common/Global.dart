import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github_client_app/common/CacheObject.dart';
import 'package:github_client_app/common/Git.dart';
import 'package:github_client_app/models/cacheConfig.dart';
import 'package:github_client_app/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';


const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

class Global{

    static  SharedPreferences _prefs ;
     static Profile profile = Profile();
    // 可选的主题列表
    static List<MaterialColor> get themes => _themes;
    static NetCache netCache = NetCache();

    static bool get isRelease =>bool.fromEnvironment("dart.vm.product");

    static Future init() async {
      //确认加载完成进行调用；
      WidgetsFlutterBinding.ensureInitialized();
      _prefs = await SharedPreferences.getInstance();
      var _profile =_prefs.get("profile");
      if(_profile!=null){
         try{
           profile =Profile.fromJson(jsonDecode(_profile));
         }catch(e){
           print(e);
         }
      }
      profile.cache =profile.cache??CacheConfig()
      ..enable = true
      ..maxAge =3600
      ..maxCount =100 ;
      Git.init();

    }


    static saveProfile()=>_prefs.setString("profile",jsonEncode(profile.toJson()));



}
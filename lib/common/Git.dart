import 'dart:convert';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:github_client_app/common/Global.dart';
import 'package:github_client_app/models/repo.dart';
import 'package:github_client_app/models/user.dart';

class Git {
  Git([this.context]) {
    _options = Options(extra: {'context': context});
  }

  BuildContext context;
  Options _options;

  static Dio dio =
      new Dio(BaseOptions(baseUrl: 'https://api.github.com/', headers: {
    HttpHeaders.acceptHeader: "application/vnd.github.squirrel-girl-preview,"
        "application/vnd.github.symmetra-preview+json",
  }));

  static void init() {
    dio.interceptors.add(Global.netCache);
    dio.options.headers[HttpHeaders.authorizationHeader] = Global.profile.token;
//    if (!Global.isRelease) {
//      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
//          (client) {
//        client.findProxy = (uri) {
//          return "PROXY 10.95.249.53:8888";
//        };
//        client.badCertificateCallback =
//            (X509Certificate cert, String host, int port) => true;
//      };
//    }
  }

  Future<User> login(String login, String pwd) async {

    String basic = 'Basic ' + base64.encode(utf8.encode('$login:$pwd'));
    var r = await dio.get(
      "/users/$login",
      options: _options.merge(headers: {
        HttpHeaders.authorizationHeader: basic
      }, extra: {
        "noCache": true, //本接口禁用缓存
      }),
    );
    //登录成功后更新公共头（authorization），此后的所有请求都会带上用户身份信息
    dio.options.headers[HttpHeaders.authorizationHeader] = basic;
    //清空所有缓存
    Global.netCache.cache.clear();
    //更新profile中的token信息
    Global.profile.token = basic;
    var user = User.fromJson(r.data);
    return user ;
  }

  Future<List<Repo>> getRepos({Map<String, dynamic> queryParameters, refresh: true}) async {

    if(refresh){
      _options.extra.addAll({"refresh": true, "list": true});
    }
    var r = await dio.get<List>(
      '/user/repos',
      queryParameters: queryParameters,
      options: _options,
    );
    return r.data.map((e)=>Repo.fromJson(e)).toList();

  }
}

import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:github_client_app/common/Global.dart';

class CacheObject {


  CacheObject(this.response):timeStamp=DateTime.now().millisecondsSinceEpoch;


  @override
  bool operator ==(other) {
    return response.hashCode == other.hashCode;
  }


  @override
  int get hashCode {
   return response.realUri.hashCode;
  }

  Response response ;
  int timeStamp ;

}


class NetCache extends Interceptor{
    var cache = LinkedHashMap<String,CacheObject>();


  @override
  Future onRequest(RequestOptions options) async {
    print(options.queryParameters);
    print(options.extra);
    print(options.uri.toString());
    if(!Global.profile.cache.enable) return options ;
    bool refresh = options.extra['refresh'] == true ;
    if(refresh){
       if(options.extra['list']==true){
          cache.removeWhere((key, value) => key.contains(options.path));
       }else{
          delete(options.uri.toString());
       }
       return options ;
    }

    if(options.extra['noCache']!=true && options.method.toLowerCase()== 'get'){
      String key  =options.extra['cacheKey']??options.uri.toString();
      var ob = cache[key] ;
      if(ob!=null){
          if((DateTime.now().millisecondsSinceEpoch-ob.timeStamp)/1000<Global.profile.cache.maxAge){
            return cache[key].response;
          }
      }else{
        cache.remove(key);
      }
    }



  }

    @override
    Future onResponse(Response response)  async {
      if(Global.profile.cache.enable){
        _saveCache(response);
      }
    }
    void delete(String key) {
      cache.remove(key);
    }

  void _saveCache(Response response) {
        RequestOptions options = response.request;
        if(options.extra['noCache']!=true && options.method.toLowerCase()=='get'){
          if(cache.length == Global.profile.cache.maxCount){
            cache.remove(cache[cache.keys.first]);
          }
        }
  }



}

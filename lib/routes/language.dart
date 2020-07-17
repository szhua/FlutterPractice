


import 'package:flutter/material.dart';
import 'package:github_client_app/l10n/localization_intl.dart';
import 'package:github_client_app/states/profile_change_notifier.dart';
import 'package:provider/provider.dart';

class LanguageRoute extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>_LanguageRouteState();
}

class _LanguageRouteState extends  State<LanguageRoute>{
  @override
  Widget build(BuildContext context) {

    var color =Theme.of(context).primaryColor;
    var localeModel =Provider.of<LocaleModel>(context);
    var gm = GmLocalizations.of(context);

    Widget _builLanguageItem(String lan ,value ){
       return ListTile(
          title: Text(
            lan,
            style: TextStyle(color: localeModel.locale==value?color:null),
          ),
         trailing: localeModel.locale == value ? Icon(Icons.done, color: color) : null,
         onTap: (){
            localeModel.locale =value ;
         },
       );
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(gm.language),
      ),
      body: ListView(
        children: <Widget>[
          _builLanguageItem('中文简体', 'zh_CN'),
          _builLanguageItem("English", "en_US"),
          _builLanguageItem(gm.auto, null),
        ],
      ),
    );
  }

}


import 'package:flutter/material.dart';
import 'package:github_client_app/common/Global.dart';
import 'package:github_client_app/l10n/localization_intl.dart';
import 'package:github_client_app/states/profile_change_notifier.dart';
import 'package:provider/provider.dart';

class ThemeChangeRoute extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>_ThemeChangeRouteState();
}

class _ThemeChangeRouteState extends  State<ThemeChangeRoute>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GmLocalizations.of(context).theme),
      ),
      body: ListView(
        children: Global.themes.map<Widget>((e){
          return GestureDetector(
            onTap: (){
              Provider.of<ThemeModel>(context).theme=e;
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
              child: Container(
                  color: e,
                  height: 40,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

}
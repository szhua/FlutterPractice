import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:github_client_app/common/Global.dart';
import 'package:github_client_app/routes/home.dart';
import 'package:github_client_app/routes/login.dart';
import 'package:github_client_app/routes/theme.dart';
import 'package:provider/provider.dart';
import 'l10n/localization_intl.dart';
import 'routes/language.dart';
import 'states/profile_change_notifier.dart';

void main() {
  Global.init().then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
       return MultiProvider(providers: <SingleChildCloneableWidget>[
         ChangeNotifierProvider.value(value: ThemeModel()),
         ChangeNotifierProvider.value(value: UserModel()),
         ChangeNotifierProvider.value(value: LocaleModel()),
       ],
       child: Consumer2<ThemeModel,LocaleModel>(
         builder: (context, themeModel, localeModel, child) {
             return MaterialApp(
                theme: ThemeData(
                  primarySwatch: themeModel.theme
                ),
               onGenerateTitle: (context){
                  return GmLocalizations.of(context).title;
               },
               home: HomeRoute(),
               locale: localeModel.getLocale(),
               supportedLocales: [
                 const Locale('en', 'US'), // 美国英语
                 const Locale('zh', 'CN'), // 中文简体
                 //其它Locales
               ],
               localizationsDelegates: [
                 // 本地化的代理类
                 GlobalMaterialLocalizations.delegate,
                 GlobalWidgetsLocalizations.delegate,
                 GmLocalizationsDelegate()
               ],
               localeResolutionCallback:
                   (Locale _locale, Iterable<Locale> supportedLocales) {
                 if (localeModel.getLocale() != null) {
                   //如果已经选定语言，则不跟随系统
                   return localeModel.getLocale();
                 } else {
                   Locale locale;
                   //APP语言跟随系统语言，如果系统语言不是中文简体或美国英语，
                   //则默认使用美国英语
                   if (supportedLocales.contains(_locale)) {
                     locale= _locale;
                   } else {
                     locale= Locale('en', 'US');
                   }
                   return locale;
                 }
               },
               // 注册命名路由表
               routes: <String, WidgetBuilder>{
                 "login": (context) => LoginRoute(),
                 "themes": (context) => ThemeChangeRoute(),
                 "language": (context) => LanguageRoute(),
               },

             );
         },
       ),
       );
  }
}


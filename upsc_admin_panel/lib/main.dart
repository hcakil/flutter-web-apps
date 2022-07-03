import 'package:admin/blocs/sign_in_bloc.dart';
import 'package:admin/blocs/theme_bloc.dart';
import 'package:admin/blocs/users_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/controllers/MenuController.dart';
import 'package:admin/models/theme_model.dart';
import 'package:admin/screens/login/login_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Future<void> main() async{
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeBloc>(
      create: (_) => ThemeBloc(),
      child: Consumer<ThemeBloc>(
        builder: (_, mode, child){
          return MultiProvider(
            providers: [

              ChangeNotifierProvider<SignInBloc>(create: (context) => SignInBloc(),),
              //   ChangeNotifierProvider<CommentsBloc>(create: (context) => CommentsBloc(),),
              //   ChangeNotifierProvider<BookmarkBloc>(create: (context) => BookmarkBloc(),),
             // ChangeNotifierProvider<SearchBloc>(create: (context) => SearchBloc()),
              //   ChangeNotifierProvider<FeaturedBloc>(create: (context) => FeaturedBloc()),
              //   ChangeNotifierProvider<PopularBloc>(create: (context) => PopularBloc()),
              ChangeNotifierProvider<UsersBloc>(create: (context) => UsersBloc()),
            //  ChangeNotifierProvider<SalesOffersBloc>(create: (context) => SalesOffersBloc()),
              //   ChangeNotifierProvider<AdsBloc>(create: (context) => AdsBloc()),
              //   ChangeNotifierProvider<RelatedBloc>(create: (context) => RelatedBloc()),
             // ChangeNotifierProvider<TabIndexBloc>(create: (context) => TabIndexBloc()),
              //   ChangeNotifierProvider<NotificationBloc>(create: (context) => NotificationBloc()),
              //   ChangeNotifierProvider<CustomNotificationBloc>(create: (context) => CustomNotificationBloc()),
              //   ChangeNotifierProvider<ArticleNotificationBloc>(create: (context) => ArticleNotificationBloc()),
              ChangeNotifierProvider<MenuController>(create: (context) => MenuController()),
              //   ChangeNotifierProvider<CategoryTab1Bloc>(create: (context) => CategoryTab1Bloc()),
              //   ChangeNotifierProvider<CategoryTab2Bloc>(create: (context) => CategoryTab2Bloc()),
              //   ChangeNotifierProvider<CategoryTab3Bloc>(create: (context) => CategoryTab3Bloc()),
              //   ChangeNotifierProvider<CategoryTab4Bloc>(create: (context) => CategoryTab4Bloc()),



            ],
            child: MaterialApp(
               // supportedLocales: context.supportedLocales,
               // localizationsDelegates: context.localizationDelegates,
                //locale: context.locale,
                //  navigatorObservers: [firebaseObserver],

                theme: ThemeModel().lightMode,
                darkTheme: ThemeModel().darkMode,
                themeMode: mode.darkTheme == true ? ThemeMode.dark : ThemeMode.light,
                debugShowCheckedModeBanner: false,
                home: LoginPage()),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import 'hairSalon/screens/BHSplashScreen.dart';
import 'main/store/AppStore.dart';
import 'main/utils/AppConstant.dart';
import 'main/utils/AppTheme.dart';

AppStore appStore = AppStore();

void main() async {
  //region Entry Point
  WidgetsFlutterBinding.ensureInitialized();

  appStore.toggleDarkMode(value: await getBool(isDarkModeOnPref));

  runApp(MyApp());
  //endregion
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '$mainAppName${!isMobile ? ' ${platformName()}' : ''}',
        home: BHSplashScreen(),
        theme: !appStore.isDarkModeOn
            ? AppThemeData.lightTheme
            : AppThemeData.darkTheme,
      ),
    );
  }
}

import 'package:client_store/navigation/store_navigator.dart';
import 'package:flutter/material.dart';
import 'package:lenra_components/theme/lenra_theme.dart';
import 'package:lenra_components/theme/lenra_theme_data.dart';

void main() {
  runApp(const Store());
}

class Store extends StatelessWidget {
  const Store({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeData = LenraThemeData();
    return LenraTheme(
      themeData: themeData,
      child: MaterialApp(
        title: 'Lenra',
        navigatorKey: StoreNavigator.navigatorKey,
        onGenerateInitialRoutes: (initialRoute) =>
            [StoreNavigator.handleGenerateRoute(RouteSettings(name: initialRoute))],
        onGenerateRoute: StoreNavigator.handleGenerateRoute,
        theme: ThemeData(
          textTheme: TextTheme(bodyText2: themeData.lenraTextThemeData.bodyText),
        ),
      ),
    );
  }
}

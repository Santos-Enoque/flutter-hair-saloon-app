import 'dart:io';

// import 'package:admob_flutter/admob_flutter.dart';
import 'package:booking/main/store/AppStore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clustering_google_maps/clustering_google_maps.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:booking/integrations/utils/common.dart';
import 'package:booking/main.dart';
import 'package:booking/main/model/ListModels.dart';

import 'AppColors.dart';
import 'AppConstant.dart';

AppStore appStore = AppStore();

Widget text(
  String text, {
  var fontSize = textSizeLargeMedium,
  Color textColor,
  var fontFamily,
  var isCentered = false,
  var maxLine = 1,
  var latterSpacing = 0.5,
  bool textAllCaps = false,
  var isLongText = false,
  bool lineThrough = false,
}) {
  return Text(
    textAllCaps ? text.toUpperCase() : text,
    textAlign: isCentered ? TextAlign.center : TextAlign.start,
    maxLines: isLongText ? null : maxLine,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontFamily: fontFamily ?? null,
      fontSize: fontSize,
      color: textColor ?? appStore.textSecondaryColor,
      height: 1.5,
      letterSpacing: latterSpacing,
      decoration:
          lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
    ),
  );
}

BoxDecoration boxDecoration(
    {double radius = 2,
    Color color = Colors.transparent,
    Color bgColor,
    var showShadow = false}) {
  return BoxDecoration(
    color: bgColor ?? appStore.scaffoldBackground,
    boxShadow: showShadow
        ? defaultBoxShadow(shadowColor: shadowColorGlobal)
        : [BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

Future<List<LatLngAndGeohash>> getListOfLatLngAndGeoHash(
    BuildContext context) async {
  try {
    final fakeList = await loadDataFromJson(context);
    List<LatLngAndGeohash> myPoints = List();
    for (int i = 0; i < fakeList.length; i++) {
      final fakePoint = fakeList[i];
      final p = LatLngAndGeohash(
        LatLng(fakePoint["LATITUDE"], fakePoint["LONGITUDE"]),
      );
      myPoints.add(p);
    }
    return myPoints;
  } catch (e) {
    throw Exception(e.toString());
  }
}

void changeStatusColor(Color color) async {
  try {
    await FlutterStatusbarcolor.setStatusBarColor(color, animate: true);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(
        useWhiteForeground(color));
  } on Exception catch (e) {
    print(e);
  }
}

Widget commonCacheImageWidget(String url, double height,
    {double width, BoxFit fit}) {
  if (url.validate().startsWith('http')) {
    if (isMobile) {
      return CachedNetworkImage(
        placeholder: placeholderWidgetFn(),
        imageUrl: '$url',
        height: height,
        width: width,
        fit: fit,
      );
    } else {
      return Image.network(url, height: height, width: width, fit: fit);
    }
  } else {
    return Image.asset(url, height: height, width: width, fit: fit);
  }
}

Widget settingItem(context, String text,
    {Function onTap,
    Widget detail,
    Widget leading,
    Color textColor,
    int textSize,
    double padding}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: padding ?? 8, bottom: padding ?? 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                  child: leading ?? SizedBox(),
                  width: 30,
                  alignment: Alignment.center),
              leading != null ? 10.width : SizedBox(),
              Text(text,
                      style: primaryTextStyle(
                          size: textSize ?? 18,
                          color: textColor ?? appStore.textPrimaryColor))
                  .expand(),
            ],
          ).expand(),
          detail ??
              Icon(Icons.arrow_forward_ios,
                  size: 16, color: appStore.textSecondaryColor),
        ],
      ).paddingOnly(left: 16, right: 16, top: 8, bottom: 8),
    ),
  );
}

Widget appBarTitleWidget(context, String title, {Color color}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 60,
    color: color ?? appStore.appBarColor,
    child: Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            style: boldTextStyle(color: appStore.textPrimaryColor, size: 20),
            maxLines: 1,
          ),
        ),
      ],
    ),
  );
}

Widget appBar(BuildContext context, String title,
    {List<Widget> actions,
    bool showBack = true,
    Color color,
    Color iconColor}) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: color ?? appStore.appBarColor,
    leading: showBack
        ? IconButton(
            onPressed: () {
              finish(context);
            },
            icon: Icon(Icons.arrow_back, color: iconColor ?? null),
          )
        : null,
    title: appBarTitleWidget(context, title, color: color),
    actions: actions,
  );
}

class ExampleItemWidget extends StatelessWidget {
  final ListModel tabBarType;
  final Function onTap;
  final bool showTrailing;

  ExampleItemWidget(this.tabBarType,
      {@required this.onTap, this.showTrailing = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: appStore.appBarColor,
      margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
      elevation: 2.0,
      shadowColor: Colors.black,
      child: ListTile(
        onTap: () => onTap(),
        title: Text(tabBarType.name, style: boldTextStyle()),
        trailing: showTrailing
            ? Icon(Icons.arrow_forward_ios,
                size: 15, color: appStore.textPrimaryColor)
            : null,
      ),
    );
  }
}

String convertDate(date) {
  try {
    return date != null
        ? DateFormat(dateFormat).format(DateTime.parse(date))
        : '';
  } catch (e) {
    print(e);
    return '';
  }
}

class CustomTheme extends StatelessWidget {
  final Widget child;

  CustomTheme({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: appStore.isDarkModeOn
          ? ThemeData.dark().copyWith(
              accentColor: appColorPrimary,
              backgroundColor: appStore.scaffoldBackground,
            )
          : ThemeData.light(),
      child: child,
    );
  }
}

Function(BuildContext, String) placeholderWidgetFn() =>
    (_, s) => placeholderWidget();

Widget placeholderWidget() =>
    Image.asset('images/LikeButton/image/grey.jpg', fit: BoxFit.cover);

BoxConstraints dynamicBoxConstraints({double maxWidth}) {
  return BoxConstraints(maxWidth: maxWidth ?? applicationMaxWidth);
}

double dynamicWidth(BuildContext context) {
  return isMobile ? context.width() : applicationMaxWidth;
}

/*class ContainerX extends StatelessWidget {
  static String tag = '/ContainerX';
  final BuildContext context;
  final double maxWidth;
  final Widget child;

  ContainerX({@required this.context, this.maxWidth, @required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      height: context.height(),
      child: ConstrainedBox(
        constraints: dynamicBoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
      alignment: Alignment.topCenter,
    );
  }
}*/

String getBannerAdUnitId() {
  if (kReleaseMode) {
    if (Platform.isIOS) {
      return bannerAdIdForIos;
    } else if (Platform.isAndroid) {
      return bannerAdIdForAndroidRelease;
    }
  } else {
    if (Platform.isIOS) {
      return bannerAdIdForIos;
    } else if (Platform.isAndroid) {
      return bannerAdIdForAndroid;
    }
  }
  return null;
}

String getInterstitialAdUnitId() {
  if (kReleaseMode) {
    if (Platform.isIOS) {
      return interstitialAdIdForIos;
    } else if (Platform.isAndroid) {
      return InterstitialAdIdForAndroidRelease;
    }
  } else {
    if (Platform.isIOS) {
      return interstitialAdIdForIos;
    } else if (Platform.isAndroid) {
      return InterstitialAdIdForAndroid;
    }
  }
  return null;
}

// class AdMobAdWidget extends StatefulWidget {
//   @override
//   AdMobAdWidgetState createState() => AdMobAdWidgetState();
// }

// class AdMobAdWidgetState extends State<AdMobAdWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 60,
//       width: context.width(),
//       alignment: Alignment.center,
//       child: isMobile
//           ? AdmobBanner(
//               adUnitId: getBannerAdUnitId(),
//               adSize: AdmobBannerSize.BANNER,
//             )
//           : SizedBox(),
//     );
//   }
// }

String parseHtmlString(String htmlString) {
  return parse(parse(htmlString).body.text).documentElement.text;
}

// Future<AdmobInterstitial> showInterstitialAd() async {
//   AdmobInterstitial interstitialAd = AdmobInterstitial(
//     adUnitId: getInterstitialAdUnitId(),
//     listener: (AdmobAdEvent event, Map<String, dynamic> args) {},
//   );
//   interstitialAd.load();
//
//   return interstitialAd;
// }

class ContainerX extends StatelessWidget {
  final Widget mobile;
  final Widget web;
  final bool useFullWidth;

  ContainerX({this.mobile, this.web, this.useFullWidth});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.device == DeviceSize.mobile) {
          return mobile ?? SizedBox();
        } else {
          return Container(
            alignment: Alignment.topCenter,
            child: Container(
              constraints: useFullWidth.validate()
                  ? null
                  : dynamicBoxConstraints(maxWidth: context.width() * 0.9),
              child: web ?? SizedBox(),
            ),
          );
        }
      },
    );
  }
}

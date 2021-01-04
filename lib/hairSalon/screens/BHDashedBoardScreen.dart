import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import'package:booking/hairSalon/utils/BHColors.dart';
import'package:booking/hairSalon/utils/BHConstants.dart';
import'package:booking/main/utils/AppWidget.dart';

import 'BHAppointmentScreen.dart';
import 'BHDiscoverScreen.dart';
import 'BHMessagesScreen.dart';
import 'BHNotifyScreen.dart';
import 'BHProfileScreen.dart';

class BHDashedBoardScreen extends StatefulWidget {
  static String tag = '/DashedBoardScreen';

  @override
  BHDashedBoardScreenState createState() => BHDashedBoardScreenState();
}

class BHDashedBoardScreenState extends State<BHDashedBoardScreen> {

  int _selectedIndex = 0;
 var _pages = <Widget>[
    BHDiscoverScreen(),
    BHNotifyScreen(),
    BHAppointmentScreen(),
    BHMessagesScreen(),
    BHProfileScreen(),
  ];

  Widget _bottomTab() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(color: BHColorPrimary),
      selectedItemColor: BHColorPrimary,
      unselectedLabelStyle: TextStyle(color: BHGreyColor),
      unselectedItemColor: BHGreyColor,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), title: Text(BHBottomNavDiscover)),
        BottomNavigationBarItem(icon: Icon(Icons.business), title: Text(BHBottomNavNotify)),
        BottomNavigationBarItem(icon: Icon(Icons.date_range), title: Text(BHBottomNavAppointment)),
        BottomNavigationBarItem(icon: Icon(Icons.message), title: Text(BHBottomNavMessages)),
        BottomNavigationBarItem(icon: Icon(Icons.person), title: Text(BHBottomNavProfile)),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(Colors.white);

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: _bottomTab(),
        body: Center(child: _pages.elementAt(_selectedIndex)),
      ),
    );
  }
}

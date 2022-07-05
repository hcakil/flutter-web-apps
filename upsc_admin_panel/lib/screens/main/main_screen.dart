import 'package:admin/constants.dart';
import 'package:admin/controllers/MenuController.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/components/admin_statistics_widget.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget currentWidget = DashboardScreen();


  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  /*
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }*/


  @override
  Widget build(BuildContext context) {




    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
     // drawer: SideMenu(),
      body: SafeArea(
        child: Container(
          height: context.height(),
          child: Row(
            children: [
              Container(
                width: context.width() * 0.15,
                //   color: Colors.white,
                padding: EdgeInsets.only(left: 16),
                height: context.height(),
                color: bgColor,
                child: SideMenu(
                  onWidgetSelected: (w) {
                    currentWidget = w!;

                    setState(() {});
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16, bottom: 16),
                padding: EdgeInsets.all(16),
                decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.circular(16), backgroundColor: selectedDrawerViewColor),
                width: context.width() * 0.84,
                height: context.height(),
                child: currentWidget,
              ),
            ],
          ),
        ),/*Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: DashboardScreen(),
            ),
          ],
        ),*/
      ),
    );
  }
}

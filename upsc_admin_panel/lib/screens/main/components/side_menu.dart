import 'package:admin/constants.dart';
import 'package:admin/models/list_model.dart';
import 'package:admin/screens/categories/main_category_list.dart';
import 'package:admin/screens/categories/sub_category_list.dart';
import 'package:admin/screens/create_quiz/create_quiz.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:admin/screens/questions/add_new_question.dart';
import 'package:admin/screens/questions/all_questions.dart';
import 'package:admin/screens/user_list/user_list_screen.dart';
import 'package:admin/screens/user_questions/user_questions_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

class SideMenu extends StatefulWidget {

  final Function(Widget?)? onWidgetSelected;
  const SideMenu({
    Key? key, this.onWidgetSelected,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  List<ListModel> list = [];

  int index = 0;
  @override
  void initState() {
    super.initState();
    init();
  }


  Future<void> init() async {
    list.add(ListModel(name: 'Dashboard', widget: DashboardScreen(), imageAsset: 'assets/icons/menu_dashbord.svg'));
    list.add(ListModel(name: 'Admins List', widget: UserListScreen(), imageAsset: 'assets/icons/menu_profile.svg'));
    list.add(ListModel(name: 'Main Categories', widget: CategoryListScreen(), imageAsset: 'assets/icons/menu_task.svg'));
    list.add(ListModel(name: 'Sub Categories', widget: SubCategoryListScreen(), imageAsset: 'assets/icons/menu_tran.svg'));
    list.add(ListModel(name: 'Add Question', widget: AddNewQuestionsScreen(), imageAsset: 'assets/icons/menu_doc.svg'));
    list.add(ListModel(name: 'Questions', widget: AllQuestionsListWidget(), imageAsset: 'assets/icons/menu_store.svg'));
    list.add(ListModel(name: 'Create Quiz', widget: CreateQuizScreen(), imageAsset: 'assets/icons/menu_store.svg'));
    list.add(ListModel(name: 'Category Quiz List', widget: CreateQuizScreen(), imageAsset: 'assets/icons/menu_task.svg'));
    list.add(ListModel(name: 'Admins Actions', widget: UserQuestionsListScreen(), imageAsset: 'assets/icons/menu_profile.svg'));
    LiveStream().on('selectItem', (index) {
      this.index = index as int;

      widget.onWidgetSelected?.call(list[this.index ].widget);

      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose('selectItem');
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Wrap(
          children: list.map(
                (e) {
              int cIndex = list.indexOf(e);

              return SettingItemWidget(
                title: e.name!,
                leading:
                e.iconData != null ? Icon(e.iconData, color: cIndex == index ? primaryColor : Colors.white, size: 24) : SizedBox(
                  height: 24,
                  child: SvgPicture.asset(
                      e.imageAsset!,
                    color: cIndex == index ? primaryColor : Colors.white,
                  ),
                ),//Image.asset(e.imageAsset!, color: cIndex == index ? primaryColor : Colors.white, height: 24),
                titleTextColor: cIndex == index ? primaryColor : Colors.white,
                decoration: BoxDecoration(
                  color: cIndex == index ? selectedDrawerItemColor : null,
                  //  border: Border.all(),
                  borderRadius: cIndex == index - 1
                      ? BorderRadius.only(bottomRight: Radius.circular(24), topLeft: Radius.circular(24), bottomLeft: Radius.circular(24))
                      : cIndex == index  + 1
                      ? BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24), bottomLeft: Radius.circular(24))
                      : BorderRadius.only(topLeft: Radius.circular(24), bottomLeft: Radius.circular(24)),
                ),
                onTap: () {
                  index = list.indexOf(e);
                  widget.onWidgetSelected?.call(e.widget);
                },
              );
            },
          ).toList(),
        ),
      ),
    );

    /*return Drawer(
      backgroundColor: secondaryColor,
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo1.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashbord.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "User List",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Task",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Documents",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Store",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Notification",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Profile",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Settings",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {},
          ),
        ],
      ),
    );*/
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}

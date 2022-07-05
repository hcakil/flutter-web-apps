import 'package:admin/blocs/questions_bloc.dart';
import 'package:admin/blocs/users_bloc.dart';
import 'package:admin/models/my_user.dart';
import 'package:admin/models/question_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';


class AdminStatisticsWidget extends StatefulWidget {
  static String tag = '/AdminStatisticsWidget';

  @override
  _AdminStatisticsWidgetState createState() => _AdminStatisticsWidgetState();
}

class _AdminStatisticsWidgetState extends State<AdminStatisticsWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final QuestionsBloc qb = Provider.of<QuestionsBloc>(context, listen: false);
    final UsersBloc ub = Provider.of<UsersBloc>(context, listen: false);
    Widget itemWidget(Color bgColor, Color textColor, String title, String desc, IconData icon, {Function? onTap}) {
      return Container(
        width: 280,
        height: 135,
        decoration: BoxDecoration(
          border: Border.all(color: context.dividerColor),
          borderRadius: radius(8),
          color: bgColor,
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: secondaryTextStyle(color: textColor, size: 30)),
            16.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(desc, style: primaryTextStyle(size: 24, color: textColor)),
                Icon(icon, color: textColor, size: 30),
              ],
            ),
          ],
        ),
      ).onTap(onTap, borderRadius: radius(16) as BorderRadius);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
            //In here We will add Widget for listing category
              /*  StreamBuilder<List<CategoryData>>(
                stream: categoryService.categories(),
                builder: (_, snap) {
                  if (snap.hasData) {
                    return itemWidget(
                      ThemeData.dark().primaryColorDark,
                      white,
                      'Total Categories',
                      snap.data!.length.toString(),
                      Feather.trending_up,
                      onTap: () {
                       // LiveStream().emit('selectItem', TotalCategories);
                      },
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),*/
              StreamBuilder<List<QuestionModel>>(
                stream: qb.listQuestion(),
                builder: (_, snap) {
                  if (snap.hasData) {
                    return itemWidget(
                      ThemeData.dark().primaryColorDark,
                      white,
                      'Total Questions',
                      snap.data!.length.toString(),
                      Feather.trending_up,
                      onTap: () {
                        //LiveStream().emit('selectItem', TotalQuestions);
                      },
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
              StreamBuilder<List<MyUser>>(
                stream: ub.users(),
                builder: (_, snap) {
                  if (snap.hasData) {
                    return itemWidget(
                      ThemeData.dark().primaryColorDark,
                      white,
                      'Total Users',
                      snap.data!.length.toString(),
                      Feather.users,
                      onTap: () {
                      //  LiveStream().emit('selectItem', TotalUsers);
                      },
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ],
          ),
          16.height,


          ///Graph
          //Top most viewed post
          //New users in last 7 days
          //
        ],
      ),
    );
  }
}

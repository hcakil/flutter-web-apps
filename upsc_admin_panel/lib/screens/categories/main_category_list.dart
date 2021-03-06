import 'package:admin/blocs/questions_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/models/main_category.dart';
import 'package:admin/screens/categories/components/category_item_widget.dart';
import 'package:admin/screens/categories/components/new_main_category_dialog.dart';
import 'package:admin/utils/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';


import '../../main.dart';

class CategoryListScreen extends StatefulWidget {
  static String tag = '/CategoryListScreen';

  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
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
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Main Categories', style: boldTextStyle(size: 22)),
              AppButton(
                padding: EdgeInsets.all(16),
                child: Text('Add Category', style: primaryTextStyle(color: white)),
                color: primaryColor,
                onTap: () {
                  showInDialog(context, child: NewCategoryDialog());
                },
              )
            ],
          ).paddingOnly(left: 16),
          8.height,
          StreamBuilder<List<MainCategoryModel>>(
            stream: qb.mainCategories(),
            builder: (_, snap) {
              if (snap.hasData) {
                if (snap.data!.isEmpty) return noDataWidget();
                return Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: 16,
                  runSpacing: 8,
                  children: snap.data.validate().map((e) {
                    return CategoryItemWidget(data: e);
                  }).toList(),
                );
              } else {
                return snapWidgetHelper(snap);
              }
            },
          ),
        ],
      ),
    );
  }
}

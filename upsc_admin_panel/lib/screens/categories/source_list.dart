import 'package:admin/blocs/questions_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/models/source_list.dart';
import 'package:admin/models/sub_category.dart';
import 'package:admin/screens/categories/components/new_source_list_item_dialog.dart';
import 'package:admin/screens/categories/components/new_sub_category_dialog.dart';
import 'package:admin/screens/categories/components/sub_category_item_widget.dart';
import 'package:admin/utils/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';


import '../../main.dart';
import 'components/source_list_item_widget.dart';

class SourceListScreen extends StatefulWidget {
  static String tag = '/SourceListScreen';

  @override
  _SourceListScreenState createState() => _SourceListScreenState();
}

class _SourceListScreenState extends State<SourceListScreen> {
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
              Text('Source List', style: boldTextStyle(size: 22)),
              AppButton(
                padding: EdgeInsets.all(16),
                child: Text('Add Source List Item', style: primaryTextStyle(color: white)),
                color: secondaryColor,
                onTap: () {
                  showInDialog(context, child: NewSourceListItemDialog());
                },
              )
            ],
          ).paddingOnly(left: 16),
          8.height,
          StreamBuilder<List<SourceListModel>>(
            stream: qb.sourceList(),
            builder: (_, snap) {
              if (snap.hasData) {
                if (snap.data!.isEmpty) return noDataWidget();
                return Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: 16,
                  runSpacing: 8,
                  children: snap.data.validate().map((e) {
                    return SourceListItemWidget(data: e);
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

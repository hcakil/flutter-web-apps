import 'package:admin/blocs/questions_bloc.dart';
import 'package:admin/models/main_category.dart';
import 'package:admin/models/source_list.dart';
import 'package:admin/models/sub_category.dart';
import 'package:admin/screens/categories/components/new_main_category_dialog.dart';
import 'package:admin/screens/categories/components/new_sub_category_dialog.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';


class SourceListItemWidget extends StatefulWidget {
  static String tag = '/SourceListItemWidget';
  final SourceListModel? data;

  SourceListItemWidget({this.data});

  @override
  _SourceListItemWidgetState createState() => _SourceListItemWidgetState();
}

class _SourceListItemWidgetState extends State<SourceListItemWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }
  Future<void> delete() async {
    final QuestionsBloc qb = Provider.of<QuestionsBloc>(context, listen: false);

    await qb.removeSourceListItemDocument(widget.data?.id).then((value) {
      finish(context);
    }).catchError((e) {
      toast(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 200,
          height: 200,
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(16),
          decoration: boxDecorationWithRoundedCorners(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              10.height,
              Text(widget.data!.name!, style: secondaryTextStyle(),overflow: TextOverflow.ellipsis, maxLines: 3, textAlign: TextAlign.center),
            ],
          ),
        ),
        Positioned(
          right: 16,
          top: 16,
          child: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showConfirmDialog(context, 'Do you want to delete this source item?').then((value) {
                if (value ?? false) {
                  delete();
                }
              }).catchError((e) {
                toast(e.toString());
              });
            },
          ),
        )
       /* Positioned(
          right: 16,
          top: 16,
          child: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              showInDialog(context, child: NewSubCategoryDialog(categoryData: widget.data)).then((value) {});
            },
          ),
        ),*/
      ],
    );
  }
}

import 'package:admin/blocs/questions_bloc.dart';
import 'package:admin/models/main_category.dart';
import 'package:admin/models/sub_category.dart';
import 'package:admin/screens/categories/components/new_main_category_dialog.dart';
import 'package:admin/screens/categories/components/new_sub_category_dialog.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';


class SubCategoryItemWidget extends StatefulWidget {
  static String tag = '/CategoryItemWidget';
  final SubCategoryModel? data;

  SubCategoryItemWidget({this.data});

  @override
  _SubCategoryItemWidgetState createState() => _SubCategoryItemWidgetState();
}

class _SubCategoryItemWidgetState extends State<SubCategoryItemWidget> {
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

    await qb.removeSubCategoryDocument(widget.data?.id).then((value) {
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
          height: 240,
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(16),
          decoration: boxDecorationWithRoundedCorners(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(widget.data!.image!, height: 90, width: 90, fit: BoxFit.cover),
              10.height,
              Text( "Main Category : " + widget.data!.mainCategory!, style: boldTextStyle(), maxLines: 2, textAlign: TextAlign.center),
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
              showConfirmDialog(context, 'Do you want to delete this category?').then((value) {
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

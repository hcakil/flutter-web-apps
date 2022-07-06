import 'package:admin/models/main_category.dart';
import 'package:admin/models/sub_category.dart';
import 'package:admin/screens/main_category/components/new_main_category_dialog.dart';
import 'package:admin/screens/main_category/components/new_sub_category_dialog.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';


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
          height: 220,
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
              Text( "Main Category : " + widget.data!.mainCategory!, style: secondaryTextStyle(), maxLines: 2, textAlign: TextAlign.center),
              30.height,
              Text(widget.data!.name!, style: boldTextStyle(), maxLines: 2, textAlign: TextAlign.center),
            ],
          ),
        ),
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

import 'package:admin/constants.dart';
import 'package:admin/models/my_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';


import '../../../main.dart';

class UserItemWidget extends StatefulWidget {
  static String tag = '/UserItemWidget';
  final MyUser data;

  UserItemWidget(this.data);

  @override
  _UserItemWidgetState createState() => _UserItemWidgetState();
}

class _UserItemWidgetState extends State<UserItemWidget> {
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
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
         /* widget.data.image.validate().isNotEmpty
              ? cachedImage(
                  widget.data.image,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ).cornerRadiusWithClipRRect(30)
              :*/ Icon(Feather.user, size: 60),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.data.NameSurname ?? "Name Surname", style: boldTextStyle(color: primaryColor)),
              4.height,
              Text(widget.data.Email ?? "E-mail", style: secondaryTextStyle()),
            ],
          ).expand(),
          Text('Delete', style: boldTextStyle(color: Colors.red)).paddingAll(16).onTap(() {
            showConfirmDialog(context, 'Do you want to delete this user?').then((value) {
              if (value ?? false) {
              /*  if (getBoolAsync(IS_TEST_USER)) return toast(mTestUserMsg);

                userService.removeDocument(widget.data.id).then((value) {
                  toast('Deleted');
                }).catchError((e) {
                  toast(e.toString());
                });*/
              }
            });
          }),
        ],
      ),
    );
  }
}

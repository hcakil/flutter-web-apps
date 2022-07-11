import 'package:admin/blocs/questions_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/models/my_user.dart';
import 'package:admin/models/question_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';


import '../../../main.dart';

class UserQuestionsItemWidget extends StatefulWidget {
  static String tag = '/UserItemWidget';
  final MyUser data;
  final DateTime dateFirst;
  final DateTime dateLast;

  UserQuestionsItemWidget(this.data,this.dateFirst,this.dateLast);

  @override
  _UserQuestionsItemWidgetState createState() => _UserQuestionsItemWidgetState();
}

class _UserQuestionsItemWidgetState extends State<UserQuestionsItemWidget> {

  DateTime? first ;
  DateTime? last ;
  int length = 0;

  //Stream<List<QuestionModel>>? firebaseData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
   DateTime  now = DateTime.now();
   DateTime  yesterday = DateTime.now().subtract(Duration(hours: 24));
    if(widget.dateFirst == null)
      {
        print("widget.dateFirst == null");
        first = yesterday;
      } else {
      first = widget.dateFirst;
      print("first"+ first!.toIso8601String());
    }
   if(widget.dateLast == null)
   {
     print("widget.dateLast == null");
     last = now;
   } else {
     last = widget.dateLast;
     print("last"+ last!.toIso8601String());
   }

   final QuestionsBloc qb = Provider.of<QuestionsBloc>(context, listen: false);

   qb.listQuestionByUserFuture(widget.data, first, last)?.then((value) {
     length = value.length;
     setState(() {
       isLoading = false;
     });
   });


  // final QuestionsBloc qb = Provider.of<QuestionsBloc>(context, listen: false);
   //firebaseData = qb.listQuestionByUser(widget.data,first,last);

  }



  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final QuestionsBloc qb = Provider.of<QuestionsBloc>(context, listen: false);
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
         isLoading ? Center(child: CupertinoActivityIndicator(),): Text( length.toString(), style: boldTextStyle(color: Colors.red)).paddingAll(16)
         ,/*.onTap(() {
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
          }),*/
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'package:admin/constants.dart' as constant;

InputDecoration inputDecoration({String? labelText, String? hintText}) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: secondaryTextStyle(),
    hintText: hintText,
    hintStyle: secondaryTextStyle(),
    border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: gray.withOpacity(0.4), width: 0.3)),
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: gray.withOpacity(0.4), width: 0.3)),
    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red.withOpacity(0.3), width: 0.3)),
    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red.withOpacity(0.3), width: 0.3)),
    alignLabelWithHint: true,
  );
}



String get getTodayQuizDate => DateFormat(constant.CurrentDateFormat).format(DateTime.now());

Widget itemWidget(Color bgColor, Color textColor, String title, String desc) {
  return Container(
    width: 300,
    height: 130,
    decoration: BoxDecoration(border: Border.all(color: gray), borderRadius: radius(8), color: bgColor),
    padding: EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: primaryTextStyle(color: textColor, size: 30)),
        16.height,
        Text(desc, style: primaryTextStyle(size: 24, color: textColor)),
      ],
    ),
  );
}

/*// ignore: non_constant_identifier_names
BorderRadiusGeometry(int index){
  return BoxDecoration(
   index-1 ?BorderRadius.only()
  }

  );
}*/

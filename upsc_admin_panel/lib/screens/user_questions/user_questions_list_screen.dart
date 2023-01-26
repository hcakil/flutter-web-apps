import 'dart:convert';
import 'dart:html';

import 'package:admin/blocs/questions_bloc.dart';
import 'package:admin/blocs/users_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/models/my_user.dart';
import 'package:admin/models/question_model.dart';
import 'package:admin/screens/user_list/components/user_item_widget.dart';
import 'package:admin/screens/user_questions/components/user_questions_item_widget.dart';
import 'package:admin/utils/app_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as syncexcel;


import '../../main.dart';

class UserQuestionsListScreen extends StatefulWidget {
  static String tag = '/UserListScreen';

  @override
  State<UserQuestionsListScreen> createState() => _UserQuestionsListScreenState();
}

class _UserQuestionsListScreenState extends State<UserQuestionsListScreen> {
  DateTime? _firstDate;
  DateTime? _lastDate;
  List<MyUser> adminList = [];
  List<QuestionModel> adminQuestionList = [];

  bool isLoading = false;



  Future pickDateTime(BuildContext context, String dateType) async {
    final date = await pickDate(context, dateType);
    if (date == null) return;


    setState(() {
      if (dateType.contains("_firstDate")) {
        _firstDate = DateTime(
          date.year,
          date.month,
          date.day,

        );
      }
      else if (dateType.contains("_lastDate")) {
        _lastDate = DateTime(
          date.year,
          date.month,
          date.day,

        );
      }
    });
  }

  Future<DateTime> pickDate(BuildContext context, String dateType) async {


    final newDate = await showDatePicker(
      context: context,
      initialDate: dateType.contains("_firstDate")
          ? _firstDate!
          : _lastDate! ,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return DateTime.now();

    return newDate;
  }

  Widget buildDateTimePicker(String dateType) {
    {

      if(dateType.contains("_lastDate")){

        return SizedBox(
          height: 180,
          width: 250,
          child: CupertinoDatePicker(
            initialDateTime:
            dateType.contains("_lastDate") ? _lastDate : _lastDate,
            mode: CupertinoDatePickerMode.dateAndTime,
            minimumDate: DateTime(_lastDate!.year, 2, 1),
            maximumDate: DateTime(_lastDate!.year + 3, 2, 1),
            use24hFormat: true,
            onDateTimeChanged: (dateTime) => setState(() {
              if (dateType.contains("_lastDate"))
                this._lastDate = dateTime;
              else
                this._lastDate = dateTime;
            }),
          ),
        );

      }else{

        return SizedBox(
          height: 180,
          width: 250,
          child: CupertinoDatePicker(
            initialDateTime:
            dateType.contains("_firstDate") ? _firstDate : _firstDate,
            mode: CupertinoDatePickerMode.dateAndTime,
            minimumDate: DateTime(_firstDate!.year, 2, 1),
            maximumDate: DateTime(_firstDate!.year + 3, 2, 1),
            use24hFormat: true,
            onDateTimeChanged: (dateTime) => setState(() {
              if (dateType.contains("_firstDate"))
                this._firstDate = dateTime;
              else
                this._firstDate = dateTime;
            }),
          ),
        );

      }

    }
  }

@override
  void initState() {

    super.initState();
    _lastDate = DateTime.now();
    _firstDate = DateTime.now().subtract(Duration(days: 1));
    getAdminList();

  }

  @override
  Widget build(BuildContext context) {
    final UsersBloc ub = Provider.of<UsersBloc>(context, listen: false);
    return Scaffold(
      appBar: appBarWidget('User Questions', showBack: false, elevation: 0.0),
      body: SingleChildScrollView(

        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  //mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Center(child: Text("Start")),
                    // buildDateTimePicker("PaymentTime"),
                    ElevatedButton(
                      onPressed: () {
                        {
                          pickDateTime(context, "_firstDate");
                        }
                      }, //=> pickDateTime(context),
                      style: ElevatedButton.styleFrom(
                          onPrimary: Colors.purpleAccent,
                          elevation: 18,
                          padding: EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(20))),
                      child: Ink(
                        child: Container(
                          width: 150,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            DateFormat('dd-MM-yyyy')
                                .format(_firstDate!)
                            ,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  //mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Center(child: Text("End Date")),
                    // buildDateTimePicker("PaymentTime"),
                    ElevatedButton(
                      onPressed: () {
                      {
                          pickDateTime(context, "_lastDate");
                        }
                      }, //=> pickDateTime(context),
                      style: ElevatedButton.styleFrom(
                          onPrimary: Colors.purpleAccent,
                          elevation: 18,
                          padding: EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(20))),
                      child: Ink(
                        child: Container(
                          width: 150,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            DateFormat('dd-MM-yyyy')
                                .format(_lastDate!)
                            ,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                TextButton.icon(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.resolveWith(
                              (states) =>
                              EdgeInsets.all(20)),
                      backgroundColor:
                      MaterialStateProperty.resolveWith((states) =>
                      secondaryColor),
                      shape: MaterialStateProperty.resolveWith(
                              (states) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3))),
                    ),
                    icon: Icon(Feather.search,
                        color: Colors.white, size: 20),
                    label: Text(
                        'Filter',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      print("Bul ye basıldı");
                      // nextScreen(context,CommentsPage(timestamp: article.timestamp));
                    //  filterSaleList();
                      setState(() {
                        isLoading = true;
                      });
                      Future.delayed(Duration(seconds: 1)).then((value) =>setState(() {
                        isLoading = false;
                      }));

                      print("finished");
                    }),

                //Report
                TextButton.icon(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.resolveWith(
                              (states) =>
                              EdgeInsets.all(20)),
                      backgroundColor:
                      MaterialStateProperty.resolveWith((states) =>
                      secondaryColor),
                      shape: MaterialStateProperty.resolveWith(
                              (states) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3))),
                    ),
                    icon: Icon(Feather.file_text,
                        color: Colors.white, size: 20),
                    label: Text(
                        'Report',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      print("Bul ye basıldı");
                      adminQuestionList = [];
                      final QuestionsBloc qb = Provider.of<QuestionsBloc>(context, listen: false);


                        for(int i=0;i<adminList.length;i++)
                          {
                           // print( " ----- " + adminList[i].Email.toString() + " ----- ");
                              qb.listQuestionByUserFuture(adminList[i],_firstDate!,_lastDate!)?.then((questions) {
/// TO DO: CSV ÇIKTI REPORT BURADAN ALINCAK VERİ ZATEN ALINIYOR BURDA SADECE ÇIKTIYA BAĞLANACAK
                                print(questions.length.toString() + " bu kadar soru yapmış");
                                adminQuestionList.addAll(questions);


                        });
                          }

                        Future.delayed(Duration(seconds: 10)).then((value) {
                          _createExcel();
                        });




                      print("finished");
                    }),
              ],
            ),
          isLoading ? Center(child: CupertinoActivityIndicator(),) : PaginateFirestore(
              itemBuilderType: PaginateBuilderType.listView,
              itemBuilder: (context, documentSnapshot, index) {
                final data1 = documentSnapshot[index].data() as Map?;
                MyUser data = MyUser.fromMap(documentSnapshot[index].data() as Map<String, dynamic>);

                return InkWell(
                    onTap: (){
                      print(data1!["NameSurname"]);
                    },
                    child: UserQuestionsItemWidget(data,_firstDate!,_lastDate!));
              },
              shrinkWrap: true,
              padding: EdgeInsets.all(8),
              // orderBy is compulsory to enable pagination
              query: ub.getAdminList()!,
              itemsPerPage: DocLimit,
              bottomLoader: Loader(),
              initialLoader: Loader(),
              onEmpty: noDataWidget(),
              onError: (e) => Text(e.toString(), style: primaryTextStyle()).center(),
            ),
          ],
        ),
      ),
    ).cornerRadiusWithClipRRect(16);
  }

  void getAdminList() async{

    final UsersBloc ub = Provider.of<UsersBloc>(context, listen: false);
    ub.getUserList().then((value) {
      adminList = value;
    });
  }

  Future<void> _createExcel() async
  {
    final syncexcel.Workbook workbook = syncexcel.Workbook();

// Accessing sheet via index.
    final syncexcel.Worksheet sheet = workbook.worksheets[0];

//Initialize the list
    final List<Object> listColumn = adminQuestionList.toList();
    final List<String> listColumnEmail = [];
    final List<String> listColumnQuestionId = [];
    final List<String> listColumnQuestionCategory = [];
    final List<String> listColumnQuestionSubCategory = [];
    final List<String> listColumnQuestionSource = [];
    final List<String> listColumnQuestionDate = [];

    adminQuestionList.forEach((element) {
      listColumnEmail.add(element.addedBy ?? "addedBy-null");
      listColumnQuestionId.add(element.id ?? "id-null");
      listColumnQuestionCategory.add(element.category ?? "category-null");
      listColumnQuestionSubCategory.add(element.topic ?? "topic null");
      listColumnQuestionSource.add(element.source ?? "source-null");
      listColumnQuestionDate.add((element.createdAt ?? DateTime.now()).toIso8601String());

    });



    //Initialize the list
    /*final List<Object> list = [
      'Toatal Income',
      20000,
      'On Date',
      DateTime(2021, 1, 1)
    ];*/

    //Column Names
    sheet.getRangeByName('A1').setText('Admin - Email');
    sheet.getRangeByName('B1').setText('Question Id');
    sheet.getRangeByName('C1').setText('Question - Category');
    sheet.getRangeByName('D1').setText('Question - Sub Category');
    sheet.getRangeByName('E1').setText('Question - Source');
    sheet.getRangeByName('F1').setText('Question - Created At');
//Import the Object list to Sheet
    sheet.importList(listColumnEmail, 2, 1, true);
    sheet.importList(listColumnQuestionId, 2, 2, true);
    sheet.importList(listColumnQuestionCategory, 2, 3, true);
    sheet.importList(listColumnQuestionSubCategory, 2, 4, true);
    sheet.importList(listColumnQuestionSource, 2, 5, true);
    sheet.importList(listColumnQuestionDate, 2, 6, true);

// Save and dispose workbook.
    final List<int> bytes = workbook.saveAsStream();

    workbook.dispose();

   //Download the output file
   AnchorElement(
    href:
    "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
   ..setAttribute("download", "output.xlsx")
   ..click();

  }

}

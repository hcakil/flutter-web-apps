import 'package:admin/blocs/questions_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/models/main_category.dart';
import 'package:admin/models/question_model.dart';
import 'package:admin/models/sub_category.dart';
import 'package:admin/screens/questions/add_new_question.dart';
import 'package:admin/utils/app_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';


class AllQuestionsListWidget extends StatefulWidget {

  @override
  AllQuestionsListWidgetState createState() => AllQuestionsListWidgetState();
}

class AllQuestionsListWidgetState extends State<AllQuestionsListWidget> {
  List<MainCategoryModel> categories = [];
  List<MainCategoryModel> categoriesFilter = [];
  List<SubCategoryModel> subcategories = [];
  List<QuestionModel> questionList = [];

  MainCategoryModel? selectedCategoryForFilter;
  SubCategoryModel? selectedSubCategory;
  bool isLoading = false;
  bool isUpdate = false;
  late MainCategoryModel selectedCategory;

  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    loadQuestion();
    final QuestionsBloc qb = Provider.of<QuestionsBloc>(context, listen: false);
    qb.mainCategoriesFuture().then((value) async {
    //  categoriesFilter.add(CategoryData(name: 'All Categories'));

      categories.addAll(value);
      categoriesFilter.addAll(value);

      selectedCategoryForFilter = categoriesFilter.first;

      /// Load categories


      if (categories.isNotEmpty) {

          selectedCategory = categories.first;

      }
      /// Load sub categories
      subcategories = await qb.subCategoriesById(parentCategoryId: selectedCategory.name!);
      if (subcategories.isNotEmpty) {
          selectedSubCategory = subcategories.first;
      }
      setState(() {});
    }).catchError((e) {
      //
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Future<void> loadQuestion({String? categoryRef}) async {
    final QuestionsBloc qb = Provider.of<QuestionsBloc>(context, listen: false);
 setState(() {
   isLoading = true;
 });
    qb.questionListFuture(topicName: categoryRef).then((value) {
      isLoading = false;
      questionList.clear();
      questionList.addAll(value);

      setState(() {
        isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      toast(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final QuestionsBloc qb = Provider.of<QuestionsBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Container(
          height: 150,
          child: Row(
            children: [
              Text('All Questions', style: boldTextStyle()),
              16.width,
              Row(
                children: [
                  if (categories.isNotEmpty)
                    Container(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(borderRadius: radius(), color: Colors.grey.shade200),
                      child: DropdownButton(
                        underline: Offstage(),
                        hint: Text('Please choose a category'),
                        items: categoriesFilter.map((e) {
                          return DropdownMenuItem(child: Text(e.name.validate()), value: e);
                        }).toList(),
                        // isExpanded: true,
                        value: selectedCategoryForFilter,
                        onChanged: (dynamic c) async {
                          selectedCategoryForFilter = c;
                          subcategories = await qb.subCategoriesById(parentCategoryId: selectedCategoryForFilter!.name!);

                          if (subcategories.isNotEmpty) {
                            selectedSubCategory = subcategories.first;
                          }

                          setState(() {});
                          if (selectedCategoryForFilter!.id == null) {
                            loadQuestion();
                          } else if(selectedSubCategory!.id == null) {
                            loadQuestion();
                          }
                          else {
                            loadQuestion(categoryRef: selectedSubCategory!.name);
                          }

                        },
                      ),
                    ),
                  16.width,
                  if (subcategories.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Text('Select Sub Category', style: boldTextStyle(size: 18)),
                       // 8.height,
                        Container(
                          width: context.width() * 0.2,
                          decoration: BoxDecoration(borderRadius: radius(), color: Colors.grey.shade200),
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: DropdownButton(
                            underline: Offstage(),
                            items: subcategories.map((e) {
                              return DropdownMenuItem(child: Text(e.name.validate()), value: e);
                            }).toList(),
                            isExpanded: true,
                            value: selectedSubCategory,
                            onChanged: (dynamic c) {
                              selectedSubCategory = c;


                              if (selectedCategoryForFilter!.id == null) {
                                loadQuestion();
                              } else if(selectedSubCategory!.id == null) {
                                loadQuestion();
                              }
                              else {
                                loadQuestion(categoryRef: selectedSubCategory!.name);
                              }
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  16.width,
                  AppButton(
                    padding: EdgeInsets.all(16),
                    color: primaryColor,
                    child: Text('Search', style: primaryTextStyle(color: white)),
                    onTap: () {
                      print(selectedCategoryForFilter!.name);
                      print(selectedSubCategory!.name);
                     // selectedCategoryForFilter = categoriesFilter.first;
                     // selectedSubCategory = subcategories.first;
                      // selectedQuestionList.clear();
                      if (selectedCategoryForFilter!.id == null) {
                        loadQuestion();
                      } else if(selectedSubCategory!.id == null) {
                        loadQuestion();
                      }
                      else {
                        loadQuestion(categoryRef: selectedSubCategory!.name);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: isLoading ? Center(child: CupertinoActivityIndicator(),): Scrollbar(
        thickness: 5.0,
        controller: controller,
        radius: Radius.circular(16),
        child: PaginateFirestore(
          itemBuilderType: PaginateBuilderType.listView,
          itemBuilder: (context,documentSnapshot,index, ) {
           // final data1 = documentSnapshot[index].data() as Map?;
            QuestionModel data = QuestionModel.fromJson(documentSnapshot[index].data() as Map<String, dynamic>);
            List<String> optionList = [];
            optionList.add(data.option1!);
            optionList.add(data.option2!);
            optionList.add(data.option3!);
            optionList.add(data.option4!);
          //  QuestionModel data = QuestionModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);

            return Container(
              decoration: BoxDecoration(boxShadow: defaultBoxShadow(), color: Colors.white, borderRadius: radius()),
              margin: EdgeInsets.only(bottom: 16, top: 16, right: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.only(top: 8, bottom: 8),
                        decoration: boxDecorationWithRoundedCorners(border: Border.all(color: gray.withOpacity(0.4), width: 0.1)),
                        child: Text('${index + 1}. ${data.question}', style: boldTextStyle(color: secondaryColor, size: 18)),
                      ).expand(),
                      16.width,
                      IconButton(
                        icon: Icon(Icons.edit, color: black),
                        onPressed: () {

                          AddNewQuestionsScreen(data: data).launch(context);
                        },
                      )
                    ],
                  ),
                  16.height,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: optionList.map(
                        (e) {
                          return Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(right: 16),
                            //  width: 100,
                            alignment: Alignment.center,
                            decoration: boxDecorationWithRoundedCorners(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: gray.withOpacity(0.4), width: 0.1),
                            ),
                            child: Text(e, style: secondaryTextStyle(color: black)),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  16.height,
                  Row(
                    children: [
                      Text('Question Id :', style: boldTextStyle(size: 18)),
                      8.width,
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(8),
                        decoration: boxDecorationWithRoundedCorners(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: gray.withOpacity(0.4), width: 0.1),
                        ),
                        child: Text(data.id!, style: boldTextStyle()),
                      ),
                    ],
                  ),
                  16.height,
                  Row(
                    children: [
                      Text('Correct Answer :', style: boldTextStyle(size: 18)),
                      8.width,
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(8),
                        decoration: boxDecorationWithRoundedCorners(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: gray.withOpacity(0.4), width: 0.1),
                        ),
                        child: Text(data.answer!, style: boldTextStyle()),
                      ),
                    ],
                  )
                ],
              ).paddingSymmetric(horizontal: 16, vertical: 16),
            );
          },
          shrinkWrap: true,
          padding: EdgeInsets.all(8),
          query: qb.getQuestions(topicName:  selectedSubCategory != null ? selectedSubCategory!.name :  null),
          itemsPerPage: DocLimit,
          bottomLoader: Loader(),
          initialLoader: Loader(),
          onEmpty: noDataWidget(),
          onError: (e) => Text(e.toString(), style: primaryTextStyle()).center(),
        ),
      ),
    ).cornerRadiusWithClipRRect(16);
  }
}

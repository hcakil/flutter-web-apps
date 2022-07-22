import 'package:admin/blocs/questions_bloc.dart';
import 'package:admin/constants.dart';
import 'package:admin/models/main_category.dart';
import 'package:admin/models/question_model.dart';
import 'package:admin/models/quiz_model.dart';
import 'package:admin/utils/app_widgets.dart';
import 'package:admin/utils/common.dart';
import 'package:async/async.dart';
import 'package:admin/constants.dart' as constant;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';


class CreateQuizScreen extends StatefulWidget {
  final QuizModel? quizData;

  CreateQuizScreen({this.quizData});


  @override
  CreateQuizScreenState createState() => CreateQuizScreenState();
}

class CreateQuizScreenState extends State<CreateQuizScreen> {
  AsyncMemoizer categoryMemoizer = AsyncMemoizer<List<MainCategoryModel>>();
  AsyncMemoizer questionListMemoizer = AsyncMemoizer<List<QuestionModel>>();

  var formKey = GlobalKey<FormState>();

  final dateController = TextEditingController();
  final pointController = TextEditingController();
  final titleController = TextEditingController();
  final imageUrlController = TextEditingController();
  final descriptionController = TextEditingController();

  FocusNode pointFocus = FocusNode();
  FocusNode dateFocus = FocusNode();
  FocusNode imageUrlFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  ScrollController controller = ScrollController();

  bool? _isChecked = false;
  int? selectedTime;

  bool isLoading = true;

  List<QuestionModel> questionList = [];
  List<QuestionModel> selectedQuestionList = [];

  MainCategoryModel? selectedCategoryForFilter;

  MainCategoryModel? selectedCategory;

  bool isUpdate = false;

  List<MainCategoryModel> categoriesFilter = [];
  List<MainCategoryModel> categories = [];

  bool mIsUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
   //Check if there is any quiz is coming or not
     mIsUpdate = widget.quizData != null;

    if (mIsUpdate) {
     // dateController.text = DateFormat(CurrentDateFormat).format(widget.quizData!.createdAt!);
      pointController.text = widget.quizData!.minRequiredPoint.toString();
      titleController.text = widget.quizData!.quizTitle.validate();
      imageUrlController.text = widget.quizData!.imageUrl.validate();
      descriptionController.text = widget.quizData!.description.validate();

      selectedTime = widget.quizData!.quizTime.validate(value: 5);
    }

    loadQuestion();
    final QuestionsBloc qb = Provider.of<QuestionsBloc>(context, listen: false);
    qb.mainCategoriesFuture().then((value) async {


      categories.addAll(value);
      categoriesFilter.addAll(value);

      selectedCategoryForFilter = categoriesFilter.first;

      setState(() {});



      if (categories.isNotEmpty) {
        if (isUpdate) {
          try {
            selectedCategory = await qb.getCategoryById(widget.quizData!.categoryId);

            log(selectedCategory!.name);
          } catch (e) {
            print(e);
          }
        } else {
          selectedCategory = categories.first;
        }
      }

      setState(() {});
    }).catchError((e) {
      //
    });
  }

  Future<void> save() async {
  //  if (getBoolAsync(IS_TEST_USER)) return toast(mTestUserMsg);
    final QuestionsBloc qb = Provider.of<QuestionsBloc>(context, listen: false);

    if (selectedTime == null) {
      return toast('Please Select Quiz time');
    }
    if (formKey.currentState!.validate()) {
      QuizModel quizData = QuizModel();

      quizData.questionRef = selectedQuestionList.map((e) => e.id).cast<String>().toList();
      quizData.minRequiredPoint = pointController.text.toInt();
      quizData.quizTitle = titleController.text.trim();
      quizData.imageUrl = imageUrlController.text.trim();
      quizData.quizTime = selectedTime;
      quizData.description = descriptionController.text.trim();
      //quizData.updatedAt = DateTime.now();

      if (selectedCategory != null) {
        quizData.categoryId = selectedCategory!.id;
      }

      if (mIsUpdate) {
        /// Update
        //quizData.createdAt = widget.quizData!.createdAt;

        await qb.updateDocument(quizData.toJson(), widget.quizData!.id,"categoryQuiz").then((value) {
          toast('Updated');

          finish(context);
        }).catchError((e) {
          toast(e.toString());
        });
      } else  {
        ///Create quiz
       // quizData.createdAt = DateTime.now();

        await qb.addDocument(quizData.toJson(),"categoryQuiz").then((value) {
          toast('Quiz Added');

          dateController.clear();
          pointController.clear();
          titleController.clear();
          imageUrlController.clear();
          descriptionController.clear();

          selectedQuestionList.clear();
          _isChecked = false;
          questionList.forEach((element) {
            element.isChecked = false;
          });
          setState(() {});
        }).catchError((e) {
          log(e);
        });
      }
    }
  }

  Future<void> loadQuestion({String? categoryRef}) async {
    final QuestionsBloc qb = Provider.of<QuestionsBloc>(context, listen: false);
    qb.questionListByCategoryFuture(categoryRef: categoryRef).then((value) {
      isLoading = false;
      questionList.clear();
      questionList.addAll(value);

      setState(() {});
    }).catchError((e) {
      isLoading = false;
      setState(() {});
      toast(e.toString());
    });
  }

  Future<void> updateSelectedQuestion(QuestionModel data, bool? value) async {
    data.isChecked = value;

    if (selectedQuestionList.contains(data)) {
      selectedQuestionList.remove(data);
    } else {
      selectedQuestionList.add(data);
    }

    setState(() {});
  }

  @override
  void dispose() {
    dateController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final QuestionsBloc qb = Provider.of<QuestionsBloc>(context, listen: false);
    return Scaffold(
      appBar: //mIsUpdate ? appBarWidget(widget.quizData!.quizTitle.validate()) :
      null,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter Question By Category', style: boldTextStyle()),
            8.height,
            Row(
              children: [
                if (categories.isNotEmpty)
                  Container(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                      borderRadius: radius(),
                      color: Colors.grey.shade200,
                    ),
                    child: DropdownButton(
                      underline: Offstage(),
                      hint: Text('Please choose a category'),
                      items: categoriesFilter.map((e) {
                        return DropdownMenuItem(
                          child: Text(e.name.validate()),
                          value: e,
                        );
                      }).toList(),
                      isExpanded: true,
                      value: selectedCategoryForFilter,
                      onChanged: (dynamic c) {
                        selectedCategoryForFilter = c;

                        setState(() {});

                        if (selectedCategoryForFilter!.id == null) {
                          loadQuestion();
                        } else {

                          loadQuestion(categoryRef: selectedCategoryForFilter!.name);
                        }
                      },
                    ),
                  ).expand(),
                16.width,
                AppButton(
                  padding: EdgeInsets.all(16),
                  color: secondaryColor,
                  child: Text('Clear', style: primaryTextStyle(color: white)),
                  onTap: () {
                    _isChecked = false;
                    selectedCategoryForFilter = categoriesFilter.first;
                    // selectedQuestionList.clear();
                    loadQuestion();
                  },
                ),
              ],
            ),
            16.height,
            Divider(thickness: 0.5),
            8.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (categories.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Select Category', style: boldTextStyle()),
                      8.height,
                      Container(
                        width: context.width() * 0.45,
                        decoration: BoxDecoration(borderRadius: radius(), color: Colors.grey.shade200),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: DropdownButton(
                          underline: Offstage(),
                          items: categories.map((e) {
                            return DropdownMenuItem(child: Text(e.name.validate()), value: e);
                          }).toList(),
                          isExpanded: true,
                          value: selectedCategory,
                          onChanged: (dynamic c) {
                            selectedCategory = c;
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                8.width,
                AppButton(
                  padding: EdgeInsets.all(16),
                  color: secondaryColor,
                  child: Text('Save', style: primaryTextStyle(color: white)),
                  onTap: () {
                    save();
                  },
                ),
              ],
            ),
            16.height,
            Divider(thickness: 0.5),
            16.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Questions for Create Quiz', style: boldTextStyle()),
                    16.height,
                    Container(
                      width: context.width() * 0.55,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: gray.withOpacity(0.5), width: 0.3)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _isChecked,
                                activeColor: orange,
                                onChanged: (bool? newValue) {
                                  questionList.forEach((element) {
                                    element.isChecked = !_isChecked!;
                                  });

                                  if (_isChecked!) {
                                    selectedQuestionList.clear();
                                  } else {
                                    selectedQuestionList.clear();
                                    selectedQuestionList.addAll(questionList);
                                  }

                                  _isChecked = newValue;

                                  setState(() {});
                                },
                              ),
                              8.width,
                              Text("Question", style: boldTextStyle()),
                            ],
                          ).paddingAll(8),
                          Divider(color: gray, thickness: 0.5, height: 0),
                          Container(
                            height: context.height() * 0.45,
                            decoration: BoxDecoration(color: gray.withOpacity(0.1)),
                            child: Scrollbar(
                              thickness: 5.0,
                              controller: controller,
                              radius: Radius.circular(16),
                              child: PaginateFirestore(
                                itemBuilderType: PaginateBuilderType.listView,
                                itemBuilder: (context, documentSnapshot,index) {
                                  // QuestionData data1 = QuestionData.fromJson(documentSnapshot.data());
                                  QuestionModel data = questionList[index];
                           if(index<questionList.length){
                             return Row(
                               children: [
                                 Checkbox(
                                   activeColor: orange,
                                   value: data.isChecked.validate(),
                                   onChanged: (bool? newValue) {
                                     updateSelectedQuestion(data, newValue);
                                   },
                                 ),
                                 8.width,
                                 Text(data.question!, style: secondaryTextStyle()).expand(),
                               ],
                             ).paddingAll(8).onTap(() {
                               updateSelectedQuestion(data, !data.isChecked!);
                             });
                           }
                           else {
                             return Container();
                           }
                                },
                                shrinkWrap: true,
                                padding: EdgeInsets.all(8),
                                // orderBy is compulsory to enable pagination
                                query: qb.getQuestions(),
                                itemsPerPage: DocLimit,
                                bottomLoader: Loader(),
                                initialLoader: Loader(),
                                onEmpty: noDataWidget(),
                                onError: (e) => Text(e.toString(), style: primaryTextStyle()).center(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).expand(flex: 4),
                16.width,
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Selected Question List', style: boldTextStyle()),
                      16.height,
                      AppTextField(
                        controller: titleController,
                        textFieldType: TextFieldType.NAME,
                        decoration: inputDecoration(labelText: 'Quiz Title'),
                        nextFocus: dateFocus,
                        validator: (s) {
                          if (s!.trim().isEmpty) return constant.errorThisFieldRequired;
                          return null;
                        },
                      ),
                      16.height,
                      Row(
                        children: [
                          AppTextField(
                            controller: pointController,
                            textFieldType: TextFieldType.PHONE,
                            decoration: inputDecoration(labelText: 'Minimum Required point'),
                            focus: pointFocus,
                            nextFocus: imageUrlFocus,
                            validator: (s) {
                              if (s!.trim().isEmpty) return constant.errorThisFieldRequired;
                              return null;
                            },
                          ).expand(),
                          16.width,
                          DropdownButtonFormField(
                            hint: Text('Quiz Time', style: secondaryTextStyle()),
                            value: selectedTime,
                            items: List.generate(
                              12,
                              (index) {
                                return DropdownMenuItem(
                                  value: (index + 1) * 5,
                                  child: Text('${(index + 1) * 5} Minutes', style: primaryTextStyle()),
                                );
                              },
                            ),
                            onChanged: (dynamic value) {
                              selectedTime = value;
                            },
                            decoration: inputDecoration(),
                          ).expand(),
                        ],
                      ),
                      16.height,
                      AppTextField(
                        controller: imageUrlController,
                        textFieldType: TextFieldType.NAME,
                        decoration: inputDecoration(labelText: 'Image URL'),
                        focus: imageUrlFocus,
                        nextFocus: descriptionFocus,
                        validator: (s) {
                          if (s!.isEmpty) return constant.errorThisFieldRequired;
                          if (!s.validateURL()) return 'URL is invalid';
                          return null;
                        },
                      ),
                      16.height,
                      AppTextField(
                        controller: descriptionController,
                        textFieldType: TextFieldType.NAME,
                        maxLines: 3,
                        minLines: 3,
                        decoration: inputDecoration(labelText: 'Description'),
                        focus: descriptionFocus,
                        isValidationRequired: false,
                      ),
                      8.height,
                      Container(
                        width: context.width() * 0.5,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: selectedQuestionList.length,
                          itemBuilder: (_, index) {
                            QuestionModel data = selectedQuestionList[index];

                            return Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16),
                                  margin: EdgeInsets.symmetric(vertical: 2),
                                  decoration: BoxDecoration(color: gray.withOpacity(0.1)),
                                  child: Row(
                                    children: [
                                      8.width,
                                      Text('${index + 1}', style: secondaryTextStyle()),
                                      16.width,
                                      Text(data.question!, maxLines: 3, overflow: TextOverflow.ellipsis, style: secondaryTextStyle()).expand(),
                                    ],
                                  ),
                                ),
                                Align(
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    margin: EdgeInsets.only(right: 16, top: 4),
                                    decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.circular(8), backgroundColor: secondaryColor),
                                    child: IconButton(
                                      icon: Icon(Icons.clear, size: 16, color: white),
                                      onPressed: () {
                                        updateSelectedQuestion(data, !data.isChecked!);
                                        if (selectedQuestionList.contains(data)) {
                                          selectedQuestionList.remove(data);
                                        }
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  alignment: Alignment.centerRight,
                                ).paddingOnly(top: 8),
                              ],
                            );
                          },
                        ),
                      )
                    ],
                  ).expand(flex: 6),
                )
              ],
            ),
            16.height,
          ],
        ).paddingAll(16),
      ),
    ).cornerRadiusWithClipRRect(16);
  }
}

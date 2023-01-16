import 'dart:html';
import 'dart:typed_data';
import 'package:admin/blocs/questions_bloc.dart';
import 'package:admin/blocs/sign_in_bloc.dart';
import 'package:admin/constants.dart' as constant;
import 'package:admin/models/main_category.dart';
import 'package:admin/models/question_model.dart';
import 'package:admin/models/source_list.dart';
import 'package:admin/models/sub_category.dart';
import 'package:admin/utils/common.dart';
import 'package:admin/utils/snackbar.dart';
import 'package:async/async.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddNewQuestionsScreen extends StatefulWidget {
  final QuestionModel? data;

  AddNewQuestionsScreen({this.data});

  @override
  AddQuestionsScreenState createState() => AddQuestionsScreenState();
}

class AddQuestionsScreenState extends State<AddNewQuestionsScreen> {
  var formKey = GlobalKey<FormState>();
  AsyncMemoizer categoryMemorizer = AsyncMemoizer<List<MainCategoryModel>>();

  var scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isReady = true;

  List<String> options = [];
  List<String> optionsImages = [];

  String questionType = constant.QuestionTypeOption;

  String? correctAnswer;

  String addedBy = "";

  String option1 = 'Answer 1 is empty';
  String option2 = 'Answer 2 is empty';
  String option3 = 'Answer 3 is empty';
  String option4 = 'Answer 4 is empty';
  String option1Img = '';
  String option2Img = '';
  String option3Img = '';
  String option4Img = '';
  String source = 'Source';
  String description = 'Description';
  String descriptionImg = '';
  bool? isOnlySuperAdmin;

  PickedFile? image;

  int? questionTypeGroupValue = 1;
  MainCategoryModel? selectedCategory;
  SourceListModel? selectedSourceListItem;
  SubCategoryModel? selectedSubCategory;

  List<MainCategoryModel> categories = [];
  List<SourceListModel> sourceList = [];
  List<SubCategoryModel> subcategories = [];

  bool isUpdate = false;

  TextEditingController questionCont = TextEditingController();
  TextEditingController questionImgCont = TextEditingController();
  TextEditingController option1Cont = TextEditingController();
  TextEditingController option2Cont = TextEditingController();
  TextEditingController option3Cont = TextEditingController();
  TextEditingController option4Cont = TextEditingController();
  TextEditingController option1ImgCont = TextEditingController();
  TextEditingController option2ImgCont = TextEditingController();
  TextEditingController option3ImgCont = TextEditingController();
  TextEditingController option4ImgCont = TextEditingController();
  TextEditingController sourceCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();
  TextEditingController descriptionImgCont = TextEditingController();

  FocusNode option1Focus = FocusNode();
  FocusNode option2Focus = FocusNode();
  FocusNode option3Focus = FocusNode();
  FocusNode option4Focus = FocusNode();
  FocusNode sourceFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isUpdate = widget.data != null;

    if (isUpdate) {
      questionCont.text = widget.data!.question.validate();

      if (widget.data!.id != null) {
        questionTypeGroupValue = 1;
      }
      //For Further Developments
      /*
      else if (widget.data!.questionType == QuestionTypeTrueFalse) {
        questionTypeGroupValue = 2;
      } else if (widget.data!.questionType == QuestionTypePuzzle) {
        questionTypeGroupValue = 3;
      } else if (widget.data!.questionType == QuestionTypePoll) {
        questionTypeGroupValue = 4;
      }*/

      if (widget.data!.option1!.length > 0)
        option1Cont.text = widget.data!.option1.validate();
      if (widget.data!.option2!.length > 0)
        option2Cont.text = widget.data!.option2.validate();
      if (widget.data!.option3!.length > 0)
        option3Cont.text = widget.data!.option3.validate();
      if (widget.data!.option4!.length > 0)
        option4Cont.text = widget.data!.option4.validate();
      /* if (widget.data!.optionList!.length > 1) option2Cont.text = widget.data!.optionList![1].validate();
      if (widget.data!.optionList!.length > 2) option3Cont.text = widget.data!.optionList![2].validate();
      if (widget.data!.optionList!.length > 3) option4Cont.text = widget.data!.optionList![3].validate();
      if (widget.data!.optionList!.length > 4) option5Cont.text = widget.data!.optionList![4].validate();*/

      sourceCont.text = widget.data!.source.validate();
      descriptionCont.text = widget.data!.description.validate();
      // correctAnswer = widget.data!.answer.validate();

      questionImgCont.text = widget.data!.questionImage.validate();
      descriptionImgCont.text = widget.data!.descriptionImage.validate();

      option1ImgCont.text = widget.data!.optionImage1.validate();
      option2ImgCont.text = widget.data!.optionImage2.validate();
      option3ImgCont.text = widget.data!.optionImage3.validate();
      option4ImgCont.text = widget.data!.optionImage4.validate();

      if (widget.data!.option1!.length > 0)
        option1 = widget.data!.option1.validate();
      if (widget.data!.option2!.length > 0)
        option2 = widget.data!.option2.validate();
      if (widget.data!.option3!.length > 0)
        option3 = widget.data!.option3.validate();
      if (widget.data!.option4!.length > 0)
        option4 = widget.data!.option4.validate();
      //if (widget.data!.optionList!.length > 4) option5 = widget.data!.optionList![4].validate();
    }
    else {
      option1ImgCont.text = option1Img;
      option2ImgCont.text = option2Img;
      option3ImgCont.text = option3Img;
      option4ImgCont.text = option4Img;
      questionImgCont.text = "";
      descriptionImgCont.text = descriptionImg;
    }
    final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);
    addedBy = sb.email;

    sb.getDataFromSp().then((value) {
      if (sb.email.contains("operations@conqueststaffingsystems.com")) {
        isOnlySuperAdmin = true;
      }
    });


    /// Load main categories
    final QuestionsBloc qb = Provider.of<QuestionsBloc>(context, listen: false);
    categories = await qb.mainCategoriesFuture();
    sourceList = await qb.sourceListFuture();

    if (sourceList.isNotEmpty) {
      if (isUpdate) {
        try {
          selectedSourceListItem =
              sourceList.firstWhere((element) => element.name ==
                  widget.data!.sourceListItem);
        } catch (e) {
          print(e);
        }
      } else {
        selectedSourceListItem = sourceList.first;
      }
    }

    if (categories.isNotEmpty) {
      if (isUpdate) {
        try {
          selectedCategory = categories.firstWhere((element) => element.name ==
              widget.data!.category);
        } catch (e) {
          print(e);
        }
      } else {
        selectedCategory = categories.first;
      }

      /// Load sub categories

      subcategories =
      await qb.subCategoriesById(parentCategoryId: selectedCategory!.name!);

      if (subcategories.isNotEmpty) {
        if (isUpdate) {
          try {
            selectedSubCategory =
                subcategories.firstWhere((element) => element.name ==
                    widget.data!.topic);
          } catch (e) {
            print(e);
          }
        } else {
          selectedSubCategory = subcategories.first;
        }
      }
    }


    setState(() {});
  }

  Future<void> save() async {
    // if (getBoolAsync(IS_TEST_USER)) return toast(mTestUserMsg);

    if (correctAnswer == null) {
      return toast('Please Select Correct Answer');
    }
    if (selectedCategory == null) {
      return toast('Please Select Main Category');
    }
    if (selectedSourceListItem == null) {
      return toast('Please Select Source List Item');
    }
    if (selectedSubCategory == null) {
      return toast('Please Select Sub Category');
    }

    if (formKey.currentState!.validate()) {
      QuestionModel questionData = QuestionModel();

      options.clear();
      optionsImages.clear();

      //  if (questionType == QuestionTypeOption) {
      if (option1Cont.text
          .trim()
          .isNotEmpty) options.add(option1Cont.text.trim());
      if (option2Cont.text
          .trim()
          .isNotEmpty) options.add(option2Cont.text.trim());
      if (option3Cont.text
          .trim()
          .isNotEmpty) options.add(option3Cont.text.trim());
      if (option4Cont.text
          .trim()
          .isNotEmpty) options.add(option4Cont.text.trim());

      if (option1ImgCont.text
          .trim()
          .isNotEmpty) optionsImages.add(option1ImgCont.text.trim());
      if (option2ImgCont.text
          .trim()
          .isNotEmpty) optionsImages.add(option2ImgCont.text.trim());
      if (option3ImgCont.text
          .trim()
          .isNotEmpty) optionsImages.add(option3ImgCont.text.trim());
      if (option4ImgCont.text
          .trim()
          .isNotEmpty) optionsImages.add(option4ImgCont.text.trim());
      //    if (option5Cont.text.trim().isNotEmpty) options.add(option5Cont.text.trim());
      /*    } else {
        if (option1Cont.text.trim().isNotEmpty) options.add(option1Cont.text.trim());
        if (option2Cont.text.trim().isNotEmpty) options.add(option2Cont.text.trim());
      }*/


      questionData.question = questionCont.text.trim();
      questionData.questionImage = questionImgCont.text.trim();
      questionData.source = sourceCont.text.trim();
      questionData.description = descriptionCont.text.trim();
      questionData.descriptionImage = descriptionImgCont.text.trim();
      questionData.answer = correctAnswer;
      questionData.addedBy = addedBy;
      questionData.updatedAt = DateTime.now();
      questionData.option1 = options[0];
      questionData.option2 = options[1];
      questionData.option3 = options[2];
      questionData.option4 = options[3];
      if (optionsImages.isNotEmpty) {
        questionData.optionImage1 = optionsImages[0];
        questionData.optionImage2 = optionsImages[1];
        questionData.optionImage3 = optionsImages[2];
        questionData.optionImage4 = optionsImages[3];
      }

      if (selectedCategory != null) {
        questionData.category = selectedCategory!
            .name; //categoryService.ref!.doc(selectedCategory!.id);
      }
      if (selectedSourceListItem != null) {
        questionData.sourceListItem = selectedSourceListItem!
            .name;
      }
      if (selectedSubCategory != null) {
        questionData.topic = selectedSubCategory!.name;
      }
      final QuestionsBloc qb = Provider.of<QuestionsBloc>(
          context, listen: false);
      if (isUpdate) {
        questionData.id = widget.data!.id;
        questionData.createdAt = widget.data!.createdAt;

        await qb.updateDocument(
            questionData.toJson(), questionData.id, "questions").then((value) {
          toast('Update Successfully');
          finish(context);
        }).catchError((e) {
          toast(e.toString());
        });
      } else {
        questionData.createdAt = DateTime.now();

        qb.addDocument(questionData.toJson(), "questions").then((value) {
          toast('Add Question Successfully');

          options.clear();
          optionsImages.clear();

          option1Cont.clear();
          option2Cont.clear();
          option3Cont.clear();
          option4Cont.clear();
          option1ImgCont.clear();
          option2ImgCont.clear();
          option3ImgCont.clear();
          option4ImgCont.clear();
          sourceCont.clear();
          questionCont.clear();
          questionImgCont.clear();
          descriptionCont.clear();
          descriptionImgCont.clear();

          setState(() {});
        }).catchError((e) {
          log(e);
        });
      }
    }
  }

  Future<void> _showMyDialog() async {
    final QuestionsBloc qb = Provider.of<QuestionsBloc>(context, listen: false);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Text('Do you want to delete this question?'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                finish(context);
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                //if (getBoolAsync(IS_TEST_USER)) return toast(mTestUserMsg);

                qb.removeDocument(widget.data!.id, "questions").then((value) {
                  toast('Delete Successfully');
                  finish(context);
                  finish(context);
                }).catchError((e) {
                  toast(e.toString());
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> uploadImg(String s) async {
    try {
      final QuestionsBloc qb = Provider.of<QuestionsBloc>(
          context, listen: false);
      FilePickerResult? result;
      String pathString;
      setState(() {
        isReady = false;
      });
      result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ["jpg", "png"]
      );

      if (result != null) {
        Uint8List? uploadFile = result.files.single.bytes;

        Reference ref = FirebaseStorage.instance
            .ref()
            .child('questionImages')
            .child(Uuid().v1());

        UploadTask uploadTask = ref.putData(uploadFile!);
        uploadTask.whenComplete(() async {
          pathString = await uploadTask.snapshot.ref.getDownloadURL();
          if (s.contains("Question Image")) {
            questionImgCont.text = pathString;
            print("came here");
            print(questionImgCont.text);
            setState(() {
              isReady = true;
            });
          }
          else if (s.contains("A Image")) {
            option1ImgCont.text = pathString;
            print("came here");
            print(option1ImgCont.text);
            setState(() {
              isReady = true;
            });
          }
          else if (s.contains("B Image")) {
            option2ImgCont.text = pathString;
            print("came here");
            print(option2ImgCont.text);
            setState(() {
              isReady = true;
            });
          }
          else if (s.contains("C Image")) {
            option3ImgCont.text = pathString;
            print("came here");
            print(option3ImgCont.text);
            setState(() {
              isReady = true;
            });
          } else if (s.contains("D Image")) {
            option4ImgCont.text = pathString;
            print("came here");
            print(option4ImgCont.text);
            setState(() {
              isReady = true;
            });
          }
          else if (s.contains("Description")) {
            descriptionImgCont.text = pathString;
            print("came here");
            print(descriptionImgCont.text);
            setState(() {
              isReady = true;
            });
          }
          else {
            print("not question here");
          }
        });
      }
      else {
        setState(() {
          isReady = true;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isReady = true;
      });
      openSnackbar(scaffoldKey, "Error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    options.clear();
    if (questionType == constant.QuestionTypeOption) {
      if (option1Cont.text
          .trim()
          .isNotEmpty) options.add(option1Cont.text.trim());
      if (option2Cont.text
          .trim()
          .isNotEmpty) options.add(option2Cont.text.trim());
      if (option3Cont.text
          .trim()
          .isNotEmpty) options.add(option3Cont.text.trim());
      if (option4Cont.text
          .trim()
          .isNotEmpty) options.add(option4Cont.text.trim());
      // if (descriptionCont.text.trim().isNotEmpty) options.add(de.text.trim());
    } else {
      if (option1Cont.text
          .trim()
          .isNotEmpty) options.add(option1Cont.text.trim());
      if (option2Cont.text
          .trim()
          .isNotEmpty) options.add(option2Cont.text.trim());
    }
    final QuestionsBloc qb = Provider.of<QuestionsBloc>(context, listen: false);
    return Scaffold(
      backgroundColor: white,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0.0,
        leading: isUpdate
            ? IconButton(
          icon: Icon(Icons.arrow_back, color: black),
          onPressed: () {
            finish(context);
          },
        )
            : null,
        title: Row(
          children: [
            Text('Question for Quiz', style: boldTextStyle()),
            8.width,
            Text(!isUpdate ? 'Create New Question' : 'Update Question',
                style: secondaryTextStyle()),
          ],
        ),
        actions: [
          isUpdate
              ? Visibility(
            visible: isOnlySuperAdmin ?? false,
            child: IconButton(
              icon: Icon(Icons.delete_forever, color: black),
              onPressed: () {
                _showMyDialog();
              },
            ).paddingOnly(right: 8),
          )
              : SizedBox(),
        ],
      ),
      body: isReady ? SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (categories.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Select Main Category', style: boldTextStyle(size: 18)),
                    8.height,
                    Container(
                      width: context.width() * 0.45,
                      decoration: BoxDecoration(
                          borderRadius: radius(), color: Colors.grey.shade200),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: DropdownButton(
                        underline: Offstage(),
                        items: categories.map((e) {
                          return DropdownMenuItem(
                              child: Text(e.name.validate()), value: e);
                        }).toList(),
                        isExpanded: true,
                        value: selectedCategory,
                        onChanged: (dynamic c) async {
                          selectedCategory = c;

                          /// Load sub categories

                          subcategories = await qb.subCategoriesById(
                              parentCategoryId: selectedCategory!.name!);

                          if (subcategories.isNotEmpty) {
                            selectedSubCategory = subcategories.first;
                          }
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              16.height,
              if (subcategories.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Sub Category', style: boldTextStyle(size: 18)),
                    8.height,
                    Container(
                      width: context.width() * 0.45,
                      decoration: BoxDecoration(
                          borderRadius: radius(), color: Colors.grey.shade200),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: DropdownButton(
                        underline: Offstage(),
                        items: subcategories.map((e) {
                          return DropdownMenuItem(
                              child: Text(e.name.validate()), value: e);
                        }).toList(),
                        isExpanded: true,
                        value: selectedSubCategory,
                        onChanged: (dynamic c) {
                          selectedSubCategory = c;

                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              16.height,
              AppTextField(
                controller: questionCont,
                textFieldType: TextFieldType.NAME,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 2,
                minLines: 1,
                decoration: inputDecoration(labelText: 'Question'),
                validator: (s) {
                  if (s!.trim().isEmpty) return constant.errorThisFieldRequired;
                  return null;
                },
              ),
              16.height,
              AppTextField(
                controller: questionImgCont,
                textFieldType: TextFieldType.NAME,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 2,
                minLines: 1,
                decoration: inputDecoration(labelText: 'Question Image'),
                validator: (s) {
                  //  if (s!.trim().isEmpty) return constant.errorThisFieldRequired;
                  return null;
                },
              ),
              16.height,
              AppButton(
                padding: EdgeInsets.all(16),
                child: Text('Upload Question Image',
                    style: primaryTextStyle(color: white)),
                color: constant.bgColor,
                onTap: () {
                  //save();
                  uploadImg("Question Image");
                  //Burada REsim yükleme işi yapılacak tek bir method sadece geliş yerine göre yüklenen texti  hangi textcont
                  //atayacağımızı bilsek kâfî.
                },
              ),

              16.height,
              Row(
                children: [
                  Row(
                    children: [
                      Text('A', style: boldTextStyle()),
                      8.width,
                      AppTextField(
                        controller: option1Cont,
                        focus: option1Focus,
                        nextFocus: option2Focus,
                        textFieldType: TextFieldType.NAME,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: inputDecoration(),
                        keyboardType: TextInputType.url,
                        enabled: questionTypeGroupValue == 1,
                        onChanged: (s) {
                          option1 = s;
                          setState(() {});
                        },
                        validator: (s) {
                          if (s!.trim().isEmpty)
                            return constant.errorThisFieldRequired;
                          return null;
                        },
                      ).expand(),
                    ],
                  ).expand(),
                  16.width,
                  Row(
                    children: [
                      Text('B', style: boldTextStyle()),
                      8.width,
                      AppTextField(
                        controller: option2Cont,
                        focus: option2Focus,
                        nextFocus: option3Focus,
                        textFieldType: TextFieldType.NAME,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: inputDecoration(),
                        keyboardType: TextInputType.url,
                        enabled: questionTypeGroupValue == 1,
                        onChanged: (s) {
                          option2 = s;
                          setState(() {});
                        },
                        validator: (s) {
                          if (s!.trim().isEmpty)
                            return constant.errorThisFieldRequired;
                          return null;
                        },
                      ).expand(),
                    ],
                  ).expand(),
                ],
              ),
              16.height,
              Row(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 55,
                        width: 100,
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(5)

                        ),
                        child: AppButton(
                          padding: EdgeInsets.all(16),
                          child: Text('Upload A Image',
                              style: primaryTextStyle(color: white)),
                          color: constant.bgColor,
                          onTap: () {
                            uploadImg("A Image");
                            //save();
                            //Burada REsim yükleme işi yapılacak tek bir method sadece geliş yerine göre yüklenen texti  hangi textcont
                            //atayacağımızı bilsek kâfî.
                          },
                        ),
                      ),
                      8.width,
                      AppTextField(
                        controller: option1ImgCont,
                        textFieldType: TextFieldType.NAME,

                        textCapitalization: TextCapitalization.sentences,
                        decoration: inputDecoration(labelText: 'A Image URL'),
                        keyboardType: TextInputType.url,
                        enabled: questionTypeGroupValue == 1,
                        onChanged: (s) {
                          option1ImgCont.text = s;
                          setState(() {});
                        },
                        validator: (s) {
                          // if (s!.trim().isEmpty) return constant.errorThisFieldRequired;
                          return null;
                        },
                      ).expand(),
                    ],
                  ).expand(),
                  16.width,
                  Row(
                    children: [
                      //Text('Upload B Image', style: boldTextStyle()),
                      Container(
                        height: 55,
                        width: 100,
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(5)

                        ),
                        child: AppButton(
                          padding: EdgeInsets.all(16),
                          child: Text('Upload B Image',
                              style: primaryTextStyle(color: white)),
                          color: constant.bgColor,
                          onTap: () {
                            uploadImg("B Image");
                            //save();
                            //Burada REsim yükleme işi yapılacak tek bir method sadece geliş yerine göre yüklenen texti  hangi textcont
                            //atayacağımızı bilsek kâfî.
                          },
                        ),
                      ),
                      8.width,
                      AppTextField(
                        controller: option2ImgCont,
                        textFieldType: TextFieldType.NAME,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: inputDecoration(labelText: 'B Image URL'),
                        keyboardType: TextInputType.url,
                        enabled: questionTypeGroupValue == 1,
                        onChanged: (s) {
                          option2ImgCont.text = s;
                          setState(() {});
                        },
                        validator: (s) {
                          //  if (s!.trim().isEmpty) return constant.errorThisFieldRequired;
                          return null;
                        },
                      ).expand(),
                    ],
                  ).expand(),
                ],
              ),
              16.height,
              Row(
                children: [
                  Row(
                    children: [
                      Text('C', style: boldTextStyle()),
                      8.width,
                      AppTextField(
                        controller: option3Cont,
                        focus: option3Focus,
                        nextFocus: option4Focus,
                        textFieldType: TextFieldType.NAME,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: inputDecoration(),
                        keyboardType: TextInputType.url,
                        isValidationRequired: false,
                        onChanged: (s) {
                          option3 = s;
                          setState(() {});
                        },
                        validator: (s) {
                          if (s!.trim().isEmpty)
                            return constant.errorThisFieldRequired;
                          return null;
                        },
                      ).expand(),
                    ],
                  ).expand(),
                  16.width,
                  Row(
                    children: [
                      Text('D', style: boldTextStyle()),
                      8.width,
                      AppTextField(
                        controller: option4Cont,
                        focus: option4Focus,
                        nextFocus: descriptionFocus,
                        textFieldType: TextFieldType.NAME,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: inputDecoration(),
                        keyboardType: TextInputType.url,
                        isValidationRequired: false,
                        onChanged: (s) {
                          option4 = s;
                          setState(() {});
                        },
                        validator: (s) {
                          if (s!.trim().isEmpty)
                            return constant.errorThisFieldRequired;
                          return null;
                        },
                      ).expand(),
                    ],
                  ).expand(),

                ],
              ).visible(questionTypeGroupValue != 2),
              16.height,
              Row(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 55,
                        width: 100,
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(5)

                        ),
                        child: AppButton(
                          padding: EdgeInsets.all(16),
                          child: Text('Upload C Image',
                              style: primaryTextStyle(color: white)),
                          color: constant.bgColor,
                          onTap: () {
                            uploadImg("C Image");
                            //save();
                            //Burada REsim yükleme işi yapılacak tek bir method sadece geliş yerine göre yüklenen texti  hangi textcont
                            //atayacağımızı bilsek kâfî.
                          },
                        ),
                      ),
                      8.width,
                      AppTextField(
                        controller: option3ImgCont,
                        textFieldType: TextFieldType.NAME,

                        textCapitalization: TextCapitalization.sentences,
                        decoration: inputDecoration(labelText: 'C Image URL'),
                        keyboardType: TextInputType.url,
                        enabled: questionTypeGroupValue == 1,
                        onChanged: (s) {
                          option3ImgCont.text = s;
                          setState(() {});
                        },
                        validator: (s) {
                          //   if (s!.trim().isEmpty) return constant.errorThisFieldRequired;
                          return null;
                        },
                      ).expand(),
                    ],
                  ).expand(),
                  16.width,
                  Row(
                    children: [
                      //Text('Upload B Image', style: boldTextStyle()),
                      Container(
                        height: 55,
                        width: 100,
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(5)

                        ),
                        child: AppButton(
                          padding: EdgeInsets.all(16),
                          child: Text('Upload D Image',
                              style: primaryTextStyle(color: white)),
                          color: constant.bgColor,
                          onTap: () {
                            uploadImg("D Image");
                            //save();
                            //Burada REsim yükleme işi yapılacak tek bir method sadece geliş yerine göre yüklenen texti  hangi textcont
                            //atayacağımızı bilsek kâfî.
                          },
                        ),
                      ),
                      8.width,
                      AppTextField(
                        controller: option4ImgCont,
                        textFieldType: TextFieldType.NAME,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: inputDecoration(labelText: 'D Image URL'),
                        keyboardType: TextInputType.url,
                        enabled: questionTypeGroupValue == 1,
                        onChanged: (s) {
                          option4ImgCont.text = s;
                          setState(() {});
                        },
                        validator: (s) {
                          //   if (s!.trim().isEmpty) return constant.errorThisFieldRequired;
                          return null;
                        },
                      ).expand(),
                    ],
                  ).expand(),
                ],
              ),
              16.height,
              Row(
                children: [
                  Row(
                    children: [
                      Text('Description', style: boldTextStyle()),
                      8.width,
                      AppTextField(
                        controller: descriptionCont,
                        focus: descriptionFocus,
                        textFieldType: TextFieldType.NAME,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: inputDecoration(),
                        keyboardType: TextInputType.url,
                        onChanged: (s) {
                          description = s;
                          setState(() {});
                        },
                        isValidationRequired: false,
                        validator: (s) {
                          return null;
                        },
                      ).expand(),
                    ],
                  ).expand(),
                  16.width,
                  SizedBox().expand()
                ],
              ).visible(questionTypeGroupValue != 2),
              16.height,
              Row(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 55,
                        width: 150,
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(5)

                        ),
                        child: AppButton(
                          padding: EdgeInsets.all(16),
                          child: Text('Upload Description Img',
                              style: primaryTextStyle(color: white)),
                          color: constant.bgColor,
                          onTap: () {
                            uploadImg("Description");
                            //save();
                            //Burada REsim yükleme işi yapılacak tek bir method sadece geliş yerine göre yüklenen texti  hangi textcont
                            //atayacağımızı bilsek kâfî.
                          },
                        ),
                      ),
                      8.width,
                      AppTextField(
                        controller: descriptionImgCont,
                        textFieldType: TextFieldType.NAME,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: inputDecoration(
                            labelText: "Description Image URL"),
                        keyboardType: TextInputType.url,
                        onChanged: (s) {
                          descriptionImgCont.text = s;
                          descriptionImg = s;
                          setState(() {});
                        },
                        isValidationRequired: false,
                        validator: (s) {
                          return null;
                        },
                      ).expand(),
                    ],
                  ).expand(),
                  16.width,
                  SizedBox().expand()
                ],
              ).visible(questionTypeGroupValue != 2),
              16.height,
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Select Correct Answer', style: boldTextStyle()),
                      8.height,
                      Container(
                        decoration: BoxDecoration(borderRadius: radius(),
                            color: Colors.grey.shade200),
                        padding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: Offstage(),
                          hint: Text('Select Correct Answer'),
                          value: correctAnswer,
                          onChanged: (newValue) {
                            correctAnswer = newValue;

                            setState(() {});
                          },
                          items: options.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value.validate(value: '')),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ).expand(),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add Source Details ', style: boldTextStyle()),
                      8.height,
                      AppTextField(
                        controller: sourceCont,
                        textFieldType: TextFieldType.NAME,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 3,
                        minLines: 1,
                        decoration: inputDecoration(labelText: 'Source Details'),
                        isValidationRequired: false,
                      ),
                    ],
                  ).expand(),
                ],
              ),
              Row(
                children: [
                  if (sourceList.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Select Source List Item', style: boldTextStyle(size: 18)),
                        8.height,
                        Container(
                          width: context.width() * 0.45,
                          decoration: BoxDecoration(
                              borderRadius: radius(), color: Colors.grey.shade200),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          child: DropdownButton(
                            underline: Offstage(),
                            items: sourceList.map((e) {
                              return DropdownMenuItem(
                                  child: Text(e.name.validate()), value: e);
                            }).toList(),
                            isExpanded: true,
                            value: selectedSourceListItem,
                            onChanged: (dynamic c) async {
                              selectedSourceListItem = c;

                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              16.height,
              AppButton(
                padding: EdgeInsets.all(16),
                child: Text(isUpdate ? 'Save' : 'Create Now',
                    style: primaryTextStyle(color: white)),
                color: constant.primaryColor,
                onTap: () {
                  save();
                },
              )
            ],
          ).paddingAll(16),
        ),
      ) : Center(child: CupertinoActivityIndicator(),),
    ).cornerRadiusWithClipRRect(16);
  }


}

import 'package:admin/blocs/questions_bloc.dart';
import 'package:admin/blocs/users_bloc.dart';
import 'package:admin/models/main_category.dart';
import 'package:admin/models/sub_category.dart';
import 'package:admin/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';


import '../../../main.dart';

class NewSubCategoryDialog extends StatefulWidget {
  static String tag = '/NewCategoryDialog';
  final SubCategoryModel? categoryData;

  NewSubCategoryDialog({this.categoryData});

  @override
  _NewSubCategoryDialogState createState() => _NewSubCategoryDialogState();
}

class _NewSubCategoryDialogState extends State<NewSubCategoryDialog> {
  var formKey = GlobalKey<FormState>();

  TextEditingController nameCont = TextEditingController();
  TextEditingController imageCont = TextEditingController();

  FocusNode imageFocus = FocusNode();

  bool isUpdate = false;

  List<MainCategoryModel> categories = [];
  List<MainCategoryModel> categoriesFilter = [];
   MainCategoryModel? selectedCategoryForFilter;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final QuestionsBloc qb = Provider.of<QuestionsBloc>(context, listen: false);
    isUpdate = widget.categoryData != null;

    if (isUpdate) {
      nameCont.text = widget.categoryData!.name!;
      imageCont.text = widget.categoryData!.image!;
    }

    qb.mainCategoriesFuture().then((value) async {
     // categoriesFilter.add(CategoryData(name: 'All Categories'));

      categories.addAll(value);
      categoriesFilter.addAll(value);

      selectedCategoryForFilter = categoriesFilter.first;

      setState(() {});

      /// Load categories
   /*   categories = await categoryService.categoriesFuture();

      if (categories.isNotEmpty) {
        if (isUpdate) {
          try {
            selectedCategory = await categoryService.getCategoryById(widget.quizData!.categoryId);

            log(selectedCategory.name);
          } catch (e) {
            print(e);
          }
        } else {
          selectedCategory = categories.first;
        }
      }

      setState(() {});*/
    }).catchError((e) {
      //
    });
  }

  Future<void> save() async {

    final QuestionsBloc qb = Provider.of<QuestionsBloc>(context, listen: false);
    if (formKey.currentState!.validate()) {
      SubCategoryModel categoryData = SubCategoryModel();

      categoryData.name = nameCont.text.trim();
      categoryData.image = imageCont.text.trim();
      categoryData.mainCategory = selectedCategoryForFilter!.name!.trim();
      categoryData.updatedAt = DateTime.now();
      // categoryData.parentCategoryId = '';

      if (isUpdate) {
        categoryData.id = widget.categoryData!.id;
        categoryData.createdAt = widget.categoryData!.createdAt;
      } else {
        categoryData.createdAt = DateTime.now();
      }

      if (isUpdate) {
        await qb.updateCategoryDocument(categoryData.toJson(), categoryData.id).then((value) {
          finish(context);
        }).catchError((e) {
          toast(e.toString());
        });
      } else {
        await qb.addSubCategoryDocument(categoryData.toJson()).then((value) {
          toast('Add Category Successfully');
          finish(context);
        }).catchError((e) {
          toast(e.toString());
        });
      }
    }
  }

  Future<void> delete() async {
    final QuestionsBloc qb = Provider.of<QuestionsBloc>(context, listen: false);

    await qb.removeCategoryDocument(widget.categoryData!.id).then((value) {
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
    return Form(
      key: formKey,
      child: Container(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (categories.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Main Category :  "),
                    Container(
                      padding: EdgeInsets.only(left: 8, right: 8,),
                      decoration: BoxDecoration(borderRadius: radius(), color: Colors.grey.shade200),
                      child: DropdownButton(
                        underline: Offstage(),
                        hint: Text('Please choose a main category'),
                        items: categoriesFilter.map((e) {
                          return DropdownMenuItem(child: Text(e.name.validate()), value: e);
                        }).toList(),
                        // isExpanded: true,
                        value: selectedCategoryForFilter,
                        onChanged: (dynamic c) {
                          selectedCategoryForFilter = c;

                          setState(() {});

                        /*  if (selectedCategoryForFilter!.id == null) {
                            loadQuestion();
                          } else {
                            loadQuestion(categoryRef: categoryService.ref!.doc(selectedCategoryForFilter!.id));
                          }*/
                        },
                      ),
                    ),
                  ],
                ),
              16.height,
              AppTextField(
                controller: nameCont,
                textFieldType: TextFieldType.NAME,
                nextFocus: imageFocus,
                decoration: inputDecoration(labelText: 'Sub Category Name'),
                autoFocus: true,
              ),
              16.height,
              AppTextField(
                controller: imageCont,
                textFieldType: TextFieldType.OTHER,
                focus: imageFocus,
                decoration: inputDecoration(labelText: 'Image URL'),
                keyboardType: TextInputType.url,
                validator: (s) {
                  if (s!.isEmpty) return errorThisFieldRequired;
                  if (!s.validateURL()) return 'URL is invalid';
                  return null;
                },
              ),
              16.height,
              AppButton(
                text: 'Delete',
                padding: EdgeInsets.all(20),
                onTap: () {
                  showConfirmDialog(context, 'Do you want to delete this category?').then((value) {
                    if (value ?? false) {
                      delete();
                    }
                  }).catchError((e) {
                    toast(e.toString());
                  });
                },
              ).visible(isUpdate),
              16.height,
              AppButton(
                text: 'Save',
                width: context.width(),
                padding: EdgeInsets.all(20),
                onTap: () {
                  save();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

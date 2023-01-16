import 'package:admin/blocs/questions_bloc.dart';
import 'package:admin/blocs/users_bloc.dart';
import 'package:admin/models/main_category.dart';
import 'package:admin/models/source_list.dart';
import 'package:admin/models/sub_category.dart';
import 'package:admin/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';


import '../../../main.dart';

class NewSourceListItemDialog extends StatefulWidget {
  static String tag = '/NewCategoryDialog';
  final SourceListModel? sourceListItemData;

  NewSourceListItemDialog({this.sourceListItemData});

  @override
  _NewSourceListItemDialogState createState() => _NewSourceListItemDialogState();
}

class _NewSourceListItemDialogState extends State<NewSourceListItemDialog> {
  var formKey = GlobalKey<FormState>();

  TextEditingController nameCont = TextEditingController();




  bool isUpdate = false;


  List<MainCategoryModel> categoriesFilter = [];
   MainCategoryModel? selectedCategoryForFilter;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final QuestionsBloc qb = Provider.of<QuestionsBloc>(context, listen: false);
    isUpdate = widget.sourceListItemData != null;

    if (isUpdate) {
      nameCont.text = widget.sourceListItemData!.name!;
    }
  }

  Future<void> save() async {

    final QuestionsBloc qb = Provider.of<QuestionsBloc>(context, listen: false);
    if (formKey.currentState!.validate()) {
      SourceListModel sourceListItem = SourceListModel();

      sourceListItem.name = nameCont.text.trim();

      sourceListItem.updatedAt = DateTime.now();
      // sourceListItem.parentCategoryId = '';

      if (isUpdate) {
        sourceListItem.id = widget.sourceListItemData!.id;
        sourceListItem.createdAt = widget.sourceListItemData!.createdAt;
      } else {
        sourceListItem.createdAt = DateTime.now();
      }

      if (isUpdate) {
        await qb.updateSourceListItemDocument(sourceListItem.toJson(), sourceListItem.id).then((value) {
          finish(context);
        }).catchError((e) {
          toast(e.toString());
        });
      } else {
        await qb.addSourceListItemDocument(sourceListItem.toJson()).then((value) {
          toast('Add Source List Item Successfully');
          finish(context);
        }).catchError((e) {
          toast(e.toString());
        });
      }
    }
  }

  Future<void> delete() async {
    final QuestionsBloc qb = Provider.of<QuestionsBloc>(context, listen: false);

    await qb.removeSourceListItemDocument(widget.sourceListItemData!.id).then((value) {
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
              AppTextField(
                controller: nameCont,
                textFieldType: TextFieldType.NAME,
                decoration: inputDecoration(labelText: 'Source Item Name'),
                autoFocus: true,
              ),
              16.height,
              AppButton(
                text: 'Delete',
                padding: EdgeInsets.all(20),
                onTap: () {
                  showConfirmDialog(context, 'Do you want to delete this source item?').then((value) {
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

import 'package:admin/blocs/questions_bloc.dart';
import 'package:admin/models/quiz_model.dart';
import 'package:admin/screens/quiz_list/components/quiz_item_widget.dart';
import 'package:admin/utils/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';


class QuizListScreen extends StatefulWidget {
  static String tag = '/QuizListScreen';

  @override
  _QuizListScreenState createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
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
    final QuestionsBloc qb = Provider.of<QuestionsBloc>(context, listen: false);
    return Scaffold(
      body: FutureBuilder<List<QuizModel>>(
        future: qb.quizListCategory,
        builder: (_, snap) {
          if (snap.hasData) {
            if (snap.data!.isEmpty) return noDataWidget();

            return SingleChildScrollView(
              padding: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 60),
              child: Wrap(
                children: snap.data!.map((e) => QuizItemWidget(e)).toList(),
              ),
            );
          } else {
            return snapWidgetHelper(snap);
          }
        },
      ),
    ).cornerRadiusWithClipRRect(16);
  }
}

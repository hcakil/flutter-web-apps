import 'package:admin/utils/model_keys.dart';


class QuizModel {
  String? categoryId;
  String? id;
  String? imageUrl;
  String? description;
  int? quizTime;
  int? minRequiredPoint;
  List<String>? questionRef;
  String? quizTitle;

  QuizModel({this.categoryId, this.id, this.imageUrl, this.minRequiredPoint, this.questionRef, this.quizTitle, this.description, this.quizTime});

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json[CommonKeys.id],
      categoryId: json[QuizKeys.categoryId],
      imageUrl: json[QuizKeys.imageUrl],
      minRequiredPoint: json[QuizKeys.minRequiredPoint],
      questionRef: json[QuizKeys.questionRef] != null ? new List<String>.from(json[QuizKeys.questionRef]) : null,
      quizTitle: json[QuizKeys.quizTitle],
      description: json[QuizKeys.description],
      quizTime: json[QuizKeys.quizTime],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[CommonKeys.id] = this.id;
    data[QuizKeys.categoryId] = this.categoryId;
    data[QuizKeys.imageUrl] = this.imageUrl;
    data[QuizKeys.minRequiredPoint] = this.minRequiredPoint;
    data[QuizKeys.quizTitle] = this.quizTitle;
    data[QuizKeys.description] = this.description;
    data[QuizKeys.quizTime] = this.quizTime;
    if (this.questionRef != null) {
      data[QuizKeys.questionRef] = this.questionRef;
    }
    return data;
  }
}

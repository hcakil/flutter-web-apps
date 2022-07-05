

import 'package:admin/utils/model_keys.dart';

class QuestionModel {
  String? question;
  String? questionImage;
  String? source;
  String? topic;
  String? userName;
  String? optionImage1;
  String? optionImage2;
  String? optionImage3;
  String? optionImage4;
  String? option1;
  String? option2;
  String? option3;
  String? option4;
  String? answer;
  String? id;
  String? description;
  String? addedBy;
  String? category;
  String? descriptionImage;
 // int? selectedOptionIndex;
 // List<String>? optionList;
  String? selectedAnswer;


  QuestionModel({
      this.question,
      this.questionImage,
      this.source,
      this.topic,
      this.category,
      this.userName,
      this.optionImage1,
      this.optionImage2,
      this.optionImage3,
      this.optionImage4,
      this.option1,
      this.option2,
      this.option3,
      this.option4,
      this.answer,
      this.id,
      this.description,
      this.addedBy,
      this.descriptionImage,
      this.selectedAnswer});

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      question: json[QuestionKeys.question],
      questionImage: json[QuestionKeys.questionImage],
      source: json[QuestionKeys.source],
      topic: json[QuestionKeys.topic],
      userName: json[QuestionKeys.userName],
      optionImage1: json[QuestionKeys.optionImage1],
      optionImage2: json[QuestionKeys.optionImage2],
      optionImage3: json[QuestionKeys.optionImage3],
      optionImage4: json[QuestionKeys.optionImage4],
      option1: json[QuestionKeys.option1],
      option2: json[QuestionKeys.option2],
      option3: json[QuestionKeys.option3],
      option4: json[QuestionKeys.option4],
      answer: json[QuestionKeys.answer],
      id: json[QuestionKeys.id] is int ? (json[QuestionKeys.id] as int).toString() : json[QuestionKeys.id],
      description: json[QuestionKeys.description],
      addedBy: json[QuestionKeys.addedBy],
      descriptionImage: json[QuestionKeys.descriptionImage],
      selectedAnswer: json[QuestionKeys.selectedAnswer],
      category: json[QuestionKeys.category],

     // optionList: json[QuestionKeys.optionList] != null ? new List<String>.from(json[QuestionKeys.optionList]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[QuestionKeys.question] = this.question;
    data[QuestionKeys.id] = this.id;
    data[QuestionKeys.questionImage] = this.questionImage;
    data[QuestionKeys.answer] = this.answer;
    data[QuestionKeys.category] = this.category;
    data[QuestionKeys.selectedAnswer] = this.selectedAnswer;
    data[QuestionKeys.descriptionImage] = this.descriptionImage;
    data[QuestionKeys.addedBy] = this.addedBy;
    data[QuestionKeys.description] = this.description;
    data[QuestionKeys.option1] = this.option1;
    data[QuestionKeys.option2] = this.option2;
    data[QuestionKeys.option3] = this.option3;
    data[QuestionKeys.option4] = this.option4;
    data[QuestionKeys.optionImage1] = this.optionImage1;
    data[QuestionKeys.optionImage2] = this.optionImage2;
    data[QuestionKeys.optionImage3] = this.optionImage3;
    data[QuestionKeys.optionImage4] = this.optionImage4;
    data[QuestionKeys.userName] = this.userName;
    data[QuestionKeys.topic] = this.topic;
    data[QuestionKeys.source] = this.source;



    return data;
  }
}

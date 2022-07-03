
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void nextScreen (context, page){
  Navigator.push(context, MaterialPageRoute(
    builder: (context) => page));
}


void nextScreeniOS (context, page){
  Navigator.push(context, CupertinoPageRoute(
    builder: (context) => page));
}


void nextScreenCloseOthers (context, page){
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => page), (route) => false);
}

void nextScreenReplace (context, page){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
}


void nextScreenPopup (context, page){
  Navigator.push(context, MaterialPageRoute(
    fullscreenDialog: true,
    builder: (context) => page),
  );
}




/*
void navigateToDetailsScreenByReplace (context, Article article, String? heroTag, bool? replace){
  if(replace == null || replace == false){
    navigateToDetailsScreen(context, article, heroTag);
  }else{
    if(article.contentType == 'video'){
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => VideoArticleDetails(data: article)),
      );
    
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => ArticleDetails(data: article, tag: heroTag,)),
      );
    }
  }
}*/

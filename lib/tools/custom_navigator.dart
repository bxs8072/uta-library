import 'package:flutter/material.dart';

void customNavigator(BuildContext context, Widget widget) {
  //Navigate to the page provided into widget from current widget
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) {
        return widget;
      },
    ),
  );
}

void customReplaceNavigator(BuildContext context, Widget widget) {
  //Navigate to the page provided into widget from current widget
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) {
        return widget;
      },
    ),
  );
}

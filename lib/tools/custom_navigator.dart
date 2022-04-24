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

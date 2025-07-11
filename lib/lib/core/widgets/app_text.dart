import 'package:flutter/material.dart';



class AppText extends StatelessWidget {
  final String text;
  final  TextStyle? style;
   final int? maxLines;
   const AppText(this.text, {super.key, this.style,
     this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines??100,
      style: style,
    );
  }
}

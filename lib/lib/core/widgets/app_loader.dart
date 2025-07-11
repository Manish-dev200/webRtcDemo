import 'package:flutter/material.dart';
import 'package:voice_call_demo/lib/core/constants/app_colors.dart';



class AppLoader extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
      height:MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black38,
        child: Center(child: Container(
          height: 100,
            width: 100,
            decoration: BoxDecoration(color: AppColors.colorPrimary),
            child: Center(child: CircularProgressIndicator(color: AppColors.colorWhite,)))));
  }
}

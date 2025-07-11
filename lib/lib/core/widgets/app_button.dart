
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../dimentions/app_dimentions.dart';
import 'app_text.dart';



class AppButton extends StatelessWidget {
  String text;
  EdgeInsets? margin;
  double? width;
  Function()? onTap;
   AppButton(this.text, {super.key, this.margin,this.width, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(onTap!=null){
          onTap!.call();
        }
      },
      child: Container(
        margin: margin,
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 7 ),
        width:width?? AppDimensions.screenWidth(context),
        decoration: BoxDecoration(
          color: AppColors.colorPrimary,
              borderRadius: BorderRadius.circular(10)
        ),
        child: Center(child: AppText(text,style: TextStyle(fontWeight: FontWeight.w600,color: AppColors.colorWhite,fontSize: 16))),
      ),
    );
  }
}

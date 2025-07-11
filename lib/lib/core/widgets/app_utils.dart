import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'app_text.dart';

class AppUtils {

  AppBar commonAppBar(
      BuildContext context,
      String getTitle,
      {bool? action=false}){
    return AppBar(
      backgroundColor: AppColors.colorPrimary,
      title: AppText(getTitle,style:Theme.of(context).textTheme.bodyLarge),
      actions: [
        if(action==true)...{
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.notifications,

            ),
          )
        }

      ],
    );
  }

}

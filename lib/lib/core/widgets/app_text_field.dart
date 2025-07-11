import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'app_text.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String value)? onChanged;
  final Function()? suffixIconPress;
  final String? hint;
  final String? title;
  final EdgeInsets? margin;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLength;

  AppTextField({
    required this.controller,
    this.onChanged,
    this.suffixIconPress,
    this.hint,
    this.title,
    this.margin,
    this.validator, this.keyboardType, this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if(title!=null)...{
            AppText(title!,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16)),
          },

          FormField<String>(
            validator: validator,
            builder: (FormFieldState<String> fieldState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: fieldState.hasError ? AppColors.colorError : Colors.transparent,
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.09),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: controller,
                      onChanged: onChanged,
                       maxLength:maxLength ,
                       keyboardType: keyboardType,
                      decoration: InputDecoration(
                        counter: SizedBox(),
                        hintText: hint??'Enter here',
                        prefixIcon: const Icon(Icons.keyboard),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),

                      ),
                    ),
                  ),
                  if (fieldState.hasError)
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 6),
                      child: AppText(
                        fieldState.errorText ?? '',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              );
            },

          ),
        ],
      ),
    );
  }
}

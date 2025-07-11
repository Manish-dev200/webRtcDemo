import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voice_call_demo/lib/core/dimentions/app_dimentions.dart';
import 'package:voice_call_demo/lib/core/routes/route_paths.dart';
import 'package:voice_call_demo/lib/core/widgets/app_button.dart';
import 'package:voice_call_demo/lib/core/widgets/app_text.dart';
import 'package:voice_call_demo/lib/core/widgets/app_text_field.dart';
import 'package:voice_call_demo/lib/presentation/notifier/auth_notifier.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_loader.dart';
import '../../domain/providers/auth_provider.dart';

class RegisterUserPage extends ConsumerStatefulWidget {
  const RegisterUserPage({super.key});

  @override
  ConsumerState<RegisterUserPage> createState() => _RegisterUserState();
}

class _RegisterUserState extends ConsumerState<RegisterUserPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);
    final vm = ref.read(authNotifierProvider.notifier);
    getRefListener();
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.colorBackgroundLight,
          body: Stack(
            children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppDimensions.leftRightPadding),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 70,),
                          AppText("User Detail",style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),),
                          SizedBox(height: 50,),
                          AppTextField(
                            controller: state.nameTextField,
                            title: "Name",
                            hint: "Enter your name",
                            validator: (value) {
                              if (state.nameTextField.text.isEmpty) {
                                return 'User name is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15,),
                      
                          AppTextField(
                            controller: state.phoneTextField,
                            title: "Phone",
                            hint: "Enter your phone",
                            keyboardType: TextInputType.numberWithOptions(decimal: false),
                            maxLength:12,
                            validator: (value) {
                              if (state.nameTextField.text.isEmpty) {
                                return 'User phone is required';
                              }
                              return null;
                            },
                          ),
                      
                          SizedBox(height: 100,),
                          AppButton("Submit",
                            onTap: (){
                              if(_formKey.currentState!.validate()){

                                vm.addUser();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              if(state.isLoading)...{
                AppLoader(),
              }


            ],
          )),
    );


  }

  void getRefListener() {
    ref.listen(authNotifierProvider, (previous, next) {
      if (next.success==true) {
        context.pushReplacementNamed(RoutePaths.home);
      } else if (next.error==''||next.error==null) {

      }
    });
  }
}

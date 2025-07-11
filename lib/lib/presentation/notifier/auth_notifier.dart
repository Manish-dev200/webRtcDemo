import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_call_demo/lib/core/local_db/app_local_storage.dart';
import 'package:voice_call_demo/lib/core/network/app_credentials.dart';
import 'package:voice_call_demo/lib/data/firebase_data_source.dart';

class AuthState {
  final bool isLoading;
  final TextEditingController nameTextField;
  final TextEditingController phoneTextField;
  final bool success;
  final String? error;


  AuthState( {
    required this.nameTextField,
    required this.phoneTextField,
    this.isLoading = false,
    this.success=false,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    TextEditingController? prodNameTextField,
    TextEditingController? prodDescTextField,
    bool? success,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      nameTextField: prodNameTextField ?? nameTextField,
      phoneTextField: prodDescTextField ?? phoneTextField,
      success:success ?? this.success,
        error:error ?? this.error
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  FirebaseDataSource firebaseDataSource;
  AppLocalStorage localDbProvider;
  AuthNotifier({required this.firebaseDataSource, required this.localDbProvider}) : super(AuthState(
    nameTextField:TextEditingController(),
    phoneTextField:TextEditingController(),
  )) {
  }



  Future<void> addUser() async {
    try{
      var name=state.nameTextField.text;
      var phone=state.phoneTextField.text;
      state =state.copyWith(isLoading: true,success: false,error: null);
      var response=await firebaseDataSource.addUser(name,phone);
      if(response!=''){
        state=state.copyWith(isLoading: false,success:true);
        localDbProvider.setUserId(response);
      }
    }catch(e){
      state=state.copyWith(isLoading: false,success:false,error:e.toString());
    }finally{
      state =state.copyWith(isLoading: false,success: false,error: null);
    }

  }
}

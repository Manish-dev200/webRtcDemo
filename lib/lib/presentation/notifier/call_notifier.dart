import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_call_demo/lib/core/local_db/app_local_storage.dart';
import 'package:voice_call_demo/lib/data/firebase_data_source.dart';
import 'package:voice_call_demo/lib/data/webrtc_data_source.dart';
import 'package:voice_call_demo/lib/domain/providers/home_provider.dart';


class CallState {
  final bool isLoading;
  final bool success;
  final bool callConnected;
  final String? error;
  final String? userId;
  final String? roomId;
  final String? receiverId;
  final bool? isMute;
  final bool? isSpeakerLoud;


  CallState( {

    this.isLoading = false,
    this.success=false,
    this.callConnected=false,
    this.error,
    this.userId,
    this.roomId,
    this.receiverId,
    this.isMute,
    this.isSpeakerLoud,
  });

  CallState copyWith({
    bool? isLoading,
    bool? success,
    bool? callConnected,
    String? error,
    String? userId,
    String? roomId,
    String? receiverId,
    bool? isMute,
    bool? isSpeakerLoud,
  }) {
    return CallState(
        isLoading: isLoading ?? this.isLoading,
        success:success ?? this.success,
        callConnected:callConnected ?? this.callConnected,
        error:error ?? this.error,
        userId:userId ?? this.userId,
        roomId:roomId ?? this.roomId,
        receiverId:receiverId ?? this.receiverId,
        isMute:isMute ?? this.isMute,
        isSpeakerLoud:isSpeakerLoud ?? this.isSpeakerLoud
    );
  }
}

class CallNotifier extends StateNotifier<CallState>{
  WebRtcDataSource webRtcDataSource;
  AppLocalStorage localDbProvider;
  FirebaseDataSource firebaseDataSource;
  CallNotifier(
      this.webRtcDataSource,
      this.localDbProvider,
      this.firebaseDataSource,
      ): super(CallState()){
    getUserId();

  }

  Future<void> getUserId() async {
    var userId=await localDbProvider.getUserId();
    state=state.copyWith(userId:userId );
  }


  Future<void> connectCallUser(WidgetRef ref ) async {
    ref.read(homeNotifierProvider.notifier).callConnect();
  }

  void updateConnectionData(String roomId) {
    state=state.copyWith(
      roomId: roomId,
    );
  }

  void updateRoomToUser(String senderId,String? receiverId, String? roomId) {
    firebaseDataSource.updateRoomToUser(senderId:senderId,receiverId:receiverId, roomId:roomId);
  }

  void updateConnection() {
    state=state.copyWith(callConnected: true);
  }

  void clearOnHangUp(String senderId, String? receiverId, String roomId) {
    firebaseDataSource.clearOnHangUp(senderId:senderId,receiverId:receiverId, roomId:roomId);
  }

  void updateMuteUnMute() {
    if(state.isMute==true) {
      state = state.copyWith(isMute: false);
    }else{
      state = state.copyWith(isMute: true);
    }
  }

  void updateSpeaker() {
    if(state.isSpeakerLoud==true) {
      state = state.copyWith(isSpeakerLoud: false);
    }else{
      state = state.copyWith(isSpeakerLoud: true);
    }
  }




}


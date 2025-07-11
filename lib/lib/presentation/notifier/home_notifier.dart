import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voice_call_demo/lib/core/local_db/app_local_storage.dart';
import 'package:voice_call_demo/lib/core/network/app_credentials.dart';
import 'package:voice_call_demo/lib/core/routes/route_paths.dart';
import 'package:voice_call_demo/lib/data/firebase_data_source.dart';
import 'package:voice_call_demo/lib/data/webrtc_data_source.dart';


class HomeState {
  final bool isLoading;
  final bool success;
  final bool callConnecting;
  final String? error;
  final String? userId;
  final String? roomId;
  final String? receiverId;


  HomeState( {
    this.isLoading = false,
    this.success=false,
    this.callConnecting=false,
    this.error,
    this.userId,
    this.roomId,
    this.receiverId,
  });

  HomeState copyWith({
    bool? isLoading,
    bool? success,
    bool? callConnecting,
    String? error,
    String? userId,
    String? roomId,
    String? receiverId,
  }) {
    return HomeState(
        isLoading: isLoading ?? this.isLoading,
        success:success ?? this.success,
        callConnecting:callConnecting ?? this.callConnecting,
        error:error ?? this.error,
        userId:userId ?? this.userId,
        roomId:roomId ?? this.roomId,
        receiverId:receiverId ?? this.receiverId
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState>{
  WebRtcDataSource webRtcDataSource;
  AppLocalStorage localDbProvider;
  FirebaseDataSource firebaseDataSource;
  HomeNotifier(
      this.webRtcDataSource,
      this.localDbProvider,
      this.firebaseDataSource,
      ): super(HomeState()){
    getUserId();

  }

  Future<void> getUserId() async {
    var userId=await localDbProvider.getUserId();
    state=state.copyWith(userId:userId );
  }


  void logout(BuildContext context) {
    localDbProvider.clearDb();
    context.pushReplacementNamed(RoutePaths.register);
  }


  // void updateUserOnlineStatue(bool status){
  //   var userRef= FirebaseFirestore.instance.collection('users');
  //   userRef.doc(state.userId).update({
  //     "online":status
  //   });
  // }

  void updateConnectionData(BuildContext context) {
   var userRef= FirebaseFirestore.instance.collection('users');
    userRef.doc(state.userId).snapshots().listen((event) async {
      if(event["roomId"]!=""){
        state=state.copyWith(
          roomId: event["roomId"],
        );
        final roomRef =  FirebaseFirestore.instance.collection('rooms').doc(state.roomId);
        final roomSnapshot = await roomRef.get();
        if(context.mounted&&event["callee"]==true&&roomSnapshot["callee"]!=true){
          context.pushNamed(RoutePaths.videoCall,extra: {"roomId":state.roomId,"callType":"incoming"});
        }
      }
    });


  }

  void clearFields() {
    state=state.copyWith(
      roomId: "",callConnecting: false
    );
  }

  void callConnect() {
    state=state.copyWith(
        callConnecting: true
    );
  }




}


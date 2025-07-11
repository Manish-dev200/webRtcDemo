import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voice_call_demo/lib/presentation/pages/home_page.dart';
import 'package:voice_call_demo/lib/presentation/pages/register_user_page.dart';
import 'package:voice_call_demo/lib/presentation/pages/video_call_page.dart';
import '../local_db/app_local_storage.dart';
import 'route_paths.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RoutePaths.register,
    routes: [
      GoRoute(
        path: RoutePaths.home,
        name: RoutePaths.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RoutePaths.register,
        name: RoutePaths.register,
        redirect: (context, state) async {
          var result=await AppLocalStorage().getUserId();
          if(result!=""){
            return  RoutePaths.home;
          }else{
            return  RoutePaths.register;
          }
        },
        builder: (context, state) => const RegisterUserPage(),
      ),
      GoRoute(
        path: RoutePaths.videoCall,
        name: RoutePaths.videoCall,
        builder: (context, state) {
          var data=state.extra as Map<String,dynamic>;
          var roomId=data["roomId"];
          var calleeId=data["calleeId"];
          var callType=data["callType"];
          return VideoCallPage(roomId,calleeId,callType);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text(state.error.toString())),
    ),
  );
}

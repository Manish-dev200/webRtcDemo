

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:go_router/go_router.dart';
import 'package:voice_call_demo/lib/data/webrtc_data_source.dart';
import 'package:voice_call_demo/lib/domain/providers/call_provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_text.dart';


class IncomingVideoView extends ConsumerWidget {
  final WebRtcDataSource? signaling;
  final RTCVideoRenderer localRenderer;
  final RTCVideoRenderer remoteRenderer;
  final String? receiverId;
  final String? roomId;
  const IncomingVideoView(
      this.signaling,
      this.localRenderer,
      this.remoteRenderer,
      this.receiverId,
      this.roomId,
      {super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var state=ref.watch(callNotifierProvider);
    var vm=ref.read(callNotifierProvider.notifier);
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: AppColors.colorBackgroundDark,
        child: Column(
          children: [
            SizedBox(height: 100,),
            AppText("Manish",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 22,color: AppColors.colorWhite),),
            Container(
              height:150,
              width: 150,
              margin: EdgeInsets.only(right: 10,bottom: 100,top: 50),
              decoration: BoxDecoration(
                  color: AppColors.colorPrimary,
                  borderRadius: BorderRadius.circular(100)
              ),
              child: Center(child: AppText("M",style: TextStyle(fontSize: 40,fontWeight: FontWeight.w900),)),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () async {
                    // await  signaling?.hungUp(roomId);
                    var vm=ref.read(callNotifierProvider.notifier);
                   signaling?.hungUp(roomId);
                    if(context.mounted){
                      context.pop();
                    }

                  },
                  child: Container(
                      height:60,
                      width: 60,
                      margin: EdgeInsets.only(right: 10,bottom: 10,top: 50),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(100)
                      ),
                      child: Center(child: Icon(Icons.call))),
                ),
                GestureDetector(
                  onTap: ()async{
                  var value=await  signaling?.joinRoomById(roomId??'');
                  if(value==true&&!context.mounted){
                    vm.updateConnection();
                  }
                  },
                  child: Container(
                      height:60,
                      width: 60,
                      margin: EdgeInsets.only(right: 10,bottom: 10,top: 50),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(100)
                      ),
                      child: Center(child: Icon(Icons.call))),
                ),
              ],
            ),

          ],
        )
      ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:go_router/go_router.dart';
import 'package:voice_call_demo/lib/core/widgets/app_text.dart';
import 'package:voice_call_demo/lib/data/webrtc_data_source.dart';

import '../../domain/providers/call_provider.dart';


class ConnectedVideoView extends ConsumerWidget {
  final WebRtcDataSource? signaling;
  final RTCVideoRenderer localRenderer;
  final RTCVideoRenderer remoteRenderer;
  final String? receiverId;
  final String? roomId;

  const ConnectedVideoView(this.signaling, this.localRenderer,this.remoteRenderer,
      this.receiverId,
      this.roomId,
      {super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var state=ref.watch(callNotifierProvider);
    var vm=ref.read(callNotifierProvider.notifier);
    return Stack(
      children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(color: Colors.black54),
            child: RTCVideoView(remoteRenderer),
          ),
          Positioned(
            left: 20.0,
            top: 20.0,
            child: Container(
              width: 120.0,
              height: 90.0,
              decoration: BoxDecoration(color: Colors.black54),
              child: RTCVideoView(localRenderer, mirror: true),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 50,
            right: 50,
            child: SizedBox(
              width: 200.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: () async {
                      context.pop();
                      ref.read(callNotifierProvider.notifier).updateRoomToUser(state.userId??'',receiverId, "");
                      await signaling?.hungUp(roomId);
                      if(context.mounted){
                        context.pop();
                      }
                    },
                    tooltip: 'Hangup',
                    backgroundColor: Colors.red.shade700,
                    child: Icon(Icons.call_end),
                  ),
                  FloatingActionButton(
                    onPressed: (){
                      signaling?.muteMic();
                      vm.updateMuteUnMute();
                    },
                    tooltip: 'Mute Mic',
                    child: state.isMute==true? const Icon(Icons.mic_off):const Icon(Icons.mic),
                  ),

                ],
              ),
            ),
          ),

      ],
    );
  }
}

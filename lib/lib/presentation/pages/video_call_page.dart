import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:go_router/go_router.dart';
import 'package:voice_call_demo/lib/data/webrtc_data_source.dart';
import 'package:voice_call_demo/lib/domain/providers/call_provider.dart';
import '../../core/network/app_credentials.dart';
import '../widgets/Incoming_video_view.dart';
import '../widgets/connected_video_view.dart';

class VideoCallPage extends ConsumerStatefulWidget {
  String? roomId;
  String? calleeId;
  String? callType;
  VideoCallPage(this.roomId,this.calleeId,this.callType);
  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends ConsumerState<VideoCallPage> {
  WebRtcDataSource? signaling;
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  bool inCalling = false;
  String? calleeId;

  @override
  void initState() {
    _connect();
    super.initState();
  }

  void _connect() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
    if (signaling == null) {
      signaling = WebRtcDataSource();

      signaling?.onLocalStream = ((stream) {
        localRenderer.srcObject = stream;
      });

      signaling?.onAddRemoteStream = ((stream) {
        remoteRenderer.srcObject = stream;
        setState(() {

        });
      });

      signaling?.onRemoveRemoteStream = (() {
        remoteRenderer.srcObject = null;
      });

      signaling?.onDisconnect = (() {
        setState(() {
          inCalling = false;
          widget.roomId = null;
          calleeId = null;
        });
      });
      Future.delayed(Duration(seconds: 1),()async {
        if(widget.callType=="outgoing"){
          var result= await signaling?.createRoom();
          widget.roomId=result;
          inCalling = true;
          calleeId=widget.calleeId;
          var state= ref.watch(callNotifierProvider);
          ref.read(callNotifierProvider.notifier).updateRoomToUser(state.userId??'',calleeId, widget.roomId);
        }
      },);





    }
  }

  @override
  deactivate() {
    super.deactivate();
    localRenderer.dispose();
    remoteRenderer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var vm=ref.read(callNotifierProvider.notifier);
    var state=ref.watch(callNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Firebase WebRTC'),leading: SizedBox(),),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('rooms').doc(widget.roomId).snapshots(),
        builder: ( context,  snapshot,) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.hasData){
            if(widget.callType=="incoming"&&state.callConnected!=true){
              return  IncomingVideoView(signaling,localRenderer,remoteRenderer,calleeId,widget.roomId);
            }else{
              return ConnectedVideoView(signaling,localRenderer,remoteRenderer,calleeId,widget.roomId);
            }
          }else{
            return Text("something went wrong");
          }

        }
      ),
    );
  }

  Widget usersPage(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var item=snapshot.data!.docs[index];
              if(item["roomId"]!=""){
                return  Container(
                  margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 20,
                    right: 20,
                    bottom: 10,
                  ),
                  color: Colors.black,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["name"],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        item["contact"],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              widget.roomId = item["roomId"];
                              calleeId = item.id;
                             await signaling?.joinRoomById(widget.roomId??'');
                              setState(() {
                                inCalling = true;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              color: Colors.green,
                              child: Text("Accepted",style: TextStyle(color: Colors.white),),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              // signaling?.sendRoomToUser(snapshot.data!.docs[index].id,'');

                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                              color: Colors.red,
                              child: Text("Rejected",style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }else {
                return Container(
                  margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 20,
                    right: 20,
                    bottom: 10,
                  ),
                  color: Colors.black12,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                       item["name"],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        item["contact"],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 20),
                      if(item.id!=AppCredentials.imyId)...{
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () async {
                              if(item.id!=AppCredentials.imyId){
                                final result = await signaling?.createRoom();
                                setState(() {
                                  widget.roomId = result;
                                  calleeId = item.id;
                                  inCalling = true;
                                  // signaling?.sendRoomToUser(item.id,widget.roomId??'');
                                });
                              }

                            },
                            child: Container(
                              height: 30,
                              width: 70,
                              color: Colors.white,
                              child: Icon(Icons.call, color: Colors.green),
                            ),
                          ),
                        ),
                      }

                    ],
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

}

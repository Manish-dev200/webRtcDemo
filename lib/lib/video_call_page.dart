import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:voice_call_demo/lib/my_constants.dart';
import 'package:voice_call_demo/lib/signaling.dart';
import 'package:voice_call_demo/lib/users_page.dart';

class VideoCallPage extends StatefulWidget {
  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  Signaling? signaling;
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  bool inCalling = false;
  String? roomId;
  String? receiverId;
  late TextEditingController _joinRoomTextEditingController;

  @override
  void initState() {
    _joinRoomTextEditingController = TextEditingController();
    _connect();
    super.initState();
  }

  void _connect() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
    if (signaling == null) {
      signaling = Signaling();

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
          roomId = null;
          receiverId = null;
        });
      });
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
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Firebase WebRTC')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: inCalling
          ? SizedBox(
              width: 200.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: () async {
                      await signaling?.hungUp();
                       signaling?.sendRoomToUser(receiverId??'', "");
                      setState(() {
                        roomId = null;
                        receiverId = null;
                        inCalling = false;
                      });
                    },
                    tooltip: 'Hangup',
                    backgroundColor: Colors.red.shade700,
                    child: Icon(Icons.call_end),
                  ),
                  FloatingActionButton(
                    onPressed: signaling?.muteMic,
                    tooltip: 'Mute Mic',
                    child: const Icon(Icons.mic_off),
                  ),
                ],
              ),
            )
          : null,

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: ( context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshot.hasData){
            return inCalling
                ? Stack(
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
              ],
            )
                : usersPage(snapshot);
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
                              roomId = item["roomId"];
                              receiverId = item.id;
                             await signaling?.joinRoomById(roomId??'');
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
                              signaling?.sendRoomToUser(snapshot.data!.docs[index].id,'');

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
                      if(item.id!=MyConstants.myId)...{
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () async {
                              if(item.id!=MyConstants.myId){
                                final result = await signaling?.createRoom();
                                setState(() {
                                  roomId = result;
                                  receiverId = item.id;
                                  inCalling = true;
                                  signaling?.sendRoomToUser(item.id,roomId??'');
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

  Widget oldUi() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 36.0,
            child: ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color?>(
                  Theme.of(context).primaryColor,
                ),
                foregroundColor: MaterialStateProperty.all<Color?>(
                  Colors.white,
                ),
              ),
              label: Text('CREATE ROOM'),
              icon: Icon(Icons.group_add),
              onPressed: () async {
                final _roomId = await signaling?.createRoom();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Current room is'),
                    content: Row(
                      children: [
                        Text(_roomId!),
                        SizedBox(width: 8.0),
                        IconButton(
                          icon: Icon(Icons.copy),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: _roomId));
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                );
                setState(() {
                  roomId = _roomId;
                  inCalling = true;
                });
              },
            ),
          ),
          SizedBox(width: 10.0),
          SizedBox(
            height: 36.0,
            child: ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color?>(
                  Theme.of(context).primaryColor,
                ),
                foregroundColor: MaterialStateProperty.all<Color?>(
                  Colors.white,
                ),
              ),
              label: Text('JOIN ROOM'),
              icon: Icon(Icons.people),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Join room'),
                    content: Row(
                      children: [
                        Text('Enter ID for room to join:'),
                        SizedBox(width: 5),
                        Container(
                          width: 200.0,
                          child: TextField(
                            controller: _joinRoomTextEditingController,
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: Text('CANCEL'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('JOIN'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
                if (_joinRoomTextEditingController.text.isNotEmpty) {
                  var result = await signaling?.joinRoomById(
                    _joinRoomTextEditingController.text,
                  );
                  if (result == true) {
                    setState(() {
                      inCalling = true;
                      roomId = _joinRoomTextEditingController.text;
                    });
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

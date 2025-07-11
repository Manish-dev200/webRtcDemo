import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:go_router/go_router.dart';
import 'package:voice_call_demo/lib/core/constants/app_colors.dart';
import 'package:voice_call_demo/lib/core/dimentions/app_dimentions.dart';
import 'package:voice_call_demo/lib/core/widgets/app_text.dart';
import 'package:voice_call_demo/lib/domain/providers/home_provider.dart';
import 'package:voice_call_demo/lib/presentation/notifier/home_notifier.dart';
import '../../core/routes/route_paths.dart';
import '../../data/webrtc_data_source.dart';


class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  WebRtcDataSource? signaling;
  RTCVideoRenderer localRenderer = RTCVideoRenderer();
  RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  bool inCalling = false;
  String? roomId;
  String? receiverId;

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
          roomId = null;
          receiverId = null;
        });
      });
    }
    ref.read(homeNotifierProvider.notifier).updateConnectionData(context);

  }

  @override
  deactivate() {
    super.deactivate();
    localRenderer.dispose();
    remoteRenderer.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var vm=ref.read(homeNotifierProvider.notifier);
    var state=ref.watch(homeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.colorPrimary,
        centerTitle: true,
        leading: SizedBox(),
        title: AppText("Home",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
        actions: [GestureDetector(
          onTap: (){
            vm.logout(context);
          },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.leftRightPadding),
                child: Icon(Icons.logout,color: AppColors.colorWhite,)))],
      ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              nearestUsersList(state,vm),
            ],
          ),
        ));
  }
  Widget nearestUsersList(HomeState state, HomeNotifier vm) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return Expanded(child: Center(child: CircularProgressIndicator()));
          }else if(snapshot.hasData){
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.leftRightPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    AppText("Available Users",style: TextStyle(fontSize: 20,color: AppColors.colorBlack,fontWeight: FontWeight.w800),),
                    SizedBox(height: 10,),
                    if(snapshot.data!=null&&snapshot.data!.docs.length>1)...{
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var item=snapshot.data!.docs[index];
                            if(item.id!=state.userId){
                              return Container(
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                decoration:BoxDecoration( color: Colors.black12,
                                    borderRadius: BorderRadius.circular(10)) ,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    Container(
                                      height:50,
                                      width: 50,
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                          color: AppColors.colorPrimary,
                                          borderRadius: BorderRadius.circular(100)
                                      ),
                                      child: Center(child: AppText(item["name"].toString().split("").first.toUpperCase(),style: TextStyle(fontSize: 22,fontWeight: FontWeight.w900),)),
                                    ),
                                    Expanded(
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
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),


                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: GestureDetector(
                                        onTap: () async {
                                          vm.callConnect();
                                          context.pushNamed(RoutePaths.videoCall,extra: {"calleeId":item.id,"callType":"outgoing"});
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 70,
                                          color: Colors.white,
                                          child: Icon(Icons.call, color: Colors.green),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              );
                            } else{
                              return SizedBox();
                            }


                          },
                        ),
                      ),
                    }else...{
                      Expanded(child:  Center(child: AppText("No data found",style: TextStyle(fontSize: 20,color: AppColors.colorBlack,fontWeight: FontWeight.w800),)),
                      )

                    }

                  ],
                ),
              ),
            );
          }else{
            return SizedBox();
          }

      }
    );
  }



}


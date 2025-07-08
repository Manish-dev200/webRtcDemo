import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:voice_call_demo/lib/my_constants.dart';
import 'package:voice_call_demo/lib/signaling.dart';
import 'package:voice_call_demo/lib/video_call_page.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  Signaling? signaling;

  @override
  void initState() {
    _connect();
    super.initState();
  }
  void _connect() async {
    signaling ??= Signaling();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.black38,
            title: Text("Users",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600)),),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("users").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
            snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var item=snapshot.data!.docs[index];
                          if(item.id!=MyConstants.myId){
                            return  Container(
                              margin: EdgeInsets.only(top: 10,left: 20,right: 20),
                              padding: EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 10),
                              color: Colors.black12,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.data!.docs[index].data()["name"],style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w600)),
                                  Text(snapshot.data!.docs[index].data()["contact"],style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w600)),
                                  SizedBox(height: 20,),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => VideoCallPage(),));
                                      },
                                      child: Container(
                                          height: 30,
                                          width: 70,
                                          color: Colors.white,
                                          child: Icon(Icons.call,color: Colors.green,)),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }else{
                            return SizedBox();
                          }
                        }),
                    ),
                  ],
                );
              }
              return const Text("Something went wrong");

            }
          )),
    );
  }
}



import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_call_demo/lib/data/firebase_data_source.dart';

import '../../data/webrtc_data_source.dart';

final firebaseDataSource=Provider<FirebaseDataSource>((ref)=>FirebaseDataSource());


final webRtcDataSource=Provider<WebRtcDataSource>((ref)=>WebRtcDataSource());

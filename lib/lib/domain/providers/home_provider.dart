
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_call_demo/lib/domain/providers/local_db_provider.dart';
import 'package:voice_call_demo/lib/domain/providers/remote_provider.dart';
import 'package:voice_call_demo/lib/presentation/notifier/home_notifier.dart';



final homeNotifierProvider=StateNotifierProvider.autoDispose<HomeNotifier,HomeState>((ref) => HomeNotifier(
  ref.watch(webRtcDataSource),
  ref.watch(localDbProvider),
  ref.watch(firebaseDataSource),
),);
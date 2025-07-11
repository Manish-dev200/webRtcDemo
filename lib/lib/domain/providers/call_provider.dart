


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_call_demo/lib/domain/providers/remote_provider.dart';

import '../../presentation/notifier/call_notifier.dart';
import 'local_db_provider.dart';

final callNotifierProvider=StateNotifierProvider.autoDispose<CallNotifier,CallState>((ref) => CallNotifier(
  ref.watch(webRtcDataSource),
  ref.watch(localDbProvider),
  ref.watch(firebaseDataSource),
),);
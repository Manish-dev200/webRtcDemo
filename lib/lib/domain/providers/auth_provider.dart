import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_call_demo/lib/domain/providers/remote_provider.dart';
import 'package:voice_call_demo/lib/presentation/notifier/auth_notifier.dart';

import 'local_db_provider.dart';







final authNotifierProvider=StateNotifierProvider.autoDispose<AuthNotifier,AuthState>((ref) => AuthNotifier(
    firebaseDataSource:ref.watch(firebaseDataSource),
    localDbProvider:ref.watch(localDbProvider)
),);
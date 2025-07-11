

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/local_db/app_local_storage.dart';

final localDbProvider=Provider<AppLocalStorage>((ref)=>AppLocalStorage());

import 'package:drift/drift.dart';
import 'connection_stub.dart'
    if (dart.library.js_interop) 'connection_web.dart'
    if (dart.library.io) 'connection_native.dart';

QueryExecutor openConnection() => connect();

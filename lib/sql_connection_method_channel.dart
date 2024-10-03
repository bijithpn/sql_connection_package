import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sql_connection_platform_interface.dart';

/// An implementation of [SqlConnectionPlatform] that uses method channels.
class MethodChannelSqlConnection extends SqlConnectionPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sql_connection');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}

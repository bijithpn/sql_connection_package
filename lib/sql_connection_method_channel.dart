import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sql_connection_platform_interface.dart';

/// An implementation of [SqlConnectionPlatform] that uses method channels.
class MethodChannelSqlConnection extends SqlConnectionPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sql_connection');

  @override
  Future<bool> connect({
    required String ip,
    required String port,
    required String databaseName,
    required String username,
    required String password,
    int timeoutInSeconds = 30,
  }) async {
    try {
      var invokeMethod = await methodChannel.invokeMethod<bool>(
            'connectDb',
            {
              'url': "jdbc:jtds:sqlserver://$ip:$port/$databaseName",
              'username': username,
              'password': password,
              'timeoutInSeconds': timeoutInSeconds,
            },
          ) ??
          false;
      return invokeMethod;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> getData(String query) async {
    try {
      final result =
          await methodChannel.invokeMethod<List>('getData', {'query': query});
      return result == null ? "" : "[${result.join(",")}]";
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> writeData(String query) async {
    try {
      final String? result = await methodChannel
          .invokeMethod<String>('writeData', {'query': query});
      return result ?? '';
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> disconnect() async {
    try {
      final bool? result = await methodChannel.invokeMethod<bool>('disconnect');
      return result ?? false;
    } catch (e) {
      rethrow;
    }
  }
}

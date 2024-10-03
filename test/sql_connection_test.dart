import 'package:flutter_test/flutter_test.dart';
import 'package:sql_connection/sql_connection.dart';
import 'package:sql_connection/sql_connection_platform_interface.dart';
import 'package:sql_connection/sql_connection_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSqlConnectionPlatform
    with MockPlatformInterfaceMixin
    implements SqlConnectionPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SqlConnectionPlatform initialPlatform = SqlConnectionPlatform.instance;

  test('$MethodChannelSqlConnection is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSqlConnection>());
  });

  test('getPlatformVersion', () async {
    SqlConnection sqlConnectionPlugin = SqlConnection();
    MockSqlConnectionPlatform fakePlatform = MockSqlConnectionPlatform();
    SqlConnectionPlatform.instance = fakePlatform;

    expect(await sqlConnectionPlugin.getPlatformVersion(), '42');
  });
}

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'sql_connection_method_channel.dart';

abstract class SqlConnectionPlatform extends PlatformInterface {
  /// Constructs a SqlConnectionPlatform.
  SqlConnectionPlatform() : super(token: _token);

  static final Object _token = Object();

  static SqlConnectionPlatform _instance = MethodChannelSqlConnection();

  /// The default instance of [SqlConnectionPlatform] to use.
  ///
  /// Defaults to [MethodChannelSqlConnection].
  static SqlConnectionPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SqlConnectionPlatform] when
  /// they register themselves.
  static set instance(SqlConnectionPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Connects to the SQL Server database.
  ///
  /// The required parameters are the IP address, port, database name,
  /// username, password, and an optional timeout in seconds.
  Future<bool> connect({
    required String ip,
    required String port,
    required String databaseName,
    required String username,
    required String password,
    int timeoutInSeconds = 15,
  });

  /// Retrieves data from the database using the specified SQL query.
  Future<String> getData(String query);

  /// Writes data to the database using the specified SQL query.
  Future<String> writeData(String query);

  /// Disconnects from the MS SQL Server database.
  Future<bool> disconnect();
}

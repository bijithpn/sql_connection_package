import 'sql_connection_platform_interface.dart';

class SqlConnection {
  static SqlConnection? _instance;

  bool _isConnected = false;

  bool get isConnected => _isConnected;

  SqlConnection._();
  static SqlConnection getInstance() {
    _instance ??=
        SqlConnection._(); // Create a new instance if it doesn't exist
    return _instance!;
  }

  /// Connects to the MS SQL Server database.
  ///
  /// Parameters:
  /// - [ip]: IP address of the server.
  /// - [port]: Port number to connect.
  /// - [databaseName]: Name of the database.
  /// - [username]: Username for authentication.
  /// - [password]: Password for authentication.
  /// - [timeoutInSeconds]: Timeout duration for the connection (default is 15 seconds).
  Future<bool> connect({
    required String ip,
    required String port,
    required String databaseName,
    required String username,
    required String password,
    int timeoutInSeconds = 15,
  }) async {
    try {
      _isConnected = await SqlConnectionPlatform.instance.connect(
        ip: ip,
        port: port,
        databaseName: databaseName,
        username: username,
        password: password,
        timeoutInSeconds: timeoutInSeconds,
      );

      return _isConnected;
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches data from the MS SQL Server database based on the provided query.
  ///
  /// Parameters:
  /// - [query]: SQL query to retrieve data.
  Future<String> getData(String query) {
    try {
      return SqlConnectionPlatform.instance.getData(query);
    } catch (e) {
      rethrow;
    }
  }

  /// Writes data to the MS SQL Server database based on the provided query.
  ///
  /// Parameters:
  /// - [query]: SQL query to write data.
  Future<String> writeData(String query) {
    try {
      return SqlConnectionPlatform.instance.writeData(query);
    } catch (e) {
      rethrow;
    }
  }

  /// Disconnects from the MS SQL Server database.
  Future<bool> disconnect() {
    try {
      _isConnected = false;
      return SqlConnectionPlatform.instance.disconnect();
    } catch (e) {
      rethrow;
    }
  }
}

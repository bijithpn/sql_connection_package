
import 'sql_connection_platform_interface.dart';

class SqlConnection {
  Future<String?> getPlatformVersion() {
    return SqlConnectionPlatform.instance.getPlatformVersion();
  }
}

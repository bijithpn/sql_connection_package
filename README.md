## **SQL Connection Plugin** 🔌

**Connect to and interact with SQL Server databases from your Flutter apps.** 📱

The `sql_connection` plugin provides a simple and efficient way to connect to SQL Server databases on Android. You can easily execute queries, fetch data, and perform other database operations directly from your Flutter code.

**Key Features:**

- **Seamless SQL Server integration:** 🔄 Connect to your SQL Server database with minimal setup.
- **Powerful query execution:** 🔍 Execute SQL queries and retrieve results directly from your Flutter app.
- **Flexible data manipulation:** 🔄 Insert, update, and delete data in your SQL Server database.
- **Customizable connection options:** ⚙️ Set connection timeouts and other parameters to suit your needs.
- **Android platform support:** 🤖 Works seamlessly on Android devices.

## Get started:

**1. Add the package to your `pubspec.yaml` file:**

```yaml
dependencies:
  sql_connection: ^1.0.0
```

**1.1. Type this command on your `terminal` :**

```bash
 flutter pub add sql_connection
```

**2. Import the package:**

```dart
import 'package:sql_connection/sql_connection.dart';
```

**3. Establish a connection:**

```dart
var connectionStatus = await sqlConnection.connect(
        ip: ip,
        port: port,
        databaseName: databaseName,
        username: username,
        password: password,
        );
```

**4. Execute queries:**

The `sql_connection` plugin empowers you to seamlessly execute SQL queries and perform a wide range of database operations, including:

**4.1 Read Data:**

📖 Retrieve information from your SQL Server database using `SELECT` statements.

```dart
   var result = await sqlConnection.queryDatabase('SELECT * FROM your_table');
```

**4.2 Write Data:**

📝 Insert, update, and delete data in your database using `INSERT`, `UPDATE`, and `DELETE` statements.

```dart
  var result = await sqlConnection.updateData('UPDATE your_table_name SET column_name = new_value');
```

**5. Close the connection:**

❌ After you're done with your database operations, it's important to close the connection to release resources and prevent memory leaks. You can use the `disconnect()` method on the `sqlConnection` object to terminate the connection.

```dart
await sqlConnection.disconnect();
```

## Caution: Security Considerations

**Direct database connections can pose security risks. It's strongly recommended to use an API or middleware layer to handle database interactions and protect sensitive information.**

Direct connections expose your database credentials and can make your application vulnerable to attacks. Consider using a REST API or GraphQL server to provide a secure interface between your Flutter app and the database.

## Contributing

Contributions are welcome! Please feel free to open issues or submit pull requests.

## License

This package is licensed under the [MIT License](https://opensource.org/licenses/MIT).

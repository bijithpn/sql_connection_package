import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_json_view/flutter_json_view.dart';

import 'package:sql_connection/sql_connection.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SQL Connection Example',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const HomPage());
  }
}

const textStyle = TextStyle(fontSize: 18);

class HomPage extends StatefulWidget {
  const HomPage({super.key});

  @override
  State<HomPage> createState() => _HomPageState();
}

class _HomPageState extends State<HomPage> {
  String ip = '',
      port = '',
      username = '',
      password = '',
      databaseName = '',
      readQuery = '',
      writeQuery = '',
      result = '';

  final pageController = PageController();
  final sqlConnection = SqlConnection.getInstance();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    sqlConnection.disconnect();
    super.dispose();
  }

  void connect() async {
    var connectionStatus = await sqlConnection.connect(
        ip: ip,
        port: port,
        databaseName: databaseName,
        username: username,
        password: password);
    if (connectionStatus) {
      showSnackBar(
        "Connection Established",
      );
      pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    } else {
      showSnackBar(
        "Connection Failed",
      );
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    ));
  }

  void execute(String s, BuildContext context) async {
    try {
      if (s == "Read") {
        if (readQuery.isEmpty) {
          showSnackBar("Empty query");
          return;
        }
        showProgress();
        result = await sqlConnection.getData(readQuery);
        hideProgress();
      } else {
        if (writeQuery.isEmpty) {
          showSnackBar("Empty query");
          return;
        }
        showProgress();
        result = await sqlConnection.writeData(writeQuery);
        hideProgress();
      }
      setState(() {});
    } on PlatformException catch (e) {
      hideProgress();
      showSnackBar(
        e.message ?? "",
      );
    }
  }

  void showProgress() async => await showDialog(
        context: context,
        builder: (context) => Center(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(10),
            child: const CircularProgressIndicator(),
          ),
        ),
      );

  void hideProgress() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'SQL Connection Example',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () {
                sqlConnection.disconnect();
                pageController.animateToPage(0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              },
              icon: const Icon(
                Icons.link_off,
                size: 30,
                color: Colors.white,
              ))
        ],
      ),
      body: Form(
        key: _formKey,
        child: PageView(
          controller: pageController,
          children: [
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Column(children: [
                  Row(children: [
                    Flexible(
                        child: CustomTextField(
                            title: "IP address",
                            onchanged: (p0) => ip = p0,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[\d\.]'),
                              ),
                            ],
                            keyboardType: TextInputType.number)),
                    const SizedBox(width: 10),
                    Flexible(
                        child: CustomTextField(
                            title: "Port",
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4)
                            ],
                            onchanged: (p0) => port = p0,
                            keyboardType: TextInputType.number))
                  ]),
                  const SizedBox(height: 10),
                  CustomTextField(
                    title: "Database Name",
                    keyboardType: TextInputType.text,
                    onchanged: (p0) => databaseName = p0,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    keyboardType: TextInputType.text,
                    title: "Username",
                    onchanged: (p0) => username = p0,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    keyboardType: TextInputType.text,
                    title: "Password",
                    onchanged: (p0) => password = p0,
                  ),
                  const SizedBox(height: 15.0),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).primaryColor),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)))),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          connect();
                        }
                      },
                      child: Text(
                        "Connect",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                      ))
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Read Data", style: textStyle),
                              IconButton(
                                  onPressed: () => execute("Read", context),
                                  icon: const Icon(Icons.play_arrow_rounded))
                            ],
                          ),
                          CustomTextField(
                            title: 'query',
                            onchanged: (p0) => readQuery = p0,
                            autovalidateMode: false,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Write Data", style: textStyle),
                              IconButton(
                                  onPressed: () => execute("write", context),
                                  icon: const Icon(Icons.play_arrow_rounded))
                            ],
                          ),
                          CustomTextField(
                            title: 'query',
                            onchanged: (p0) => writeQuery = p0,
                            autovalidateMode: false,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Response",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: JsonView.string(result),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.onchanged,
    this.autovalidateMode = true,
    this.keyboardType,
    required this.title,
    this.inputFormatters,
  });

  final void Function(String)? onchanged;
  final bool autovalidateMode;
  final TextInputType? keyboardType;
  final String title;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: true,
      autovalidateMode:
          autovalidateMode ? AutovalidateMode.onUserInteraction : null,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      onChanged: onchanged,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: "Enter $title",
          labelText: title),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter $title";
        }
        return null;
      },
    );
  }
}

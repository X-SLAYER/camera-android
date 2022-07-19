import 'package:flutter/material.dart';
import 'package:camera_example/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await CamController.initCamera();
  runApp(const MyApp());
}

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(
        color: Colors.transparent,
        elevation: 0.0,
        child: Container(
          height: 500.0,
          color: Colors.red,
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foreground servive starter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:camera_example/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await CamController.initCamera();
  runApp(const MyApp());
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

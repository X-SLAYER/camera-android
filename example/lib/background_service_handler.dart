import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      onBackground: () {},
      autoStart: true,
      onForeground: () {},
    ),
  );
}

void initCamera() async {
  final description = await availableCameras().then(
    (cameras) => cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    ),
  );
  final _cameraController = CameraController(
    description,
    ResolutionPreset.low,
    enableAudio: false,
  );
  await _cameraController.initialize();
  await Future.delayed(const Duration(milliseconds: 500));
  _cameraController.startImageStream((img) async {
    log("Image captures: ${img.width} x ${img.height} -- ${img.format.raw}");
  });
}

void onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  initCamera();
}

class BackgroundService extends StatefulWidget {
  const BackgroundService({Key? key}) : super(key: key);

  @override
  State<BackgroundService> createState() => _BackgroundServiceState();
}

class _BackgroundServiceState extends State<BackgroundService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                await initializeService();
              },
              child: const Text("Start the service"),
              style: TextButton.styleFrom(backgroundColor: Colors.black12),
            ),
            const SizedBox(height: 50.0),
            TextButton(
              onPressed: () {
                FlutterBackgroundService()
                    .sendData({"action": "setAsForeground"});
              },
              child: const Text("Run on Foreground"),
              style: TextButton.styleFrom(backgroundColor: Colors.red[100]),
            ),
            TextButton(
              onPressed: () {
                FlutterBackgroundService().stopService();
              },
              child: const Text("Stop the service"),
              style: TextButton.styleFrom(backgroundColor: Colors.red[100]),
            )
          ],
        ),
      ),
    );
  }
}

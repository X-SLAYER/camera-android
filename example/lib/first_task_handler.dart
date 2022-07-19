import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

import 'package:bg_launcher/bg_launcher.dart';
import 'package:camera_bg/camera.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class FirstTaskHandler extends TaskHandler {
  int updateCount = 0;
  int counter = 0;
  late DateTime currentUseTime;
  Timer? lockChecker, cameraChecker;
  bool alreadyChecking = false;
  late CameraDescription description;
  late CameraController _cameraController;

  void checkIfCameraInUse() {
    cameraChecker = Timer.periodic(const Duration(seconds: 7), (_timer) async {
      final lastTimeInUse =
          DateTime.now().difference(currentUseTime).abs().inSeconds;
      if (lastTimeInUse > 4 && !alreadyChecking) {
        alreadyChecking = true;
        initCamera();
        _timer.cancel();
        await Future.delayed(const Duration(seconds: 10));
        initCamera();
      }
      log("Last time in use: $lastTimeInUse");
    });
  }

  void initCamera() async {
    description = await availableCameras().then(
      (cameras) => cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      ),
    );
    _cameraController = CameraController(
      description,
      ResolutionPreset.low,
      enableAudio: false,
    );
    await _cameraController.initialize();
    await Future.delayed(const Duration(milliseconds: 500));
    _cameraController.startImageStream((img) async {
      currentUseTime = DateTime.now();
      log("Image captures: ${img.width} x ${img.height}");
      // FlutterForegroundTask.updateService(
      //     notificationText:
      //         "Image Captured: ${img.sensorExposureTime} at ${DateTime.now()}");
    });
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      log('Is Camera Avaialble: ${await _cameraController.isCameraAvailable()}');
    });
  }

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    initCamera();
    // checkIfCameraInUse();
    // Timer.periodic(const Duration(seconds: 5), (timer) async {
    //   BgLauncher.bringAppToForeground(
    //       action: 'REQUEST_EXERCICE', extras: 'FBI OPEN UP');
    // });
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {}

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    await FlutterForegroundTask.clearAllData();
  }

  @override
  void onButtonPressed(String id) {
    _cameraController.destroyCamera();
    log('onButtonPressed >> $id -- $updateCount');
  }
}

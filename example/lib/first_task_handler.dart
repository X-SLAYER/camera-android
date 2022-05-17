import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

import 'package:camera_bg/camera.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class FirstTaskHandler extends TaskHandler {
  int updateCount = 0;
  int counter = 0;

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
      log("Image captures: ${img.width} x ${img.height}");
      FlutterForegroundTask.updateService(
          notificationText:
              "Image Captured: ${img.sensorExposureTime} at ${DateTime.now()}");
    });
  }

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    initCamera();
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {}

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    await FlutterForegroundTask.clearAllData();
  }

  @override
  void onButtonPressed(String id) {
    log('onButtonPressed >> $id -- $updateCount');
  }
}

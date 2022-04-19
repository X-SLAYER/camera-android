import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:system_alert_window/system_alert_window.dart';

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
      log("Image captures: ${img.width} x ${img.height} -- ${img.format.raw}");
    });
  }

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    initCamera();
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    // log("On Event");
    // FlutterForegroundTask.updateService(
    //   notificationTitle: 'FirstTaskHandler',
    //   notificationText: timestamp.toString(),
    // );

    // // Send data to the main isolate.
    // sendPort?.send(timestamp);
    // sendPort?.send(updateCount);

    // updateCount++;
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    // You can use the clearAllData function to clear all the stored data.
    await FlutterForegroundTask.clearAllData();
  }

  @override
  void onButtonPressed(String id) {
    // Called when the notification button on the Android platform is pressed.
    log('onButtonPressed >> $id -- $updateCount');
  }
}

SystemWindowHeader header = SystemWindowHeader(
  title: SystemWindowText(
    text: "Incoming Call",
    fontSize: 10,
    textColor: Colors.black45,
  ),
  padding: SystemWindowPadding.setSymmetricPadding(12, 12),
  subTitle: SystemWindowText(
    text: "9898989899",
    fontSize: 14,
    fontWeight: FontWeight.BOLD,
    textColor: Colors.black87,
  ),
  decoration: SystemWindowDecoration(startColor: Colors.grey[100]),
  button: SystemWindowButton(
      text: SystemWindowText(
          text: "Personal", fontSize: 10, textColor: Colors.black45),
      tag: "personal_btn"),
  buttonPosition: ButtonPosition.TRAILING,
);

SystemWindowFooter footer = SystemWindowFooter(
  buttons: [
    SystemWindowButton(
      text: SystemWindowText(
          text: "Simple button",
          fontSize: 12,
          textColor: const Color.fromRGBO(250, 139, 97, 1)),
      tag: "simple_button", //useful to identify button click event
      padding: SystemWindowPadding(left: 10, right: 10, bottom: 10, top: 10),
      width: 0,
      height: SystemWindowButton.WRAP_CONTENT,
      decoration: SystemWindowDecoration(
          startColor: Colors.white,
          endColor: Colors.white,
          borderWidth: 0,
          borderRadius: 0.0),
    ),
    SystemWindowButton(
      text: SystemWindowText(
          text: "Focus button", fontSize: 12, textColor: Colors.white),
      tag: "focus_button",
      width: 0,
      padding: SystemWindowPadding(left: 10, right: 10, bottom: 10, top: 10),
      height: SystemWindowButton.WRAP_CONTENT,
      decoration: SystemWindowDecoration(
          startColor: const Color.fromRGBO(250, 139, 97, 1),
          endColor: const Color.fromRGBO(247, 28, 88, 1),
          borderWidth: 0,
          borderRadius: 30.0),
    )
  ],
  padding: SystemWindowPadding(left: 16, right: 16, bottom: 12),
  decoration: SystemWindowDecoration(startColor: Colors.white),
  buttonsPosition: ButtonPosition.CENTER,
);

SystemWindowBody body = SystemWindowBody(
  rows: [
    EachRow(
      columns: [
        EachColumn(
          text: SystemWindowText(
              text: "Some body", fontSize: 12, textColor: Colors.black45),
        ),
      ],
      gravity: ContentGravity.CENTER,
    ),
  ],
  padding: SystemWindowPadding(left: 16, right: 16, bottom: 12, top: 12),
);

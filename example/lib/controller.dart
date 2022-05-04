import 'dart:developer';

import 'package:camera_bg/camera.dart';

class CamController {
  CamController._();

  static CameraController? cameraController;

  static Future<void> initCamera() async {
    final description = await availableCameras().then(
      (cameras) => cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      ),
    );
    cameraController = CameraController(
      description,
      ResolutionPreset.low,
      enableAudio: false,
    );
    cameraController?.initialize().whenComplete(() {
      log("Camera Initilized successfully: ${cameraController?.cameraId}");
    });

    // await Future.delayed(const Duration(milliseconds: 500));
    cameraController?.startImageStream((img) async {
      log("Image captures: ${img.width} x ${img.height} -- ${img.format.raw}");
    });
  }

  static void takeShot() async {
    final file = await cameraController?.takePicture();
    log("Picture has been taked: ${file?.name}");
  }

  static void stopCamera() {
    // _cameraController.stopImageStream();
  }
}

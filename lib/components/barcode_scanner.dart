import 'package:camera/camera.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarcodeScanner {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _controller = CameraController(
      camera,
      ResolutionPreset.high,
    );

    // Initialize the camera controller
    _initializeControllerFuture = _controller.initialize();
  }

  Future<String> scanBarcode() async {
    try {
      await _initializeControllerFuture; // Wait for the camera controller to initialize.
      final barcode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);

      return barcode;
    } catch (e) {
      return "";
    }
  }

  void dispose() {
    // Dispose of the camera controller when the widget is disposed.
    _controller.dispose();
  }
}

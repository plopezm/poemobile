import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:poemobile/src/providers/PictureMLScanner.dart';

class CameraPreviewPage extends StatefulWidget {
  final CameraDescription camera;
  final Function(VisionText) onPictureTaken;

  CameraPreviewPage({@required this.camera, @required this.onPictureTaken});

  @override
  State<StatefulWidget> createState() {
    return _CameraPreviewPageState();
  }
}

class _CameraPreviewPageState extends State<CameraPreviewPage> {
  CameraController _cameraController;
  Future<void> _initializeCameraControllerFuture;

  bool _isDetecting = false;
  final TextRecognizer _textRecognizer =
      FirebaseVision.instance.textRecognizer();

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(widget.camera, ResolutionPreset.max);
    _initializeCameraControllerFuture = _cameraController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeCameraControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_cameraController);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.photo_camera),
        onPressed: () {
          this._takePicture(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void _takePicture(BuildContext context) async {
    try {
      await _initializeCameraControllerFuture;
      _cameraController.startImageStream((CameraImage image) {
        if (_isDetecting) return;
        _isDetecting = true;

        ScannerUtils.detect(
          image: image,
          detectInImage: _getDetectionMethod(),
          imageRotation: widget.camera.sensorOrientation,
        ).then(
          (results) {
            widget.onPictureTaken(results);
          },
        ).whenComplete(() {
          _isDetecting = false;
          _cameraController?.dispose();
        });
      });
    } catch (e) {
      print(e);
    }
    Navigator.pop(context);
  }

  Future<VisionText> Function(FirebaseVisionImage image) _getDetectionMethod() {
    return _textRecognizer.processImage;
  }
}

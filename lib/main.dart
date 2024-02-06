import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera in WebView',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(cameras: cameras),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<CameraDescription> cameras;

  const HomeScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera in WebView'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WebViewWithCamera(cameras: cameras),
              ),
            );
          },
          child: Text('Open WebView with Camera'),
        ),
      ),
    );
  }
}

class WebViewWithCamera extends StatefulWidget {
  final List<CameraDescription> cameras;

  const WebViewWithCamera({Key? key, required this.cameras}) : super(key: key);

  @override
  _WebViewWithCameraState createState() => _WebViewWithCameraState();
}

class _WebViewWithCameraState extends State<WebViewWithCamera> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WebView with Camera')),
      body: InAppWebView(
        key: webViewKey,
        initialUrlRequest: URLRequest(
            url: WebUri(
                "https://platform.onmeta.in/kyc/?apiKey=6af803df-0e0e-4708-805f-87baa8653e97&userEmail=chetan.j@antino.com")),
        initialSettings: InAppWebViewSettings(
          mediaPlaybackRequiresUserGesture: false,
          allowsInlineMediaPlayback: true,
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onPermissionRequest: (controller, request) async {
          final resources = <PermissionResourceType>[];
          if (request.resources.contains(PermissionResourceType.CAMERA)) {
            final cameraStatus = await Permission.camera.request();
            if (!cameraStatus.isDenied) {
              resources.add(PermissionResourceType.CAMERA);
            }
          }
          if (request.resources.contains(PermissionResourceType.MICROPHONE)) {
            final microphoneStatus = await Permission.microphone.request();
            if (!microphoneStatus.isDenied) {
              resources.add(PermissionResourceType.MICROPHONE);
            }
          }
          // only for iOS and macOS
          if (request.resources
              .contains(PermissionResourceType.CAMERA_AND_MICROPHONE)) {
            final cameraStatus = await Permission.camera.request();
            final microphoneStatus = await Permission.microphone.request();
            if (!cameraStatus.isDenied && !microphoneStatus.isDenied) {
              resources.add(PermissionResourceType.CAMERA_AND_MICROPHONE);
            }
          }

          return PermissionResponse(
              resources: resources,
              action: resources.isEmpty
                  ? PermissionResponseAction.DENY
                  : PermissionResponseAction.GRANT);
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

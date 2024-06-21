import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  bool isFlashOn = false;

  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            height: 45,
            color: Colors.black,
            child: Row(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                GestureDetector(
                    onTap: ()async {
                      await controller?.flipCamera();
                      setState(() {});
                    },
                    child: Icon(Icons.flip_camera_ios_rounded ,  size: 35, color: Colors.white,)),
                GestureDetector(
                  onTap: () async {
                    await controller?.toggleFlash();
                    setState(() {
                      isFlashOn = !isFlashOn; // Toggle flash status
                    });
                  },
                  child: Icon(
                    isFlashOn ? Icons.flash_on : Icons.flash_off,
                    size: 35,
                    color: Colors.white,
                  ),
                ),

                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Text('Cancel', style: TextStyle(
                      fontSize: 18,
                      color: Colors.white
                  ),),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 350.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.take(1).listen((scanData) {
      setState(() {
        result = scanData;
        Navigator.pop(context, result?.code); // Pass the result back to the previous screen
      });

      // Pause the camera after scanning a barcode
      controller.pauseCamera();
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

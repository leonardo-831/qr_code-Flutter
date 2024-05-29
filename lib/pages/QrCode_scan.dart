import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:qr_code/database/database_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';

class QRCodeScan extends StatefulWidget {
  const QRCodeScan({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRCodeScanState();
}

class _QRCodeScanState extends State<QRCodeScan> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

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
      appBar: AppBar(
        title: const Text(
          'Escanear QR Code',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red[800],
        elevation: 10,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 3, child: _buildQrView(context)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                        'Tipo de Código: ${describeEnum(result!.format)}   data: ${result!.code}')
                  else
                    const Text('Escaneie um QrCode'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await controller?.toggleFlash();
                            setState(() {});
                          },
                          icon: FutureBuilder(
                            future: controller?.getFlashStatus(),
                            builder: (context, snapshot) {
                              return Icon(
                                snapshot.data == true
                                    ? Icons.flash_on
                                    : Icons.flash_off,
                                color: Colors.white,
                              );
                            },
                          ),
                          label: FutureBuilder(
                            future: controller?.getFlashStatus(),
                            builder: (context, snapshot) {
                              return Text(
                                'Flash: ${snapshot.data == true ? 'Ligado' : 'Desligado'}',
                                style: const TextStyle(color: Colors.white),
                              );
                            },
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await controller?.flipCamera();
                            setState(() {});
                          },
                          icon: const Icon(Icons.flip_camera_android,
                              color: Colors.white),
                          label: FutureBuilder(
                            future: controller?.getCameraInfo(),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return Text(
                                  'Câmera ${describeEnum(snapshot.data!) == 'back' ? 'traseira' : 'frontal'}',
                                  style: const TextStyle(color: Colors.white),
                                );
                              } else {
                                return const Text('Carregando...',
                                    style: TextStyle(color: Colors.white));
                              }
                            },
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[800],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 300.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: const Color.fromARGB(255, 198, 40, 40),
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
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code != null) {
        try {
          final data = jsonDecode(scanData.code!);
          final id = data['id'];
          final token = data['token'];

          if (id != null) {
            final eventSubscription =
                await DatabaseService().getEventSubscriptionById(id);

            if (eventSubscription != null && eventSubscription.token == token) {
              eventSubscription.presence = 1;
              await DatabaseService()
                  .updateEventSubscription(eventSubscription);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Presença confirmada para ${eventSubscription.aluno}'),
                    backgroundColor: const Color.fromARGB(255, 31, 216, 40)),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Inscrição não encontrada ou token inválido'),
                    backgroundColor: Color.fromARGB(255, 197, 63, 63)),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('QR Code inválido'),
                  backgroundColor: Color.fromARGB(255, 197, 63, 63)),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Falha ao tentar ler o QrCode.'),
                backgroundColor: Color.fromARGB(255, 197, 63, 63)),
          );
        } finally {
          controller.pauseCamera();
          Navigator.pop(context);
        }
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sem Permissão')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

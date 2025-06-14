import 'package:dr_ai/core/utils/constant/api_url.dart';
import 'package:dr_ai/core/utils/helper/scaffold_snakbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:dr_ai/core/service/nfc_service.dart';
import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';

import '../../../controller/medical_record/medical_record_cubit.dart';
import '../../../core/utils/theme/color.dart';
import '../../../core/utils/permission_manager.dart';

class NFCScreen extends StatefulWidget {
  final String? id;

  const NFCScreen({super.key, this.id});

  @override
  State<NFCScreen> createState() => _NFCScreenState();
}

class _NFCScreenState extends State<NFCScreen> {
  late WebViewController _controller;
  late final MedicalRecordCubit _cubit;
  bool _isLoading = true;
  final NfcService _nfcService = NfcService();
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _cubit = MedicalRecordCubit();

    if (widget.id != null) {
      _cubit.updateWebViewId(widget.id!);
    } else {
      _cubit.initWebView();
    }

    _setupWebViewController();
  }

  void _setupWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            log('WebView error: ${error.description}');
          },
        ),
      );

    _controller.loadRequest(Uri.parse(_cubit.initialUrl));
  }

  Future<void> _scanNFC() async {
    setState(() {
      _isScanning = true;
    });

    bool isAvailable = await _nfcService.isNfcAvailable();

    if (!isAvailable) {
      customSnackBar(context, 'NFC is not available on this device');
      setState(() {
        _isScanning = false;
      });
      return;
    }

    await _nfcService.readNfcData(
      onTagDiscovered: (data) {
        setState(() {
          _isScanning = false;
        });

        String? nfcId = data['tagId'];
        log('NFC Tag ID from service: $nfcId');

        if (nfcId != null && nfcId.isNotEmpty) {
          _cubit.updateWebViewId(nfcId);
          final url = '${_cubit.baseUrl}$nfcId';
          log('Loading WebView URL: $url');
          _controller.loadRequest(Uri.parse(url));
          _cubit.nfcID = nfcId;
          setState(() {});
          customSnackBar(context, 'NFC tag read successfully: ID $nfcId');
        } else {
          customSnackBar(context, 'Could not find ID in NFC tag');
        }
      },
      onError: (error) {
        setState(() {
          _isScanning = false;
        });
        customSnackBar(context, 'Error: $error', ColorManager.error);
      },
      onTimeout: () {
        setState(() {
          _isScanning = false;
        });
        customSnackBar(context, 'NFC scan timed out');
      },
    );
  }

  Future<void> _downloadPDF(String url) async {
    setState(() {
      _isLoading = true;
    });

    try {
      customSnackBar(context, 'Starting PDF download...');

      final permissionManager = PermissionManager();
      bool permissionGranted = await permissionManager.requestPermission();

      if (permissionGranted) {
        Directory? directory;
        if (Platform.isAndroid) {
          try {
            directory = Directory('/storage/emulated/0/Download');
            if (!await directory.exists()) {
              await directory.create(recursive: true);
            }
          } catch (e) {
            log('Error accessing Download directory: $e');
            directory = await getExternalStorageDirectory();
            if (directory == null) {
              throw Exception('Could not access external storage');
            }
          }
        } else {
          directory = await getApplicationDocumentsDirectory();
        }

        String fileName =
            'medical_record_${DateTime.now().millisecondsSinceEpoch}.pdf';
        String filePath = '${directory.path}/$fileName';

        log('Downloading PDF to: $filePath');

        final dio = Dio();

        try {
          final response = await dio.get(
            url,
            options: Options(
              responseType: ResponseType.bytes,
              followRedirects: true,
              validateStatus: (status) => status != null && status < 500,
              headers: {
                'Accept': '*/*',
                'User-Agent':
                    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36',
              },
            ),
          );

          if (response.statusCode == 200) {
            final file = File(filePath);
            await file.writeAsBytes(response.data);
            if (await file.exists() && await file.length() > 0) {
              log('File downloaded successfully to: ${file.path} with size: ${await file.length()} bytes');

              customSnackBar(context, 'PDF downloaded to: ${file.path}',
                  ColorManager.green);
            } else {
              throw Exception('File was created but is empty or invalid');
            }
          } else {
            throw Exception('Failed to download file: ${response.statusCode}');
          }
        } catch (dioError) {
          log('Initial download method failed: $dioError');
          log('Trying alternative download method...');

          try {
            await dio.download(url, filePath,
                options: Options(
                  followRedirects: true,
                  validateStatus: (status) => status != null && status < 500,
                ), onReceiveProgress: (received, total) {
              if (total != -1) {
                final progress = (received / total * 100).toStringAsFixed(0);
                log('Download progress: $progress%');
              }
            });

            final file = File(filePath);
            if (await file.exists() && await file.length() > 0) {
              log('File downloaded successfully with alternative method. Size: ${await file.length()} bytes');
              customSnackBar(context, 'PDF downloaded to: ${file.path}',
                  ColorManager.green);
            } else {
              throw Exception(
                  'Alternative download failed: File is empty or invalid');
            }
          } catch (alternativeError) {
            throw Exception('All download attempts failed: $alternativeError');
          }
        }
      } else {
        customSnackBar(
            context,
            'Storage permission denied. Please enable in settings.',
            ColorManager.error);
        openAppSettings();
      }
    } catch (e) {
      log('Error downloading PDF: $e');
      customSnackBar(context, 'Error downloading PDF: ${e.toString()}',
          ColorManager.error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: WebViewWidget(controller: _controller)),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: ColorManager.green,
              ),
            ),
          if (_isScanning)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: ColorManager.green,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Scanning NFC...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            top: 40.h,
            right: 8,
            child: FloatingActionButton.small(
              heroTag: 'refreshButton',
              shape: CircleBorder(),
              backgroundColor: ColorManager.green,
              onPressed: () => _controller.reload(),
              child: const Icon(Icons.refresh, color: ColorManager.white),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'nfcButton',
            backgroundColor: ColorManager.green,
            onPressed: _isScanning ? null : _scanNFC,
            child: const Icon(Icons.nfc, color: ColorManager.white),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'saveButton',
            backgroundColor:
                (_cubit.nfcID != null || _cubit.nfcID?.isNotEmpty == true)
                    ? ColorManager.green
                    : ColorManager.grey,
            onPressed: _cubit.nfcID != null
                ? () {
                    String pdfUrl =
                        '${EnvManager.medicalRecordPdfBackend}${_cubit.nfcID}/generate-pdf/';
                    _downloadPDF(pdfUrl);
                  }
                : null,
            child: const Icon(Icons.save, color: ColorManager.white),
          ),
        ],
      ),
    );
  }
}

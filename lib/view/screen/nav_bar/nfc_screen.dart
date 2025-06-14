import 'package:dr_ai/core/utils/constant/api_url.dart';
import 'package:dr_ai/core/utils/helper/scaffold_snakbar.dart';
import 'package:dr_ai/core/utils/helper/download_dialog.dart';
import 'package:dr_ai/view/widget/button_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:dr_ai/core/service/nfc_service.dart';
import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_filex/open_filex.dart';

import '../../../controller/medical_record/medical_record_cubit.dart';
import '../../../core/utils/theme/color.dart';
import '../../../core/utils/helper/permission_manager.dart';
import '../../../core/utils/helper/custom_dialog.dart';
import '../../../core/utils/constant/image.dart';
import '../../widget/custom_tooltip.dart';

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
  String? _downloadedFilePath;
  bool _isFileDownloaded = false;

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

    bool isCancelled = false;
    CancelToken cancelToken = CancelToken();

    Function? updateDialog;

    try {
      showDownloadProgressDialog(
        context: context,
        initialMessage: 'Preparing to download PDF...',
        onControllerReady: (updateFn) {
          updateDialog = updateFn;
        },
        onCancel: () {
          isCancelled = true;
          cancelToken.cancel('Download cancelled by user');
          Navigator.of(context, rootNavigator: true).pop();
          _showMessageDialog(
              context, 'Download Cancelled', 'Download operation was cancelled',
              isError: true);
        },
        onOpen: () {
          Navigator.of(context, rootNavigator: true).pop();
          _openDownloadedFile();
        },
      );

      await Future.delayed(Duration(milliseconds: 200));

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
        updateDialog?.call(0.05, 'Establishing connection...', false);

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
            cancelToken: cancelToken,
            onReceiveProgress: (received, total) {
              if (total != -1 && !isCancelled) {
                final progress = received / total;
                updateDialog?.call(
                    progress,
                    'Downloading PDF... ${(progress * 100).toStringAsFixed(0)}%',
                    false);
              }
            },
          );

          if (response.statusCode == 200) {
            final file = File(filePath);
            updateDialog?.call(0.95, 'Saving file...', false);
            await file.writeAsBytes(response.data);

            if (await file.exists() && await file.length() > 0) {
              log('File downloaded successfully to: ${file.path} with size: ${await file.length()} bytes');

              _downloadedFilePath = file.path;
              _isFileDownloaded = true;

              updateDialog?.call(
                  1.0, 'PDF downloaded successfully to Downloads folder', true);

              setState(() {});
            } else {
              throw Exception('File was created but is empty or invalid');
            }
          } else {
            throw Exception('Failed to download file: ${response.statusCode}');
          }
        } catch (dioError) {
          if (isCancelled) {
            return;
          }

          log('Initial download method failed: $dioError');
          log('Trying alternative download method...');

          updateDialog?.call(
              0.1, 'Trying alternative download method...', false);

          try {
            await dio.download(
              url,
              filePath,
              options: Options(
                followRedirects: true,
                validateStatus: (status) => status != null && status < 500,
              ),
              cancelToken: cancelToken,
              onReceiveProgress: (received, total) {
                if (total != -1 && !isCancelled) {
                  final progress = received / total;
                  updateDialog?.call(
                      progress,
                      'Downloading PDF... ${(progress * 100).toStringAsFixed(0)}%',
                      false);
                }
              },
            );

            final file = File(filePath);
            if (await file.exists() && await file.length() > 0) {
              log('File downloaded successfully with alternative method. Size: ${await file.length()} bytes');

              _downloadedFilePath = file.path;
              _isFileDownloaded = true;

              updateDialog?.call(
                  1.0, 'PDF downloaded successfully to Downloads folder', true);

              setState(() {});
            } else {
              throw Exception(
                  'Alternative download failed: File is empty or invalid');
            }
          } catch (alternativeError) {
            if (isCancelled) {
              return;
            }
            throw Exception('All download attempts failed: $alternativeError');
          }
        }
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        _showMessageDialog(context, 'Permission Error',
            'Storage permission denied. Please enable in settings.',
            isError: true);
        openAppSettings();
      }
    } catch (e) {
      if (!isCancelled) {
        log('Error downloading PDF: $e');
        Navigator.of(context, rootNavigator: true).pop();
        _showMessageDialog(
            context, 'Download Error', 'Error downloading PDF: ${e.toString()}',
            isError: true);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _openDownloadedFile() async {
    if (_downloadedFilePath != null) {
      try {
        final file = File(_downloadedFilePath!);
        if (await file.exists()) {
          try {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  insetPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                  backgroundColor: ColorManager.white,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 24.h, horizontal: 16),
                    decoration: BoxDecoration(
                      color: ColorManager.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "PDF File",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorManager.green,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Your medical record PDF has been downloaded to:",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14.sp, color: ColorManager.grey),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: ColorManager.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: ColorManager.green,
                              width: 1,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          child: Text(
                            file.path,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: ColorManager.green,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 10,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await Share.shareXFiles(
                                  [XFile(file.path)],
                                  text: 'Medical Record',
                                  subject: 'Medical Record PDF',
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.green,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 8.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.share, size: 16.w),
                                  SizedBox(width: 8.w),
                                  Text("Share"),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                _openFileWithOptions(file);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.green,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 8.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.open_with, size: 16.w),
                                  SizedBox(width: 8.w),
                                  Text("Open With"),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.error,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 8.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.cancel, size: 16.w),
                                  SizedBox(width: 8.w),
                                  Text("Cancel"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } catch (e) {
            log('Error opening file with share dialog: $e');
            _showMessageDialog(
                context, 'Error', 'Error opening file: ${e.toString()}',
                isError: true);
          }
        } else {
          _showMessageDialog(context, 'Error', 'File does not exist anymore',
              isError: true);
        }
      } catch (e) {
        log('Error opening file: $e');
        _showMessageDialog(
            context, 'Error', 'Error opening file: ${e.toString()}',
            isError: true);
      }
    }
  }

  void _openFileWithOptions(File file) async {
    try {
      await OpenFilex.open(
        file.path,
        type: 'application/pdf',
      );
    } catch (e) {
      log('Error opening file with options: $e');
      _showMessageDialog(
          context, 'Error', 'Error opening file: ${e.toString()}',
          isError: true);
    }
  }

  void _showMessageDialog(BuildContext context, String title, String message,
      {bool isError = false}) {
    customDialog(
      context,
      title: title,
      errorMessage: message,
      subtitle: '',
      buttonTitle: 'Cancel',
      onPressed: () => Navigator.of(context).pop(),
      image: isError ? ImageManager.errorIcon : ImageManager.trueIcon,
      dismiss: true,
    );
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
          // if (_isLoading)
          //   const Center(
          //     child: CircularProgressIndicator(
          //       color: ColorManager.green,
          //     ),
          //   ),
          if (_isScanning)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  ButtonLoadingIndicator(),
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
            child: CustomToolTip(
              bottomMargin: 20,
              message: 'Reload',
              child: FloatingActionButton.small(
                heroTag: 'refreshButton',
                shape: CircleBorder(),
                backgroundColor: ColorManager.green,
                onPressed: () => _controller.reload(),
                child: const Icon(Icons.refresh, color: ColorManager.white),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomToolTip(
            bottomMargin: 20,
            message: 'Share PDF',
            child: FloatingActionButton.small(
              heroTag: 'openFileButton',
              backgroundColor:
                  _isFileDownloaded ? ColorManager.green : ColorManager.grey,
              onPressed: _isFileDownloaded ? _openDownloadedFile : null,
              child: const Icon(Icons.open_in_new, color: ColorManager.white),
            ),
          ),
          Gap(10.h),
          CustomToolTip(
            bottomMargin: 20,
            message: 'Download PDF',
            child: FloatingActionButton.small(
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
          ),
          Gap(10.h),
          CustomToolTip(
            bottomMargin: 20,
            message: 'Scan NFC',
            child: FloatingActionButton(
              heroTag: 'nfcButton',
              backgroundColor: ColorManager.green,
              onPressed: _isScanning ? null : _scanNFC,
              child: const Icon(Icons.nfc, color: ColorManager.white),
            ),
          ),
        ],
      ),
    );
  }
}

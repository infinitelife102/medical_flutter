import 'package:dr_ai/core/utils/helper/extention.dart';
import 'package:dr_ai/core/utils/helper/scaffold_snakbar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:dr_ai/core/service/nfc_service.dart';
import 'dart:developer';

import '../../../controller/medical_record/medical_record_cubit.dart';
import '../../../core/utils/theme/color.dart';

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
  late ScrollController _scrollController;
  bool _canRefresh = false;
  final NfcService _nfcService = NfcService();
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _cubit = MedicalRecordCubit();
    _scrollController = ScrollController();

    if (widget.id != null) {
      _cubit.updateWebViewId(widget.id!);
    } else {
      _cubit.initWebView();
    }

    _setupWebViewController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: ColorManager.green,
    //   statusBarIconBrightness: Brightness.dark,
    //   statusBarBrightness: Brightness.light,
    //   systemNavigationBarColor: ColorManager.white,
    //   systemNavigationBarIconBrightness: Brightness.dark,
    // ));

    final screenHeight = MediaQuery.of(context).size.height;
    final refreshThreshold = screenHeight * 0.2;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          if (_canRefresh) {
            await _controller.reload();
          }
          return Future.value();
        },
        color: ColorManager.green,
        backgroundColor: Colors.white,
        displacement: 40,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollUpdateNotification) {
              _canRefresh = notification.metrics.pixels <= refreshThreshold;
            }
            return false;
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: context.height,
              child: Stack(
                children: [
                  WebViewWidget(controller: _controller),
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
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'nfcButton',
            backgroundColor: ColorManager.green,
            onPressed: _isScanning ? null : _scanNFC,
            child: const Icon(Icons.nfc, color: ColorManager.white),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'saveButton',
            backgroundColor: ColorManager.green,
            onPressed: () {},
            child: const Icon(Icons.save, color: ColorManager.white),
          ),
        ],
      ),
    );
  }
}

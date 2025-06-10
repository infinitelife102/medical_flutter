import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:dr_ai/controller/webview/webview_cubit.dart';

import '../../../core/utils/theme/color.dart';

class NFCScreen extends StatefulWidget {
  final String? id;

  const NFCScreen({super.key, this.id});

  @override
  State<NFCScreen> createState() => _NFCScreenState();
}

class _NFCScreenState extends State<NFCScreen> {
  late WebViewController _controller;
  late final WebViewCubit _cubit;
  bool _isLoading = true;
  late ScrollController _scrollController;
  bool _canRefresh = false;

  @override
  void initState() {
    super.initState();
    _cubit = WebViewCubit();
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
            debugPrint('WebView error: ${error.description}');
          },
        ),
      );

    final initialUrl =
        'https://rj8vq174-5173.uks1.devtunnels.ms/record/a18a2476-942d-423e-9a04-14443705db60';
    _controller.loadRequest(Uri.parse(initialUrl));
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
    final refreshThreshold = screenHeight * 0.2; // 20% of screen height

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
            // Only allow refresh if scroll position is at the top 20% of the screen
            if (notification is ScrollUpdateNotification) {
              _canRefresh = notification.metrics.pixels <= refreshThreshold;
            }
            return false;
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  WebViewWidget(controller: _controller),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        color: ColorManager.green,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorManager.green,
        onPressed: () {},
        child: const Icon(Icons.save, color: ColorManager.white),
      ),
    );
  }
}

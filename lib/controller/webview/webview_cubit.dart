import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'webview_state.dart';

class WebViewCubit extends Cubit<WebViewState> {
  WebViewCubit() : super(WebViewState.initial());

  static const String _baseUrl = 'https://rj8vq174-5173.uks1.devtunnels.ms/record/';
  static const String defaultId = 'a18a2476942d423e9a0414443705db60';

  // Getter to expose baseUrl
  String get baseUrl => _baseUrl;

  void initWebView() {
    emit(state.copyWith(url: '$_baseUrl$defaultId'));
  }

  void updateWebViewId(String id) {
    if (id.isNotEmpty) {
       log("ANA EL ID: $id");
      emit(state.copyWith(url: '$_baseUrl$id'));
    } else {
      emit(state.copyWith(url: '$_baseUrl$defaultId'));
    }
  }
}

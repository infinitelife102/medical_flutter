import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'webview_state.dart';

class WebViewCubit extends Cubit<WebViewState> {
  WebViewCubit() : super(WebViewState.initial());

  static const String baseUrl = 'https://rj8vq174-5173.uks1.devtunnels.ms/record/';
  static const String defaultId = 'a18a2476-942d-423e-9a04-14443705db60';

  void initWebView() {
    emit(state.copyWith(url: '$baseUrl$defaultId'));
  }

  void updateWebViewId(String id) {
    if (id.isNotEmpty) {
      emit(state.copyWith(url: '$baseUrl$id'));
    } else {
      emit(state.copyWith(url: '$baseUrl$defaultId'));
    }
  }
}

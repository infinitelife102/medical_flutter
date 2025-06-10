part of 'webview_cubit.dart';

class WebViewState extends Equatable {
  final String url;
  final bool isLoading;

  const WebViewState({required this.url, required this.isLoading});

  factory WebViewState.initial() {
    return const WebViewState(
      url: '',
      isLoading: true,
    );
  }

  WebViewState copyWith({
    String? url,
    bool? isLoading,
  }) {
    return WebViewState(
      url: url ?? this.url,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [url, isLoading];
}

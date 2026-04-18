
class MapScreenState {

  const MapScreenState({
    this.isWebViewReady = false,
    this.processedMapUrl,
  });
  final bool isWebViewReady;
  final String? processedMapUrl;

  MapScreenState copyWith({
    bool? isWebViewReady,
    String? processedMapUrl,
  }) {
    return MapScreenState(
      isWebViewReady: isWebViewReady ?? this.isWebViewReady,
      processedMapUrl: processedMapUrl ?? this.processedMapUrl,
    );
  }
}

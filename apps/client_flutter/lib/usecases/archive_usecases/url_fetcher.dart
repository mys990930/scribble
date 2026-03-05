class FetchResult {
  final String? title;
  final String? body;
  final String? imageUrl;
  final bool success;

  const FetchResult({
    required this.title,
    required this.body,
    required this.imageUrl,
    required this.success,
  });
}

abstract class UrlFetcher {
  Future<FetchResult> fetch(String url);
}

import 'package:scribble/usecases/archive_usecases/url_fetcher.dart';

class DefaultUrlFetcher implements UrlFetcher {
  const DefaultUrlFetcher();

  @override
  Future<FetchResult> fetch(String url) async {
    return const FetchResult(
      title: null,
      body: null,
      imageUrl: null,
      success: false,
    );
  }
}

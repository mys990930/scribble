import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scribble/adapters/api_client/api_memo_service.dart';
import 'package:scribble/usecases/memo_usecases/memo_service.dart';

MemoService createMemoService(Ref ref) {
  return ApiMemoService();
}

import 'package:flutter_test/flutter_test.dart';
import 'package:scribble/domain/archive_domain/archive_domain.dart';
import 'package:scribble/shared/kernel/app_error.dart';

void main() {
  group('ArchiveEntry.create', () {
    test('URL + image 정상 수집은 full로 생성된다', () {
      final entry = ArchiveEntry.create(
        id: 'a1',
        url: 'https://example.com',
        title: 'Title',
        body: 'Body',
        imageUrl: 'https://example.com/image.png',
        category: 'article',
        captureType: CaptureType.full,
        createdAt: DateTime(2026, 3, 5),
      );

      expect(entry.captureType, CaptureType.full);
      expect(entry.url, isNotNull);
      expect(entry.imageUrl, isNotNull);
    });

    test('URL만 있는 경우 fallback으로 생성된다', () {
      final entry = ArchiveEntry.create(
        id: 'a2',
        url: 'https://example.com',
        title: 'Title',
        body: '',
        imageUrl: null,
        category: 'link',
        captureType: CaptureType.fallback,
        createdAt: DateTime(2026, 3, 5),
      );

      expect(entry.captureType, CaptureType.fallback);
      expect(entry.imageUrl, isNull);
    });

    test('직접 입력은 manual로 생성된다', () {
      final entry = ArchiveEntry.create(
        id: 'a3',
        url: null,
        title: '',
        body: '직접 입력',
        imageUrl: null,
        category: 'custom',
        captureType: CaptureType.manual,
        createdAt: DateTime(2026, 3, 5),
      );

      expect(entry.captureType, CaptureType.manual);
      expect(entry.url, isNull);
    });

    test('title/body가 모두 빈 문자열이면 ARCHIVE_EMPTY_CONTENT 에러', () {
      expect(
        () => ArchiveEntry.create(
          id: 'a4',
          url: null,
          title: '   ',
          body: '   ',
          imageUrl: null,
          category: 'custom',
          captureType: CaptureType.manual,
          createdAt: DateTime(2026, 3, 5),
        ),
        throwsA(
          isA<AppError>().having(
            (e) => e.code,
            'code',
            'ARCHIVE_EMPTY_CONTENT',
          ),
        ),
      );
    });

    test('category가 빈 문자열이면 ARCHIVE_INVALID_CATEGORY 에러', () {
      expect(
        () => ArchiveEntry.create(
          id: 'a5',
          url: null,
          title: 'Title',
          body: '',
          imageUrl: null,
          category: '   ',
          captureType: CaptureType.manual,
          createdAt: DateTime(2026, 3, 5),
        ),
        throwsA(
          isA<AppError>().having(
            (e) => e.code,
            'code',
            'ARCHIVE_INVALID_CATEGORY',
          ),
        ),
      );
    });

    test('url null + body 있음은 허용된다', () {
      final entry = ArchiveEntry.create(
        id: 'a6',
        url: null,
        title: '',
        body: '본문 있음',
        imageUrl: null,
        category: 'custom-anything',
        captureType: CaptureType.manual,
        createdAt: DateTime(2026, 3, 5),
      );

      expect(entry.url, isNull);
      expect(entry.body, '본문 있음');
    });
  });
}

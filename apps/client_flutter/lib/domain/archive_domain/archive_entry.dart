import 'package:scribble/domain/archive_domain/archive_errors.dart';

/// Archive 수집 엔트리 도메인 모델.
class ArchiveEntry {
  final String id;
  final String? url;
  final String title;
  final String body;
  final String? imageUrl;
  final String category;
  final CaptureType captureType;
  final DateTime createdAt;

  const ArchiveEntry({
    required this.id,
    required this.url,
    required this.title,
    required this.body,
    required this.imageUrl,
    required this.category,
    required this.captureType,
    required this.createdAt,
  });

  factory ArchiveEntry.create({
    required String id,
    String? url,
    required String title,
    required String body,
    String? imageUrl,
    required String category,
    required CaptureType captureType,
    required DateTime createdAt,
  }) {
    final normalizedTitle = title.trim();
    final normalizedBody = body.trim();
    final normalizedCategory = category.trim();

    if (normalizedTitle.isEmpty && normalizedBody.isEmpty) {
      throw archiveEmptyContentError();
    }
    if (normalizedCategory.isEmpty) {
      throw archiveInvalidCategoryError();
    }

    return ArchiveEntry(
      id: id,
      url: url,
      title: normalizedTitle,
      body: normalizedBody,
      imageUrl: imageUrl,
      category: normalizedCategory,
      captureType: captureType,
      createdAt: createdAt,
    );
  }

  bool get hasContent => title.isNotEmpty || body.isNotEmpty;

  ArchiveEntry copyWith({
    String? id,
    String? url,
    String? title,
    String? body,
    String? imageUrl,
    bool clearImageUrl = false,
    String? category,
    CaptureType? captureType,
    DateTime? createdAt,
  }) {
    return ArchiveEntry(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: clearImageUrl ? null : (imageUrl ?? this.imageUrl),
      category: category ?? this.category,
      captureType: captureType ?? this.captureType,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum CaptureType {
  full,
  fallback,
  manual,
}

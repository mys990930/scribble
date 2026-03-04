import 'package:uuid/uuid.dart';

/// 엔티티 식별자 타입 별칭.
typedef EntityId = String;

const _uuid = Uuid();

/// 새로운 UUID v4 기반 EntityId를 생성한다.
EntityId newId() => _uuid.v4();

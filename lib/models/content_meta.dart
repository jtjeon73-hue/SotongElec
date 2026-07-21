/// 법령·기술기준·학습자료의 출처 및 검토 메타데이터
class ContentMeta {
  const ContentMeta({
    required this.source,
    required this.standardYear,
    required this.applicableExam,
    required this.createdAt,
    required this.reviewedAt,
    required this.verifiedAt,
    this.isLatest = true,
    this.needsReview = false,
    this.revisionHistory = const [],
  });

  final String source;
  final String standardYear;
  final String applicableExam;
  final String createdAt;
  final String reviewedAt;
  final String verifiedAt;
  final bool isLatest;
  final bool needsReview;
  final List<String> revisionHistory;

  Map<String, dynamic> toJson() => {
    'source': source,
    'standardYear': standardYear,
    'applicableExam': applicableExam,
    'createdAt': createdAt,
    'reviewedAt': reviewedAt,
    'verifiedAt': verifiedAt,
    'isLatest': isLatest,
    'needsReview': needsReview,
    'revisionHistory': revisionHistory,
  };

  factory ContentMeta.fromJson(Map<String, dynamic> json) => ContentMeta(
    source: json['source'] as String? ?? '',
    standardYear: json['standardYear'] as String? ?? '',
    applicableExam: json['applicableExam'] as String? ?? '',
    createdAt: json['createdAt'] as String? ?? '',
    reviewedAt: json['reviewedAt'] as String? ?? '',
    verifiedAt: json['verifiedAt'] as String? ?? '',
    isLatest: json['isLatest'] as bool? ?? true,
    needsReview: json['needsReview'] as bool? ?? false,
    revisionHistory:
        (json['revisionHistory'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        const [],
  );
}

enum ImportanceBadge {
  mustMemorize,
  frequentlyAsked,
  calculationEssential,
  conceptual,
  practicalLinked,
  regulationLatest,
}

extension ImportanceBadgeLabel on ImportanceBadge {
  String get label => switch (this) {
    ImportanceBadge.mustMemorize => '반드시 암기',
    ImportanceBadge.frequentlyAsked => '자주 출제',
    ImportanceBadge.calculationEssential => '계산 필수',
    ImportanceBadge.conceptual => '개념 이해',
    ImportanceBadge.practicalLinked => '실기 연계',
    ImportanceBadge.regulationLatest => '법규 최신 확인',
  };
}

enum Difficulty { easy, medium, hard }

extension DifficultyLabel on Difficulty {
  String get label => switch (this) {
    Difficulty.easy => '하',
    Difficulty.medium => '중',
    Difficulty.hard => '상',
  };
}

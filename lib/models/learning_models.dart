import 'content_meta.dart';

class Lesson {
  const Lesson({
    required this.id,
    required this.subjectId,
    required this.chapter,
    required this.section,
    required this.title,
    required this.objectives,
    required this.importance,
    required this.difficulty,
    required this.estimatedMinutes,
    required this.summary,
    required this.theory,
    required this.formulas,
    required this.symbolMeanings,
    required this.units,
    required this.conditions,
    required this.derivation,
    required this.example,
    required this.steps,
    required this.commonMistakes,
    required this.fieldUse,
    required this.checkQuestionIds,
    required this.relatedFormulaIds,
    required this.relatedQuestionIds,
    this.meta,
    this.track = 'written',
    this.prerequisites = const [],
    this.easyExplain = '',
    this.examTrends = const [],
    this.confusableConcepts = const [],
    this.practicalLink = '',
    this.relatedTermIds = const [],
    this.tags = const [],
  });

  final String id;
  final String subjectId;
  final String chapter;
  final String section;
  final String title;
  final List<String> objectives;
  final List<ImportanceBadge> importance;
  final Difficulty difficulty;
  final int estimatedMinutes;
  final String summary;
  final String theory;
  final List<String> formulas;
  final Map<String, String> symbolMeanings;
  final Map<String, String> units;
  final String conditions;
  final String derivation;
  final String example;
  final List<String> steps;
  final List<String> commonMistakes;
  final String fieldUse;
  final List<String> checkQuestionIds;
  final List<String> relatedFormulaIds;
  final List<String> relatedQuestionIds;
  final ContentMeta? meta;

  /// written | practical
  final String track;
  final List<String> prerequisites;
  final String easyExplain;
  final List<String> examTrends;
  final List<String> confusableConcepts;
  final String practicalLink;
  final List<String> relatedTermIds;
  final List<String> tags;
}

class FormulaItem {
  const FormulaItem({
    required this.id,
    required this.name,
    required this.latex,
    required this.meaning,
    required this.variables,
    required this.units,
    required this.conditions,
    required this.variants,
    required this.mnemonic,
    required this.example,
    required this.unitTraps,
    required this.subjectId,
    required this.chapter,
    required this.importance,
    required this.relatedLessonIds,
    required this.relatedQuestionIds,
    this.writtenPracticalLinked = false,
    this.readable = '',
    this.steps = const [],
    this.tags = const [],
  });

  final String id;
  final String name;
  final String latex;
  final String meaning;
  final Map<String, String> variables;
  final Map<String, String> units;
  final String conditions;
  final List<String> variants;
  final String mnemonic;
  final String example;
  final List<String> unitTraps;
  final String subjectId;
  final String chapter;
  final List<ImportanceBadge> importance;
  final List<String> relatedLessonIds;
  final List<String> relatedQuestionIds;
  final bool writtenPracticalLinked;

  /// 사람이 읽기 쉬운 수식 표현
  final String readable;
  final List<String> steps;
  final List<String> tags;
}

class Question {
  const Question({
    required this.id,
    required this.examType,
    required this.subjectId,
    required this.chapter,
    required this.section,
    required this.questionType,
    required this.trend,
    required this.difficulty,
    required this.importance,
    required this.stem,
    required this.choices,
    required this.answerIndex,
    required this.explanation,
    required this.calculationSteps,
    required this.wrongReasons,
    required this.relatedFormulaIds,
    required this.relatedLessonIds,
    required this.tags,
    required this.sourceType,
    required this.isPublic,
    required this.createdAt,
    required this.reviewedAt,
    required this.verifiedAt,
    this.needsReview = false,
    this.estimatedSeconds = 90,
    this.choiceExplanations = const [],
  });

  final String id;
  final String examType; // written | practical
  final String subjectId;
  final String chapter;
  final String section;
  final String questionType;
  final String trend;
  final Difficulty difficulty;
  final List<ImportanceBadge> importance;
  final String stem;
  final List<String> choices;
  final int answerIndex;
  final String explanation;
  final List<String> calculationSteps;
  final List<String> wrongReasons;
  final List<String> relatedFormulaIds;
  final List<String> relatedLessonIds;
  final List<String> tags;
  final String sourceType;
  final bool isPublic;
  final String createdAt;
  final String reviewedAt;
  final String verifiedAt;
  final bool needsReview;
  final int estimatedSeconds;

  /// 보기별 해설(선택). 길이가 choices와 같으면 UI에서 표시.
  final List<String> choiceExplanations;

  bool isCorrect(int selected) => selected == answerIndex;
}

class PracticalItem {
  const PracticalItem({
    required this.id,
    required this.category,
    required this.title,
    required this.prompt,
    required this.requirements,
    required this.modelAnswer,
    required this.requiredKeywords,
    required this.scoringGuide,
    required this.formulas,
    required this.units,
    required this.solutionOrder,
    this.deductionRisks = const [],
    this.commonMistakes = const [],
    this.similarIds = const [],
    this.relatedLessonIds = const [],
    this.hints = const [],
  });

  final String id;
  final String category;
  final String title;
  final String prompt;
  final List<String> requirements;
  final String modelAnswer;
  final List<String> requiredKeywords;
  final String scoringGuide;
  final List<String> formulas;
  final List<String> units;
  final List<String> solutionOrder;
  final List<String> deductionRisks;
  final List<String> commonMistakes;
  final List<String> similarIds;
  final List<String> relatedLessonIds;
  final List<String> hints;

  /// 필수 키워드 포함 여부로 자체 점검 (공식 채점 대체 아님)
  KeywordCheckResult selfCheck(String userAnswer) {
    final normalized = userAnswer.replaceAll(' ', '').toLowerCase();
    final found = <String>[];
    final missing = <String>[];
    for (final kw in requiredKeywords) {
      final key = kw.replaceAll(' ', '').toLowerCase();
      if (normalized.contains(key)) {
        found.add(kw);
      } else {
        missing.add(kw);
      }
    }
    final ratio = requiredKeywords.isEmpty
        ? 0.0
        : found.length / requiredKeywords.length;
    return KeywordCheckResult(found: found, missing: missing, coverage: ratio);
  }
}

class KeywordCheckResult {
  const KeywordCheckResult({
    required this.found,
    required this.missing,
    required this.coverage,
  });

  final List<String> found;
  final List<String> missing;
  final double coverage;
}

class GlossaryTerm {
  const GlossaryTerm({
    required this.id,
    required this.korean,
    required this.english,
    this.symbol,
    this.unit,
    required this.simple,
    required this.technical,
    this.relatedFormulaIds = const [],
    this.relatedLessonIds = const [],
    this.confusable = const [],
    this.subjectId,
  });

  final String id;
  final String korean;
  final String english;
  final String? symbol;
  final String? unit;
  final String simple;
  final String technical;
  final List<String> relatedFormulaIds;
  final List<String> relatedLessonIds;
  final List<String> confusable;
  final String? subjectId;
}

class KnowledgeArticle {
  const KnowledgeArticle({
    required this.id,
    required this.title,
    required this.overview,
    required this.easyExplain,
    required this.principle,
    required this.fieldCase,
    required this.cautions,
    required this.certLink,
    this.relatedLessonIds = const [],
    this.relatedQuestionIds = const [],
  });

  final String id;
  final String title;
  final String overview;
  final String easyExplain;
  final String principle;
  final String fieldCase;
  final List<String> cautions;
  final String certLink;
  final List<String> relatedLessonIds;
  final List<String> relatedQuestionIds;
}

class ToolItem {
  const ToolItem({
    required this.id,
    required this.name,
    required this.purpose,
    required this.howToUse,
    required this.preCheck,
    required this.misuse,
    required this.safety,
    required this.relatedValues,
    required this.selectionTips,
    required this.storage,
    required this.relatedChapters,
  });

  final String id;
  final String name;
  final String purpose;
  final String howToUse;
  final List<String> preCheck;
  final List<String> misuse;
  final List<String> safety;
  final String relatedValues;
  final List<String> selectionTips;
  final String storage;
  final List<String> relatedChapters;
}

class SafetyArticle {
  const SafetyArticle({
    required this.id,
    required this.title,
    required this.body,
    required this.priorityNote,
    required this.sources,
  });

  final String id;
  final String title;
  final String body;
  final String priorityNote;
  final List<String> sources;
}

class SubjectInfo {
  const SubjectInfo({
    required this.id,
    required this.name,
    required this.shortName,
    required this.description,
    required this.chapters,
  });

  final String id;
  final String name;
  final String shortName;
  final String description;
  final List<String> chapters;
}

class CalculatorGuide {
  const CalculatorGuide({
    required this.id,
    required this.title,
    required this.summary,
    required this.steps,
    required this.commonErrors,
    required this.examTips,
  });

  final String id;
  final String title;
  final String summary;
  final List<String> steps;
  final List<String> commonErrors;
  final List<String> examTips;
}

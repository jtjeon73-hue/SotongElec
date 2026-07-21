import '../models/learning_models.dart';
import '../models/content_meta.dart';
import 'subjects/subjects_data.dart';
import 'lessons/lessons_data.dart';
import 'formulas/formulas_data.dart';
import 'questions/questions_data.dart';
import 'practical/practical_data.dart';
import 'electrical_knowledge/knowledge_data.dart';
import 'glossary/glossary_data.dart';
import 'tools_safety/tools_safety_data.dart';
import 'calculators/calculator_guides_data.dart';

class Catalog {
  static List<SubjectInfo> get subjects => SubjectsData.all;
  static List<Lesson> get lessons => LessonsData.all;
  static List<FormulaItem> get formulas => FormulasData.all;
  static List<Question> get questions => QuestionsData.all;
  static List<PracticalItem> get practicalItems => PracticalData.all;
  static List<KnowledgeArticle> get knowledge => KnowledgeData.all;
  static List<GlossaryTerm> get glossary => GlossaryData.all;
  static List<ToolItem> get tools => ToolsSafetyData.all;
  static List<SafetyArticle> get safety => ToolsSafetyData.safety;
  static List<CalculatorGuide> get calcGuides => CalculatorGuidesData.all;

  static int get lessonCount => lessons.length;
  static int get formulaCount => formulas.length;
  static int get questionCount => questions.length;
  static int get termCount => glossary.length;
  static int get calculatorCount => CalculatorCatalog.items.length;
  static int get knowledgeCount => knowledge.length;
  static int get toolCount => tools.length;
  static int get practicalCount => practicalItems.length;

  static int get reviewedContentCount =>
      lessons.where((l) => l.meta?.needsReview != true).length +
      questions.where((q) => !q.needsReview).length;

  static int get needsReviewCount =>
      lessons.where((l) => l.meta?.needsReview == true).length +
      questions.where((q) => q.needsReview).length;

  static int get practicalShortAnswerCount =>
      practicalItems.where((p) => p.category.contains('단답')).length;

  static int get practicalCalcCount =>
      practicalItems.where((p) => p.category.contains('계산')).length;

  static Lesson? lessonById(String id) {
    for (final l in lessons) {
      if (l.id == id) return l;
    }
    return null;
  }

  static FormulaItem? formulaById(String id) {
    for (final f in formulas) {
      if (f.id == id) return f;
    }
    return null;
  }

  static Question? questionById(String id) {
    for (final q in questions) {
      if (q.id == id) return q;
    }
    return null;
  }

  static PracticalItem? practicalById(String id) {
    for (final p in practicalItems) {
      if (p.id == id) return p;
    }
    return null;
  }

  static List<Lesson> lessonsBySubject(String subjectId) =>
      lessons.where((l) => l.subjectId == subjectId).toList();

  static List<Question> questionsBySubject(String subjectId) =>
      questions.where((q) => q.subjectId == subjectId).toList();

  static List<FormulaItem> formulasBySubject(String subjectId) =>
      formulas.where((f) => f.subjectId == subjectId).toList();
}

class SearchHit {
  SearchHit({
    required this.type,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.route,
    this.importance,
    this.snippet,
  });

  final String type;
  final String id;
  final String title;
  final String subtitle;
  final String route;
  final String? importance;
  final String? snippet;
}

class SearchService {
  static List<SearchHit> search(
    String query, {
    String? track,
    String? subjectId,
    String? contentType,
    String? difficulty,
    bool? completedOnly,
    bool? bookmarkOnly,
    bool? wrongOnly,
    bool? needsReviewOnly,
    Set<String>? completedLessonIds,
    Set<String>? bookmarkIds,
    Set<String>? wrongQuestionIds,
  }) {
    final q = query.trim().toLowerCase();
    final hits = <SearchHit>[];
    final hasFilter =
        track != null ||
        subjectId != null ||
        contentType != null ||
        difficulty != null ||
        completedOnly == true ||
        bookmarkOnly == true ||
        wrongOnly == true ||
        needsReviewOnly == true;
    if (q.isEmpty && !hasFilter) return [];

    bool matchBlob(String blob) => q.isEmpty || blob.contains(q);

    if (contentType == null || contentType == '강의') {
      for (final l in Catalog.lessons) {
        if (subjectId != null && l.subjectId != subjectId) continue;
        if (track != null && l.track != track) continue;
        if (difficulty != null && l.difficulty.name != difficulty) continue;
        if (completedOnly == true &&
            !(completedLessonIds?.contains(l.id) ?? false)) {
          continue;
        }
        if (bookmarkOnly == true && !(bookmarkIds?.contains(l.id) ?? false)) {
          continue;
        }
        if (needsReviewOnly == true && l.meta?.needsReview != true) continue;
        final blob =
            '${l.title} ${l.summary} ${l.theory} ${l.easyExplain} ${l.chapter} ${l.section} ${l.tags.join(' ')}'
                .toLowerCase();
        if (matchBlob(blob)) {
          hits.add(
            SearchHit(
              type: '강의',
              id: l.id,
              title: l.title,
              subtitle: '${l.chapter} · ${l.section}',
              route: '/lesson/${l.id}',
              importance: l.importance.map((e) => e.label).join(', '),
              snippet: _snippet(blob, q),
            ),
          );
        }
      }
    }
    if (contentType == null || contentType == '공식') {
      for (final f in Catalog.formulas) {
        if (subjectId != null && f.subjectId != subjectId) continue;
        final blob =
            '${f.name} ${f.meaning} ${f.mnemonic} ${f.readable} ${f.variables.keys.join(' ')} ${f.tags.join(' ')}'
                .toLowerCase();
        if (matchBlob(blob)) {
          hits.add(
            SearchHit(
              type: '공식',
              id: f.id,
              title: f.name,
              subtitle: f.chapter,
              route: '/formulas?focus=${f.id}',
              importance: f.importance.map((e) => e.label).join(', '),
              snippet: _snippet(blob, q),
            ),
          );
        }
      }
    }
    if (contentType == null || contentType == '문제') {
      for (final item in Catalog.questions) {
        if (subjectId != null && item.subjectId != subjectId) continue;
        if (track != null && item.examType != track) continue;
        if (difficulty != null && item.difficulty.name != difficulty) continue;
        if (wrongOnly == true &&
            !(wrongQuestionIds?.contains(item.id) ?? false)) {
          continue;
        }
        if (needsReviewOnly == true && !item.needsReview) continue;
        final blob =
            '${item.stem} ${item.explanation} ${item.tags.join(' ')} ${item.chapter}'
                .toLowerCase();
        if (matchBlob(blob)) {
          hits.add(
            SearchHit(
              type: '문제',
              id: item.id,
              title: item.stem.length > 40
                  ? '${item.stem.substring(0, 40)}…'
                  : item.stem,
              subtitle: item.chapter,
              route: '/questions?id=${item.id}',
              snippet: _snippet(blob, q),
            ),
          );
        }
      }
    }
    if (contentType == null || contentType == '실기') {
      for (final p in Catalog.practicalItems) {
        final blob =
            '${p.title} ${p.prompt} ${p.modelAnswer} ${p.category} ${p.requiredKeywords.join(' ')}'
                .toLowerCase();
        if (matchBlob(blob)) {
          hits.add(
            SearchHit(
              type: '실기',
              id: p.id,
              title: p.title,
              subtitle: p.category,
              route: '/practical/item/${p.id}',
              snippet: _snippet(blob, q),
            ),
          );
        }
      }
    }
    if (contentType == null || contentType == '전기상식') {
      for (final k in Catalog.knowledge) {
        final blob = '${k.title} ${k.overview} ${k.easyExplain}'.toLowerCase();
        if (matchBlob(blob)) {
          hits.add(
            SearchHit(
              type: '전기상식',
              id: k.id,
              title: k.title,
              subtitle: '일반 전기상식',
              route: '/knowledge/${k.id}',
              snippet: _snippet(blob, q),
            ),
          );
        }
      }
    }
    if (contentType == null || contentType == '도구') {
      for (final t in Catalog.tools) {
        final blob = '${t.name} ${t.purpose}'.toLowerCase();
        if (matchBlob(blob)) {
          hits.add(
            SearchHit(
              type: '도구',
              id: t.id,
              title: t.name,
              subtitle: t.purpose,
              route: '/tools/${t.id}',
              snippet: _snippet(blob, q),
            ),
          );
        }
      }
    }
    if (contentType == null || contentType == '용어') {
      for (final g in Catalog.glossary) {
        final blob = '${g.korean} ${g.english} ${g.simple} ${g.technical}'
            .toLowerCase();
        if (matchBlob(blob)) {
          hits.add(
            SearchHit(
              type: '용어',
              id: g.id,
              title: '${g.korean} (${g.english})',
              subtitle: g.simple,
              route: '/glossary?id=${g.id}',
              snippet: _snippet(blob, q),
            ),
          );
        }
      }
    }
    if (contentType == null || contentType == '계산기') {
      for (final c in CalculatorCatalog.items) {
        if (c.$2.toLowerCase().contains(q) || c.$1.contains(q) || q.isEmpty) {
          if (q.isNotEmpty &&
              !c.$2.toLowerCase().contains(q) &&
              !c.$1.contains(q)) {
            continue;
          }
          hits.add(
            SearchHit(
              type: '계산기',
              id: c.$1,
              title: c.$2,
              subtitle: '전기 계산 도구',
              route: '/calculators/${c.$1}',
            ),
          );
        }
      }
    }
    return hits;
  }

  static String? _snippet(String blob, String q) {
    if (q.isEmpty) return null;
    final i = blob.indexOf(q);
    if (i < 0) return null;
    final start = i > 24 ? i - 24 : 0;
    final end = (i + q.length + 24).clamp(0, blob.length);
    final slice = blob.substring(start, end);
    return slice.replaceAll(q, '『$q』');
  }
}

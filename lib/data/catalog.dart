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
  });

  final String type;
  final String id;
  final String title;
  final String subtitle;
  final String route;
  final String? importance;
}

class SearchService {
  static List<SearchHit> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    final hits = <SearchHit>[];

    for (final l in Catalog.lessons) {
      final blob =
          '${l.title} ${l.summary} ${l.theory} ${l.chapter} ${l.section}'
              .toLowerCase();
      if (blob.contains(q)) {
        hits.add(
          SearchHit(
            type: '강의',
            id: l.id,
            title: l.title,
            subtitle: '${l.chapter} · ${l.section}',
            route: '/lesson/${l.id}',
            importance: l.importance.map((e) => e.label).join(', '),
          ),
        );
      }
    }
    for (final f in Catalog.formulas) {
      final blob = '${f.name} ${f.meaning} ${f.mnemonic}'.toLowerCase();
      if (blob.contains(q)) {
        hits.add(
          SearchHit(
            type: '공식',
            id: f.id,
            title: f.name,
            subtitle: f.chapter,
            route: '/formulas?focus=${f.id}',
            importance: f.importance.map((e) => e.label).join(', '),
          ),
        );
      }
    }
    for (final item in Catalog.questions) {
      final blob = '${item.stem} ${item.tags.join(' ')} ${item.chapter}'
          .toLowerCase();
      if (blob.contains(q)) {
        hits.add(
          SearchHit(
            type: '문제',
            id: item.id,
            title: item.stem.length > 40
                ? '${item.stem.substring(0, 40)}…'
                : item.stem,
            subtitle: item.chapter,
            route: '/questions?id=${item.id}',
          ),
        );
      }
    }
    for (final p in Catalog.practicalItems) {
      final blob = '${p.title} ${p.prompt} ${p.category}'.toLowerCase();
      if (blob.contains(q)) {
        hits.add(
          SearchHit(
            type: '실기',
            id: p.id,
            title: p.title,
            subtitle: p.category,
            route: '/practical/item/${p.id}',
          ),
        );
      }
    }
    for (final k in Catalog.knowledge) {
      final blob = '${k.title} ${k.overview} ${k.easyExplain}'.toLowerCase();
      if (blob.contains(q)) {
        hits.add(
          SearchHit(
            type: '전기상식',
            id: k.id,
            title: k.title,
            subtitle: '일반 전기상식',
            route: '/knowledge/${k.id}',
          ),
        );
      }
    }
    for (final t in Catalog.tools) {
      final blob = '${t.name} ${t.purpose}'.toLowerCase();
      if (blob.contains(q)) {
        hits.add(
          SearchHit(
            type: '도구',
            id: t.id,
            title: t.name,
            subtitle: t.purpose,
            route: '/tools/${t.id}',
          ),
        );
      }
    }
    for (final g in Catalog.glossary) {
      final blob = '${g.korean} ${g.english} ${g.simple} ${g.technical}'
          .toLowerCase();
      if (blob.contains(q)) {
        hits.add(
          SearchHit(
            type: '용어',
            id: g.id,
            title: '${g.korean} (${g.english})',
            subtitle: g.simple,
            route: '/glossary?id=${g.id}',
          ),
        );
      }
    }
    for (final c in CalculatorCatalog.items) {
      if (c.$2.toLowerCase().contains(q) || c.$1.contains(q)) {
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
    return hits;
  }
}

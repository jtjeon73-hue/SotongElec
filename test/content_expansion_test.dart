import 'package:flutter_test/flutter_test.dart';
import 'package:sotong_elec/core/constants/app_constants.dart';
import 'package:sotong_elec/data/catalog.dart';
import 'package:sotong_elec/models/content_meta.dart';

void main() {
  group('Content expansion quotas', () {
    test('unique IDs', () {
      expect(
        Catalog.lessons.map((e) => e.id).toSet().length,
        Catalog.lessonCount,
      );
      expect(
        Catalog.formulas.map((e) => e.id).toSet().length,
        Catalog.formulaCount,
      );
      expect(
        Catalog.questions.map((e) => e.id).toSet().length,
        Catalog.questionCount,
      );
      expect(
        Catalog.practicalItems.map((e) => e.id).toSet().length,
        Catalog.practicalCount,
      );
      expect(
        Catalog.glossary.map((e) => e.id).toSet().length,
        Catalog.termCount,
      );
    });

    test('minimum lesson counts per subject', () {
      expect(
        Catalog.lessonsBySubject(WrittenSubjectIds.electromagnetics).length,
        greaterThanOrEqualTo(15),
      );
      expect(
        Catalog.lessonsBySubject(WrittenSubjectIds.powerEngineering).length,
        greaterThanOrEqualTo(15),
      );
      expect(
        Catalog.lessonsBySubject(WrittenSubjectIds.electricalMachines).length,
        greaterThanOrEqualTo(15),
      );
      expect(
        Catalog.lessonsBySubject(WrittenSubjectIds.circuitControl).length,
        greaterThanOrEqualTo(18),
      );
      expect(
        Catalog.lessonsBySubject(WrittenSubjectIds.facilityStandards).length,
        greaterThanOrEqualTo(15),
      );
      expect(Catalog.lessonCount, greaterThanOrEqualTo(78));
    });

    test('minimum formula and question counts', () {
      expect(Catalog.formulaCount, greaterThanOrEqualTo(125));
      expect(
        Catalog.formulasBySubject(WrittenSubjectIds.circuitControl).length,
        greaterThanOrEqualTo(35),
      );
      expect(Catalog.questionCount, greaterThanOrEqualTo(320));
      expect(
        Catalog.questionsBySubject(WrittenSubjectIds.circuitControl).length,
        greaterThanOrEqualTo(80),
      );
      for (final sid in [
        WrittenSubjectIds.electromagnetics,
        WrittenSubjectIds.powerEngineering,
        WrittenSubjectIds.electricalMachines,
        WrittenSubjectIds.facilityStandards,
      ]) {
        expect(
          Catalog.questionsBySubject(sid).length,
          greaterThanOrEqualTo(60),
        );
      }
    });

    test('practical and glossary minima', () {
      expect(Catalog.practicalCount, greaterThanOrEqualTo(210));
      expect(Catalog.practicalShortAnswerCount, greaterThanOrEqualTo(100));
      expect(Catalog.practicalCalcCount, greaterThanOrEqualTo(60));
      expect(Catalog.termCount, greaterThanOrEqualTo(150));
      expect(
        Catalog.questionCount + Catalog.practicalCount,
        greaterThanOrEqualTo(530),
      );
    });

    test('question choices and answer index', () {
      for (final q in Catalog.questions) {
        expect(q.choices.length, 4);
        expect(q.answerIndex, inInclusiveRange(0, 3));
        expect(q.explanation.trim(), isNotEmpty);
        expect(q.stem.trim(), isNotEmpty);
      }
    });

    test('related IDs resolve', () {
      final lessonIds = Catalog.lessons.map((e) => e.id).toSet();
      final formulaIds = Catalog.formulas.map((e) => e.id).toSet();
      final questionIds = Catalog.questions.map((e) => e.id).toSet();
      final termIds = Catalog.glossary.map((e) => e.id).toSet();

      for (final l in Catalog.lessons) {
        for (final id in l.relatedFormulaIds) {
          expect(formulaIds.contains(id), isTrue, reason: '${l.id}->$id');
        }
        for (final id in l.relatedQuestionIds) {
          expect(questionIds.contains(id), isTrue, reason: '${l.id}->$id');
        }
        for (final id in l.relatedTermIds) {
          expect(termIds.contains(id), isTrue, reason: '${l.id}->$id');
        }
      }
      for (final q in Catalog.questions) {
        for (final id in q.relatedLessonIds) {
          expect(lessonIds.contains(id), isTrue, reason: '${q.id}->$id');
        }
        for (final id in q.relatedFormulaIds) {
          expect(formulaIds.contains(id), isTrue, reason: '${q.id}->$id');
        }
      }
    });

    test('legacy IDs preserved', () {
      expect(Catalog.lessonById('em_coulomb'), isNotNull);
      expect(Catalog.formulaById('f_coulomb'), isNotNull);
      expect(Catalog.questionById('q_em_01'), isNotNull);
    });

    test('answer distribution not collapsed', () {
      final dist = <int, int>{0: 0, 1: 0, 2: 0, 3: 0};
      for (final q in Catalog.questions) {
        dist[q.answerIndex] = dist[q.answerIndex]! + 1;
      }
      final total = Catalog.questionCount;
      for (final v in dist.values) {
        expect(v / total, lessThan(0.5));
      }
    });

    test('facility standards review flags', () {
      final fs = Catalog.lessonsBySubject(WrittenSubjectIds.facilityStandards);
      expect(fs.any((l) => l.meta?.needsReview == true), isTrue);
    });

    test('search index finds expanded content', () {
      final hits = SearchService.search('슬립');
      expect(hits, isNotEmpty);
    });

    test('lesson required fields', () {
      for (final l in Catalog.lessons) {
        expect(l.title, isNotEmpty);
        expect(l.summary, isNotEmpty);
        expect(l.theory, isNotEmpty);
      }
    });

    test('practical keywords', () {
      for (final p in Catalog.practicalItems) {
        expect(p.requiredKeywords, isNotEmpty);
        expect(p.modelAnswer, isNotEmpty);
      }
    });

    test('must memorize formulas exist', () {
      expect(
        Catalog.formulas.any(
          (f) => f.importance.contains(ImportanceBadge.mustMemorize),
        ),
        isTrue,
      );
    });
  });
}

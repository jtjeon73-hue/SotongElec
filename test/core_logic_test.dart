import 'package:flutter_test/flutter_test.dart';

import 'package:sotong_elec/core/utils/electrical_calculators.dart';
import 'package:sotong_elec/core/utils/study_metrics.dart';
import 'package:sotong_elec/core/storage/study_storage.dart';
import 'package:sotong_elec/data/catalog.dart';
import 'package:sotong_elec/models/content_meta.dart';
import 'package:sotong_elec/models/learning_models.dart';

void main() {
  group('StudyMetrics', () {
    test('readiness clamps and weights', () {
      final score = StudyMetrics.computeReadiness(
        lessonCompletion: 1,
        correctRate: 1,
        wrongReviewRate: 1,
        mockAverage: 1,
        studyConsistency: 1,
      );
      expect(score, 100);
    });

    test('written pass judgement', () {
      final pass = StudyMetrics.judgeWritten({
        'a': 60,
        'b': 60,
        'c': 60,
        'd': 60,
        'e': 60,
      });
      expect(pass.passed, isTrue);
      expect(pass.hasFailSubject, isFalse);

      final fail = StudyMetrics.judgeWritten({
        'a': 30,
        'b': 80,
        'c': 80,
        'd': 80,
        'e': 80,
      });
      expect(fail.passed, isFalse);
      expect(fail.hasFailSubject, isTrue);
    });

    test('practical pass', () {
      expect(StudyMetrics.isPracticalPass(60), isTrue);
      expect(StudyMetrics.isPracticalPass(59.9), isFalse);
    });
  });

  group('Question grading', () {
    test('isCorrect', () {
      const q = Question(
        id: 't',
        examType: 'written',
        subjectId: 'x',
        chapter: 'c',
        section: 's',
        questionType: 't',
        trend: 't',
        difficulty: Difficulty.easy,
        importance: [],
        stem: 's',
        choices: ['a', 'b', 'c', 'd'],
        answerIndex: 2,
        explanation: 'e',
        calculationSteps: [],
        wrongReasons: [],
        relatedFormulaIds: [],
        relatedLessonIds: [],
        tags: [],
        sourceType: 'self',
        isPublic: true,
        createdAt: '2026-07-21',
        reviewedAt: '2026-07-21',
        verifiedAt: '2026-07-21',
      );
      expect(q.isCorrect(2), isTrue);
      expect(q.isCorrect(0), isFalse);
    });
  });

  group('Wrong answer storage serialization', () {
    test('roundtrip', () async {
      final storage = MemoryStudyStorage();
      await storage.init();
      final record = WrongAnswerRecord(
        questionId: 'q1',
        selectedAnswer: 'A',
        correctAnswer: 'B',
        wrongAt: '2026-07-21',
        cause: '계산 실수',
      );
      await storage.saveAll({
        'wrongAnswers': [record.toJson()],
      });
      final loaded = await storage.loadAll();
      final list = loaded['wrongAnswers'] as List;
      final again = WrongAnswerRecord.fromJson(
        Map<String, dynamic>.from(list.first as Map),
      );
      expect(again.questionId, 'q1');
      expect(again.cause, '계산 실수');
    });
  });

  group('Search', () {
    test('finds formula by name', () {
      final hits = SearchService.search('쿨롱');
      expect(hits.any((h) => h.type == '공식' || h.type == '강의'), isTrue);
    });
  });

  group('Formula filter', () {
    test('must memorize exists', () {
      final must = Catalog.formulas
          .where((f) => f.importance.contains(ImportanceBadge.mustMemorize))
          .toList();
      expect(must, isNotEmpty);
    });
  });

  group('Calculators', () {
    test('ohms law', () {
      final r = ElectricalCalculators.ohmsLaw(
        voltage: '',
        current: '2',
        resistance: '5',
        solveFor: 'V',
      );
      expect(r.ok, isTrue);
      expect(r.value, 10);
    });

    test('divide by zero', () {
      final r = ElectricalCalculators.ohmsLaw(
        voltage: '10',
        current: '',
        resistance: '0',
        solveFor: 'I',
      );
      expect(r.ok, isFalse);
    });

    test('invalid input', () {
      final r = ElectricalCalculators.ohmsLaw(
        voltage: '10',
        current: 'abc',
        resistance: '1',
        solveFor: 'V',
      );
      expect(r.ok, isFalse);
    });

    test('three phase power', () {
      final r = ElectricalCalculators.threePhasePower(
        lineVoltage: '380',
        lineCurrent: '10',
        pf: '0.8',
      );
      expect(r.ok, isTrue);
      expect(r.value! > 5000, isTrue);
    });

    test('resonance', () {
      final r = ElectricalCalculators.resonance(l: '0.1', c: '0.00001');
      expect(r.ok, isTrue);
      expect(r.value!, closeTo(159.15, 0.1));
    });
  });

  group('Practical keyword check', () {
    test('coverage', () {
      const item = PracticalItem(
        id: 'p',
        category: 'c',
        title: 't',
        prompt: 'p',
        requirements: [],
        modelAnswer: 'm',
        requiredKeywords: ['슬립', '1800'],
        scoringGuide: 's',
        formulas: [],
        units: [],
        solutionOrder: [],
      );
      final r = item.selfCheck('동기속도 1800, 슬립 계산');
      expect(r.found.length, 2);
      expect(r.coverage, 1);
    });
  });

  group('Catalog counts', () {
    test('non empty content', () {
      expect(Catalog.lessonCount, greaterThan(0));
      expect(Catalog.formulaCount, greaterThan(0));
      expect(Catalog.questionCount, greaterThan(0));
      expect(Catalog.termCount, greaterThan(0));
      expect(Catalog.calculatorCount, 20);
    });
  });

  group('ContentMeta parsing', () {
    test('fromJson', () {
      final meta = ContentMeta.fromJson({
        'source': 'Q-Net',
        'standardYear': '2024',
        'applicableExam': '전기기사',
        'createdAt': '2026-07-21',
        'reviewedAt': '2026-07-21',
        'verifiedAt': '2026-07-21',
        'isLatest': true,
        'needsReview': false,
      });
      expect(meta.source, 'Q-Net');
      expect(meta.toJson()['standardYear'], '2024');
    });
  });
}

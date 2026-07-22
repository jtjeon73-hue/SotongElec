import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:sotong_elec/data/catalog.dart';
import 'package:sotong_elec/data/lessons/lessons_flagship.dart';

void main() {
  group('Flagship textbook lessons', () {
    const ids = [
      'emx_15',
      'ccx_01',
      'ccx_03',
      'ccx_02',
      'ccx_16',
      'ccx_10',
      'ccx_20',
      'cc_ac_power',
      'fs_grounding',
      'ccx_41',
    ];

    test('ten flagship IDs exist and stay unique in catalog', () {
      expect(LessonsFlagship.all.length, 10);
      for (final id in ids) {
        final lesson = Catalog.lessonById(id);
        expect(lesson, isNotNull, reason: id);
        expect(lesson!.qualityTier, 'A');
        expect(lesson.whyNeeded, isNotEmpty, reason: id);
        expect(lesson.theory, isNotEmpty, reason: id);
        expect(lesson.steps.length, greaterThanOrEqualTo(3));
        expect(lesson.checkProblem, isNotEmpty);
        expect(lesson.checkSolution, isNotEmpty);
        expect(lesson.keyTakeaways, isNotEmpty);
        expect(lesson.safetyNotes, isNotEmpty, reason: id);
      }
      expect(Catalog.lessonCount, 162);
    });

    test('flagship overrides expanded/seed without duplicating IDs', () {
      final matches = Catalog.lessons.where((l) => ids.contains(l.id)).length;
      expect(matches, 10);
    });
  });

  group('Flagship calculation cross-checks', () {
    test('ohm law 220V 44ohm', () {
      const v = 220.0;
      const r = 44.0;
      final i = v / r;
      expect(i, closeTo(5.0, 1e-9));
      final p1 = v * i;
      final p2 = (v * v) / r;
      final p3 = i * i * r;
      expect(p1, closeTo(1100.0, 1e-6));
      expect(p2, closeTo(1100.0, 1e-6));
      expect(p3, closeTo(1100.0, 1e-6));
    });

    test('series parallel', () {
      expect(30 + 60, 90);
      final rp = 1 / (1 / 30 + 1 / 60);
      expect(rp, closeTo(20.0, 1e-9));
      expect(90 * 30 / 90, 30);
      expect(90 * 60 / 90, 60);
    });

    test('kvl loop', () {
      const e = 12.0;
      const r1 = 2.0;
      const r2 = 4.0;
      final i = e / (r1 + r2);
      expect(i, 2.0);
      expect(e * i, closeTo(i * i * r1 + i * i * r2, 1e-9));
    });

    test('energy kwh', () {
      final pKw = 2200 / 1000;
      final kwh = pKw * 2;
      expect(kwh, closeTo(4.4, 1e-9));
      final joules = 2200 * 7200;
      expect(joules / 3.6e6, closeTo(4.4, 1e-6));
    });

    test('rms and peak', () {
      const vrms = 220.0;
      final vm = vrms * math.sqrt(2);
      expect(vm, closeTo(311.1269837, 1e-4));
      expect(vm / math.sqrt(2), closeTo(220.0, 1e-9));
    });

    test('three phase power two ways', () {
      const vl = 380.0;
      const il = 10.0;
      const pf = 0.85;
      final p = math.sqrt(3) * vl * il * pf;
      final s = math.sqrt(3) * vl * il;
      expect(p, closeTo(s * pf, 1e-9));
      expect(p / 1000, closeTo(5.595, 0.01));
    });

    test('pf compensation qc', () {
      const p = 1760.0;
      final tan1 = math.tan(math.acos(0.8));
      final tan2 = math.tan(math.acos(0.95));
      final qc = p * (tan1 - tan2);
      expect(qc, closeTo(741, 5));
    });
  });
}

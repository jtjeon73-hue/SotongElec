// Content quality validator for SotongElec.
// Run: dart run tool/validate_content.dart
// Exit code 1 if any error is found.
// ignore_for_file: avoid_print, avoid_relative_lib_imports

import 'package:sotong_elec/core/constants/app_constants.dart';
import 'package:sotong_elec/data/catalog.dart';

class Issue {
  Issue(this.level, this.subject, this.id, this.message, this.fix);
  final String level; // error | warning
  final String subject;
  final String id;
  final String message;
  final String fix;
}

void main() {
  final issues = <Issue>[];
  final lessonIds = <String>{};
  final formulaIds = <String>{};
  final questionIds = <String>{};
  final practicalIds = <String>{};
  final termIds = <String>{};

  void err(String subject, String id, String message, String fix) {
    issues.add(Issue('error', subject, id, message, fix));
  }

  void warn(String subject, String id, String message, String fix) {
    issues.add(Issue('warning', subject, id, message, fix));
  }

  // —— Collect IDs first ——
  for (final l in Catalog.lessons) {
    if (l.id.trim().isEmpty) {
      err(l.subjectId, '(empty)', '빈 강의 ID', '고유 ID를 부여하세요');
    } else if (!lessonIds.add(l.id)) {
      err(l.subjectId, l.id, '중복 강의 ID', 'ID를 고유하게 변경하세요');
    }
  }
  for (final f in Catalog.formulas) {
    if (f.id.trim().isEmpty) {
      err(f.subjectId, '(empty)', '빈 공식 ID', '고유 ID를 부여하세요');
    } else if (!formulaIds.add(f.id)) {
      err(f.subjectId, f.id, '중복 공식 ID', 'ID를 고유하게 변경하세요');
    }
  }
  for (final q in Catalog.questions) {
    if (q.id.trim().isEmpty) {
      err(q.subjectId, '(empty)', '빈 문제 ID', '고유 ID를 부여하세요');
    } else if (!questionIds.add(q.id)) {
      err(q.subjectId, q.id, '중복 문제 ID', 'ID를 고유하게 변경하세요');
    }
  }
  for (final t in Catalog.glossary) {
    if (t.id.trim().isEmpty) {
      err('glossary', '(empty)', '빈 용어 ID', '고유 ID');
    } else if (!termIds.add(t.id)) {
      err('glossary', t.id, '중복 용어 ID', '고유 ID');
    }
  }
  for (final p in Catalog.practicalItems) {
    if (p.id.trim().isEmpty) {
      err('practical', '(empty)', '빈 실기 ID', '고유 ID');
    } else if (!practicalIds.add(p.id)) {
      err('practical', p.id, '중복 실기 ID', '고유 ID');
    }
  }

  // —— Lessons ——
  for (final l in Catalog.lessons) {
    if (l.title.trim().isEmpty) {
      err(l.subjectId, l.id, '빈 강의 제목', 'title을 작성하세요');
    }
    if (l.summary.trim().isEmpty || l.theory.trim().isEmpty) {
      err(l.subjectId, l.id, '요약/이론 누락', 'summary·theory를 채우세요');
    }
    if (l.tags.isEmpty) {
      warn(l.subjectId, l.id, '검색 태그 누락', 'tags를 추가하세요');
    }
    if (!WrittenSubjectIds.all.contains(l.subjectId) && l.track == 'written') {
      err(l.subjectId, l.id, '존재하지 않는 과목', 'WrittenSubjectIds를 확인하세요');
    }
    if (l.meta?.needsReview == true && (l.meta?.verifiedAt.isEmpty ?? true)) {
      warn(l.subjectId, l.id, '검토 필요 메타 불완전', 'verifiedAt·출처를 확인하세요');
    }
    if (l.subjectId == WrittenSubjectIds.facilityStandards &&
        (l.meta?.needsReview != true)) {
      warn(l.subjectId, l.id, '설비기준 콘텐츠에 재확인 배지 권장', 'needsReview: true');
    }
  }

  // —— Formulas ——
  for (final f in Catalog.formulas) {
    if (f.name.trim().isEmpty || f.latex.trim().isEmpty) {
      err(f.subjectId, f.id, '공식명/수식 누락', 'name·latex를 채우세요');
    }
    if (f.units.isEmpty) {
      warn(f.subjectId, f.id, '단위 맵 비어 있음', 'units를 추가하세요');
    }
    if (f.tags.isEmpty) {
      warn(f.subjectId, f.id, '검색 태그 누락', 'tags를 추가하세요');
    }
  }

  // —— Questions ——
  final answerDist = <int, int>{0: 0, 1: 0, 2: 0, 3: 0};
  final stems = <String, String>{};
  for (final q in Catalog.questions) {
    if (q.stem.trim().isEmpty) {
      err(q.subjectId, q.id, '빈 문제 지문', 'stem을 작성하세요');
    }
    if (q.explanation.trim().isEmpty) {
      err(q.subjectId, q.id, '빈 해설', 'explanation을 작성하세요');
    }
    if (q.choices.length != 4) {
      err(q.subjectId, q.id, '보기 개수 오류(${q.choices.length})', '보기 4개로 맞추세요');
    }
    if (q.answerIndex < 0 || q.answerIndex > 3) {
      err(q.subjectId, q.id, '정답 번호 범위 오류', 'answerIndex를 0~3으로');
    }
    if (q.choices.toSet().length != q.choices.length) {
      warn(q.subjectId, q.id, '중복 보기', '보기 문구를 구분하세요');
    }
    answerDist[q.answerIndex] = (answerDist[q.answerIndex] ?? 0) + 1;

    final norm = q.stem.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (stems.containsKey(norm)) {
      err(q.subjectId, q.id, '중복 문제 지문 (동일: ${stems[norm]})', '지문을 다르게 작성');
    } else {
      stems[norm] = q.id;
    }

    if (q.questionType.contains('계산') && q.calculationSteps.isEmpty) {
      warn(q.subjectId, q.id, '계산문제 풀이 단계 누락', 'calculationSteps 추가');
    }
    if (q.tags.isEmpty) {
      warn(q.subjectId, q.id, '검색 태그 누락', 'tags 추가');
    }
  }

  // —— Cross refs ——
  void checkRefs(
    String subject,
    String id,
    List<String> refs,
    Set<String> pool,
    String kind,
  ) {
    for (final r in refs) {
      if (r.isEmpty) continue;
      if (!pool.contains(r)) {
        err(subject, id, '잘못된 관련 $kind ID: $r', '존재하는 ID로 수정');
      }
    }
  }

  for (final l in Catalog.lessons) {
    checkRefs(l.subjectId, l.id, l.relatedFormulaIds, formulaIds, '공식');
    checkRefs(l.subjectId, l.id, l.relatedQuestionIds, questionIds, '문제');
    checkRefs(l.subjectId, l.id, l.checkQuestionIds, questionIds, '확인문제');
    checkRefs(l.subjectId, l.id, l.relatedTermIds, termIds, '용어');
  }
  for (final f in Catalog.formulas) {
    checkRefs(f.subjectId, f.id, f.relatedLessonIds, lessonIds, '강의');
    checkRefs(f.subjectId, f.id, f.relatedQuestionIds, questionIds, '문제');
  }
  for (final q in Catalog.questions) {
    checkRefs(q.subjectId, q.id, q.relatedLessonIds, lessonIds, '강의');
    checkRefs(q.subjectId, q.id, q.relatedFormulaIds, formulaIds, '공식');
  }

  // —— Practical ——
  for (final p in Catalog.practicalItems) {
    if (p.title.trim().isEmpty || p.prompt.trim().isEmpty) {
      err('practical', p.id, '제목/문항 누락', '채우세요');
    }
    if (p.modelAnswer.trim().isEmpty) {
      err('practical', p.id, '모범답안 누락', 'modelAnswer 작성');
    }
    if (p.requiredKeywords.isEmpty) {
      err('practical', p.id, '필수 키워드 누락', 'requiredKeywords 추가');
    }
    checkRefs('practical', p.id, p.relatedLessonIds, lessonIds, '강의');
  }

  // —— Glossary ——
  for (final t in Catalog.glossary) {
    if (t.korean.trim().isEmpty) {
      err('glossary', t.id, '빈 용어명', 'korean 작성');
    }
  }

  // —— Counts ——
  int lessonsOf(String sid) =>
      Catalog.lessons.where((l) => l.subjectId == sid).length;
  int formulasOf(String sid) =>
      Catalog.formulas.where((f) => f.subjectId == sid).length;
  int questionsOf(String sid) =>
      Catalog.questions.where((q) => q.subjectId == sid).length;

  void minCount(String label, int actual, int min) {
    if (actual < min) {
      err('counts', label, '$label=$actual < 최소 $min', '콘텐츠를 추가하세요');
    }
  }

  minCount(
    '필기강의_전체',
    Catalog.lessons.where((l) => l.track != 'practical').length,
    78,
  );
  minCount('전기자기학_강의', lessonsOf(WrittenSubjectIds.electromagnetics), 15);
  minCount('전력공학_강의', lessonsOf(WrittenSubjectIds.powerEngineering), 15);
  minCount('전기기기_강의', lessonsOf(WrittenSubjectIds.electricalMachines), 15);
  minCount('회로제어_강의', lessonsOf(WrittenSubjectIds.circuitControl), 18);
  minCount('설비기준_강의', lessonsOf(WrittenSubjectIds.facilityStandards), 15);

  minCount('공식_전체', Catalog.formulaCount, 125);
  minCount('전기자기학_공식', formulasOf(WrittenSubjectIds.electromagnetics), 25);
  minCount('전력공학_공식', formulasOf(WrittenSubjectIds.powerEngineering), 25);
  minCount('전기기기_공식', formulasOf(WrittenSubjectIds.electricalMachines), 25);
  minCount('회로제어_공식', formulasOf(WrittenSubjectIds.circuitControl), 35);
  minCount('설비기준_공식', formulasOf(WrittenSubjectIds.facilityStandards), 15);

  final writtenQs = Catalog.questions
      .where((q) => q.examType == 'written')
      .length;
  minCount('필기문제_전체', writtenQs, 320);
  minCount('전기자기학_문제', questionsOf(WrittenSubjectIds.electromagnetics), 60);
  minCount('전력공학_문제', questionsOf(WrittenSubjectIds.powerEngineering), 60);
  minCount('전기기기_문제', questionsOf(WrittenSubjectIds.electricalMachines), 60);
  minCount('회로제어_문제', questionsOf(WrittenSubjectIds.circuitControl), 80);
  minCount('설비기준_문제', questionsOf(WrittenSubjectIds.facilityStandards), 60);

  final pracLessons = Catalog.practicalItems
      .where((p) => p.category.contains('핵심 강의'))
      .length;
  final pracSa = Catalog.practicalItems
      .where((p) => p.category.contains('단답'))
      .length;
  final pracCalc = Catalog.practicalItems
      .where((p) => p.category.contains('계산'))
      .length;
  final pracSeq = Catalog.practicalItems
      .where((p) => p.category.contains('시퀀스') || p.category.contains('도면'))
      .length;
  final pracDes = Catalog.practicalItems
      .where((p) => p.category.contains('설계') || p.category.contains('감리'))
      .length;

  minCount('실기_핵심강의', pracLessons, 30);
  minCount('실기_단답', pracSa, 100);
  minCount('실기_계산', pracCalc, 60);
  minCount('실기_시퀀스도면', pracSeq, 20);
  minCount('실기_설계감리견적', pracDes, 30);
  minCount('실기_전체', Catalog.practicalCount, 210);
  minCount('용어', Catalog.termCount, 150);

  final learningProblems = writtenQs + Catalog.practicalCount;
  minCount('학습문제_필기+실기', learningProblems, 530);

  // Answer distribution skew
  final totalQ = Catalog.questions.length;
  if (totalQ > 0) {
    for (final e in answerDist.entries) {
      final ratio = e.value / totalQ;
      if (ratio > 0.45) {
        warn(
          'distribution',
          'answer_${e.key}',
          '정답 번호 ${e.key + 1} 비율 ${(ratio * 100).toStringAsFixed(1)}%',
          '정답 위치를 더 분산하세요',
        );
      }
    }
  }

  // —— Report ——
  final errors = issues.where((i) => i.level == 'error').toList();
  final warnings = issues.where((i) => i.level == 'warning').toList();

  print('=== SotongElec content validation ===');
  print('Lessons: ${Catalog.lessonCount}');
  print('Formulas: ${Catalog.formulaCount}');
  print('Questions: ${Catalog.questionCount}');
  print('Practical: ${Catalog.practicalCount}');
  print('Glossary: ${Catalog.termCount}');
  print('Answer distribution: $answerDist');
  print('Errors: ${errors.length}');
  print('Warnings: ${warnings.length}');

  for (final i in errors) {
    print(
      '[ERROR] subject=${i.subject} id=${i.id} | ${i.message} | fix: ${i.fix}',
    );
  }
  for (final i in warnings) {
    print(
      '[WARN] subject=${i.subject} id=${i.id} | ${i.message} | fix: ${i.fix}',
    );
  }

  if (errors.isNotEmpty) {
    print('FAILED: ${errors.length} error(s). Do not deploy.');
    throw Exception('content validation failed');
  }
  print('OK: no errors');
}

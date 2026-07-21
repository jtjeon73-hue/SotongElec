import '../constants/app_constants.dart';

class StudyMetrics {
  /// 합격 준비도(참고용). 가중치 합 1.0
  static double computeReadiness({
    required double lessonCompletion,
    required double correctRate,
    required double wrongReviewRate,
    required double mockAverage,
    required double studyConsistency,
  }) {
    final score =
        (lessonCompletion * 0.25) +
        (correctRate * 0.30) +
        (wrongReviewRate * 0.15) +
        (mockAverage * 0.20) +
        (studyConsistency * 0.10);
    return (score * 100).clamp(0, 100);
  }

  /// 필기 과락·평균 합격 판정 (Q-Net 기사 일반 기준)
  static PassJudgement judgeWritten(Map<String, double> subjectScores) {
    final values = subjectScores.values.toList();
    if (values.isEmpty) {
      return const PassJudgement(
        passed: false,
        hasFailSubject: false,
        average: 0,
        message: '성적 없음',
      );
    }
    final average = values.reduce((a, b) => a + b) / values.length;
    final hasFail = values.any((s) => s < AppConstants.writtenPassPerSubject);
    final passed = !hasFail && average >= AppConstants.writtenPassAverage;
    return PassJudgement(
      passed: passed,
      hasFailSubject: hasFail,
      average: average,
      message: passed
          ? '합격 기준 충족(모의)'
          : hasFail
          ? '과락 과목 있음'
          : '평균 미달',
    );
  }

  static bool isPracticalPass(double score) =>
      score >= AppConstants.practicalPassScore;
}

class PassJudgement {
  const PassJudgement({
    required this.passed,
    required this.hasFailSubject,
    required this.average,
    required this.message,
  });

  final bool passed;
  final bool hasFailSubject;
  final double average;
  final String message;
}

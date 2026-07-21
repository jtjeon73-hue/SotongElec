/// SotongElec 앱 상수 및 시험 기준 설정
///
/// 시험 문항 수·시간·합격기준은 Q-Net(한국산업인력공단) 공개 기준을 참고합니다.
/// 변경될 수 있으므로 실제 응시 전 https://www.q-net.or.kr 에서 재확인하세요.
library;

class AppConstants {
  static const String appName = 'SotongElec';
  static const String appSubtitle = '전기기사 합격 학습관';
  static const String contentVersion = '1.0.0';
  static const String lastContentUpdate = '2026-07-21';

  /// Q-Net 출제기준 적용 기간 (공개 자료 기준)
  static const String examStandardPeriod = '2024.1.1. ~ 2026.12.31.';
  static const String examStandardSource = 'https://www.q-net.or.kr (출제기준 자료실)';
  static const String qnetUrl = 'https://www.q-net.or.kr';

  /// 필기: 과목당 20문항, 과목당 30분 (기사 등급 일반 기준)
  static const int writtenQuestionsPerSubject = 20;
  static const int writtenSubjectCount = 5;
  static const int writtenMinutesPerSubject = 30;
  static const int writtenTotalMinutes =
      writtenSubjectCount * writtenMinutesPerSubject;
  static const double writtenPassAverage = 60;
  static const double writtenPassPerSubject = 40;

  /// 실기: 필답형, 2시간 30분, 60점 이상
  static const int practicalMinutes = 150;
  static const double practicalPassScore = 60;

  static const double contentMaxWidth = 1100;
  static const double sidebarWidth = 280;
  static const double sidebarCollapsedWidth = 72;
}

class WrittenSubjectIds {
  static const electromagnetics = 'electromagnetics';
  static const powerEngineering = 'power_engineering';
  static const electricalMachines = 'electrical_machines';
  static const circuitControl = 'circuit_control';
  static const facilityStandards = 'facility_standards';

  static const List<String> all = [
    electromagnetics,
    powerEngineering,
    electricalMachines,
    circuitControl,
    facilityStandards,
  ];
}

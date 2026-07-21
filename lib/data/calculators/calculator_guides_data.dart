import '../../models/learning_models.dart';

class CalculatorGuidesData {
  static final List<CalculatorGuide> all = [
    CalculatorGuide(
      id: 'cg_basic',
      title: '기본 계산과 괄호',
      summary: '사칙연산과 괄호 우선순위를 정확히 입력한다.',
      steps: ['수식을 왼쪽부터 정리', '괄호로 우선순위 명시', '결과 재확인'],
      commonErrors: ['괄호 닫기 누락', '연산 순서 착각'],
      examTips: ['긴 식은 단계별로 메모'],
    ),
    CalculatorGuide(
      id: 'cg_frac',
      title: '분수와 소수 변환',
      summary: '분수 결과를 소수로, 또는 그 반대로 변환하는 습관.',
      steps: ['분수 입력', '소수 변환', '유효숫자 확인'],
      commonErrors: ['조기 반올림'],
      examTips: ['최종 단계에서 반올림'],
    ),
    CalculatorGuide(
      id: 'cg_power',
      title: '제곱·제곱근·지수',
      summary: 'I²R, √(R²+X²) 등 전기 계산 핵심.',
      steps: ['제곱 입력', '제곱근 입력', '지수 표기 확인'],
      commonErrors: ['음수 제곱근', '지수 우선순위'],
      examTips: ['임피던스·손실 계산에 반복 사용'],
    ),
    CalculatorGuide(
      id: 'cg_eng',
      title: '공학적 표기',
      summary: '10의 거듭제곱으로 큰·작은 수를 다룬다.',
      steps: ['ENG 모드 확인', 'μ·m·k 단위 환산', '결과 자리수 점검'],
      commonErrors: ['μ와 m 혼동'],
      examTips: ['μC, μF 변환을 먼저 메모'],
    ),
    CalculatorGuide(
      id: 'cg_trig',
      title: '삼각함수와 DEG·RAD',
      summary: '역률·위상 계산 전 각도 모드를 확인한다.',
      steps: ['DEG/RAD 확인', 'sin/cos 계산', '역함수 결과 단위 확인'],
      commonErrors: ['RAD 모드에서 각도 입력'],
      examTips: ['시험 시작 전 DEG 확인'],
    ),
    CalculatorGuide(
      id: 'cg_complex',
      title: '복소수·극좌표',
      summary: '직교↔극 변환으로 교류 페이저 계산.',
      steps: ['a+jb 입력', '극좌표 변환', '크기·편각 기록'],
      commonErrors: ['편각 부호', '도/라디안'],
      examTips: ['사이트 복소 계산기로 검산'],
    ),
    CalculatorGuide(
      id: 'cg_memory',
      title: '메모리와 연립·통계',
      summary: '중간값을 메모리에 저장해 실수 줄이기.',
      steps: ['M+ / MR 활용', '필요 시 연립 기능', '평균·표준편차는 보조'],
      commonErrors: ['이전 메모리 미삭제'],
      examTips: ['문제 시작 전 메모리 클리어'],
    ),
    CalculatorGuide(
      id: 'cg_exam',
      title: '시험 전 설정 점검',
      summary: '모드·메모리·표기 설정을 초기화·점검.',
      steps: ['초기화', 'DEG', '공학표기', '샘플 계산(√2, cos60)'],
      commonErrors: ['설정 미확인으로 전 문항 오답'],
      examTips: ['허용 계산기 기종은 시험 공지 확인'],
    ),
  ];
}

class CalculatorCatalog {
  static const items = [
    ('ohms', '옴의 법칙'),
    ('power', '전력·전력량'),
    ('single_phase', '단상 전력'),
    ('three_phase', '삼상 전력'),
    ('pf', '역률'),
    ('voltage_drop', '전압강하'),
    ('series_r', '합성저항(직렬)'),
    ('parallel_r', '합성저항(병렬)'),
    ('transformer_s', '변압기 용량'),
    ('turns', '변압기 권수비'),
    ('motor_i', '전동기 전류'),
    ('capacitor', '콘덴서 용량'),
    ('reactance', 'RLC 리액턴스'),
    ('impedance', '임피던스'),
    ('resonance', '공진주파수'),
    ('polar', '복소수·극좌표'),
    ('units', '전기 단위 변환'),
    ('illuminance', '조명·조도'),
    ('wire', '전선 굵기 참고'),
    ('protection', '보호기기 학습용'),
  ];
}

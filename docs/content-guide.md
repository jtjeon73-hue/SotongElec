# 콘텐츠 작성 가이드

SotongElec 학습 콘텐츠를 추가·수정할 때 따르는 공통 규칙입니다.

## 데이터 위치

| 종류 | 기본 파일 | 확장 파일 |
|------|-----------|-----------|
| 강의 | `lib/data/lessons/lessons_data.dart` | `lessons_expanded.dart` |
| 공식 | `lib/data/formulas/formulas_data.dart` | `formulas_expanded.dart` |
| 문제 | `lib/data/questions/questions_data.dart` | `questions_expanded.dart` |
| 실기 | `lib/data/practical/practical_data.dart` | `practical_expanded.dart` |
| 용어 | `lib/data/glossary/glossary_data.dart` | `glossary_expanded.dart` |

대량 생성은 `python tool/generate_expanded_content.py` 후 수동 품질 보완을 권장합니다.

## ID 규칙

- 기존 ID는 **절대 변경하지 않음** (진도·오답이 ID 기준)
- 신규 강의: `emx_01`, `pex_01`, `emx2_01`, `ccx_01`, `fsx_01`
- 신규 공식: `f_emx_*`, `f_pex_*`, `f_mx_*`, `f_ccx_*`, `f_fsx_*`
- 신규 문제: `q_em_x001`, `q_pe_x001`, …
- 실기: `prac_lec_*`, `prac_sa_*`, `prac_calc_*`, `prac_seq_*`, `prac_des_*`
- 용어: `gx_001` …

## 과목 코드

- `electromagnetics` 전기자기학
- `power_engineering` 전력공학
- `electrical_machines` 전기기기
- `circuit_control` 회로이론 및 제어공학
- `facility_standards` 전기설비기술기준

## 난이도 · 중요도

- 난이도: `easy` / `medium` / `hard` (기초·기본·중급·심화 비율 참고)
- 중요도 배지: 반드시 암기, 자주 출제, 계산 필수, 개념, 실기 연계, 법규 최신 확인

## 강의 필수 구역

1 배울 내용 → 2 핵심 → 3 개념 → 4 공식·단위 → 5 예제 → 6 풀이 →
7 출제경향 → 8 실수 → 9 실기·현장 → 10 확인문제 → 11 관련 학습

## 검증

```bash
dart run tool/validate_content.dart
flutter analyze
flutter test
flutter build web --release
```

오류 1건이라도 있으면 배포하지 않습니다.

## 배포 전 체크

- [ ] 콘텐츠 검증 오류 0
- [ ] analyze / test / release 빌드 성공
- [ ] 기존 ID 유지
- [ ] 법규 수치는 공식 출처·기준일 표시
- [ ] Firebase 프로젝트 `sotong-elec` 확인

# SotongElec · 전기기사 합격 학습관

Flutter Web 기반 대한민국 국가기술자격 **전기기사** 필기·실기 학습 플랫폼입니다.

이론 → 공식 → 계산기 → 예제 → 기출유형 → 오답 → 모의고사 → 실기 → 취약점 → 합격 준비도
흐름으로 꾸준히 공부할 수 있도록 구성했습니다.

## 사이트 목적

- 전기기사 합격을 위한 체계적 自学 허브
- 실제 작동하는 문제·공식·계산기·진도 관리
- 공식 출처(Q-Net 등)와 자체 제작 콘텐츠를 구분 표기

## 주요 기능

- 홈 합격 대시보드 (진도·정답률·준비도·오답·주간 학습)
- 필기 5과목 강의·공식·기출유형 연습문제
- 필기 모의고사 (타이머·과락 판정·성적 그래프)
- 실기 단답·계산·시퀀스·설계 (키워드 자체점검)
- 공식 암기카드 / 공학용 계산기 사용법 / 전기 계산 도구 20종
- 일반 전기상식·도구·현장 안전
- 오답노트·즐겨찾기·메모·로컬 진도 저장
- 통합 검색·용어사전·자료 출처

## 전체 메뉴

01 홈 · 02 시험안내 · 03~08 필기 · 09 기출유형 · 10 모의고사 · 11~16 실기 · 17 공식 · 18 계산기사용법 · 19 계산도구 · 20 오답 · 21 암기카드 · 22 학습계획 · 23 전기상식 · 24 도구 · 25 안전 · 26 용어 · 27 검색 · 28 출처

## 프로젝트 구조

```
lib/
  app/ core/ models/ data/ features/ shared/
assets/
test/
tool/deploy_web.ps1
```

## 개발환경

- Flutter 3.44+ / Dart 3.12+
- Firebase CLI (Hosting)
- 권장 OS: Windows 10/11

## 로컬 실행

```bash
flutter pub get
flutter run -d chrome
```

Path URL 전략을 사용합니다. 하위 경로 새로고침은 Firebase Hosting rewrite가 필요합니다.

## 코드 검사 · 테스트 · 빌드

```bash
dart format .
dart run tool/validate_content.dart
flutter analyze
flutter test
flutter build web --release
```

## Firebase

- 표시명: **SotongElec**
- 프로젝트 ID: **sotong-elec**
- Hosting public: `build/web`
- SPA rewrite: `**` → `/index.html`

### 재배포

```powershell
.\tool\deploy_web.ps1
```

또는

```bash
flutter build web --release
firebase deploy --only hosting --project sotong-elec
```

### 운영 URL

- https://sotong-elec.web.app
- https://sotong-elec.firebaseapp.com

(배포 후 Firebase CLI가 출력한 주소를 기준으로 하세요.)

## 콘텐츠 추가법

상세 지침:

- [docs/content-guide.md](docs/content-guide.md)
- [docs/question-authoring-guide.md](docs/question-authoring-guide.md)
- [docs/source-policy.md](docs/source-policy.md)
- [docs/technical-content-quality-standard.md](docs/technical-content-quality-standard.md)
- [docs/content-quality-report.md](docs/content-quality-report.md)

교재형 대표 강의는 `lib/data/lessons/lessons_flagship.dart`에서 기존 ID를 덮어씁니다.

데이터 파일:

- 강의: `lib/data/lessons/lessons_data.dart` (+ `lessons_expanded.dart`)
- 공식: `lib/data/formulas/formulas_data.dart` (+ `formulas_expanded.dart`)
- 문제: `lib/data/questions/questions_data.dart` (+ `questions_expanded.dart`)
- 실기: `lib/data/practical/practical_data.dart` (+ `practical_expanded.dart`)
- 전기상식: `lib/data/electrical_knowledge/knowledge_data.dart`
- 용어: `lib/data/glossary/glossary_data.dart` (+ `glossary_expanded.dart`)

대량 생성: `python tool/generate_expanded_content.py`  
검증: `dart run tool/validate_content.dart` (오류 시 배포 금지)

모델 필드를 맞추고 `Catalog`가 자동으로 집계합니다. **기존 ID는 변경하지 마세요.**

## 법령·출제기준 업데이트

1. [Q-Net](https://www.q-net.or.kr) 출제기준 자료실 확인
2. `lib/core/constants/app_constants.dart` 시험 설정 갱신
3. 법규 관련 콘텐츠에 `needsReview` / 출처 메타 갱신
4. 출처 페이지·검토일 기록

## 출처·저작권 원칙

- 블로그/학원 광고성 수치를 공식처럼 쓰지 않음
- 기출 원문·유료 해설 복제 금지 → 자체 작성 **기출유형 연습문제** 사용
- 확인되지 않은 법령 수치를 만들어내지 않음
- 전선·보호기기 계산기는 **학습용 참고** 고지

## 향후 Firestore 연동

`StudyStorage` 인터페이스(`SharedPrefsStudyStorage`)를 Firestore 구현체로 교체하면 됩니다.  
`StudyProgressController`는 저장소 추상화에만 의존합니다.

## 라이선스·문의

저장소: https://github.com/jtjeon73-hue/SotongElec  
오류 제보는 GitHub Issues로 부탁드립니다.

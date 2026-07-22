import '../../core/constants/app_constants.dart';
import '../../models/content_meta.dart';
import '../../models/learning_models.dart';

/// 대표 10개 교재형 보강 강의. 기존 ID를 유지하며 Catalog에서 동일 ID를 덮어쓴다.
class LessonsFlagship {
  static const _reviewed = '2026-07-22';
  static final _meta = ContentMeta(
    source:
        'SotongElec 자체 작성 교재형 콘텐츠 (공개 공학 원리). '
        '시험제도·법령 수치는 Q-Net·국가법령정보센터·KEC 관련 공식 자료로 재확인.',
    standardYear: '2024-2026',
    applicableExam: '전기기사 필기·실기 연계 학습',
    createdAt: _reviewed,
    reviewedAt: _reviewed,
    verifiedAt: _reviewed,
  );
  static final _metaFs = ContentMeta(
    source:
        '개념·안전 원칙 학습용. 구체 저항값·차단기 정격·전선 굵기는 현장 설계조건과 '
        '최신 KEC·법령·제조사 자료를 확인 (확인일 $_reviewed).',
    standardYear: '확인필요',
    applicableExam: '전기기사',
    createdAt: _reviewed,
    reviewedAt: _reviewed,
    verifiedAt: _reviewed,
    needsReview: true,
    isLatest: false,
  );

  static final List<Lesson> all = [
    // 1. 전압·전류·저항의 관계
    Lesson(
      id: 'emx_15',
      subjectId: WrittenSubjectIds.electromagnetics,
      chapter: '저항과 고유저항',
      section: '전압·전류·저항',
      title: '전압·전류·저항의 관계',
      objectives: [
        '전압·전류·저항의 물리적 의미를 구분하여 설명한다',
        '세 양 사이의 관계를 단위와 함께 적용한다',
        '저항률·길이와 단면적이 저항에 미치는 영향을 계산한다',
      ],
      importance: [
        ImportanceBadge.mustMemorize,
        ImportanceBadge.conceptual,
        ImportanceBadge.frequentlyAsked,
      ],
      difficulty: Difficulty.easy,
      estimatedMinutes: 45,
      prerequisites: ['전하와 전류의 기본 개념'],
      summary:
          '전압은 전하를 미는 전기적 압력, 전류는 전하의 흐름, 저항은 흐름을 방해하는 정도다. '
          '도체에서는 보통 V=IR 관계가 성립하며, 저항은 재질(ρ)·길이(ℓ)·단면적(A)에 의해 R=ρℓ/A로 정해진다.',
      easyExplain:
          '수도관에 비유하면 압력은 전압, 유량은 전류, 관의 좁힘·거칠기는 저항에 가깝다. '
          '같은 압력에서 관이 좁을수록 물이 덜 흐르듯, 저항이 크면 전류가 작아진다.',
      whyNeeded:
          '모든 회로·배선·전동기·보호기기 해석의 출발점이다. '
          '전기기사 필기뿐 아니라 현장 측정·고장 판단에서도 세 양을 혼동하면 오진으로 이어진다.',
      keyTerms: [
        '전압 V: 두 점 사이 전위차(단위 V)',
        '전류 I: 단위 시간당 전하 이동(단위 A)',
        '저항 R: 전류를 방해하는 정도(단위 Ω)',
        '저항률 ρ: 재질 고유의 비저항(단위 Ω·m)',
      ],
      theory:
          '도체 내부에서 자유전자는 전계에 의해 표류한다. 같은 도체라도 길이가 길수록, '
          '단면적이 작을수록, 저항률이 클수록 전류가 흐르기 어렵다. '
          '저항 R=ρℓ/A는 기하와 재질을 연결하는 기본식이다. '
          '온도가 올라가면 금속 저항은 대개 증가한다(온도계수 α>0). '
          '전압·전류·저항은 서로 독립이 아니라, 선형 저항에서는 하나가 정해지면 나머지가 결정된다.',
      formulas: [
        r'R = \rho\dfrac{\ell}{A}',
        r'V = IR \quad (선형저항)',
        r'I = \dfrac{V}{R},\quad R = \dfrac{V}{I}',
      ],
      symbolMeanings: {
        'V': '전압(전위차)',
        'I': '전류',
        'R': '저항',
        'ρ': '저항률',
        'ℓ': '도체 길이',
        'A': '단면적',
      },
      units: {'V': 'V', 'I': 'A', 'R': 'Ω', 'ρ': 'Ω·m', 'ℓ': 'm', 'A': 'm²'},
      conditions:
          '선형·옴성 도체, 정상상태. 다이오드·아크·포화 자성체 등 비선형 소자에는 단순 V=IR을 그대로 적용할 수 없다.',
      derivation:
          '미시적으로 전류밀도 J=σE (σ=1/ρ)이고, 균일 도체에서 I=JA, V=Eℓ을 대입하면 R=V/I=ρℓ/A가 된다.',
      example:
          '구리 도체 ℓ=100m, A=2.5mm², ρ=1.72×10⁻⁸ Ω·m일 때 저항을 구하라. '
          '(단면적을 m²로 변환)',
      steps: [
        '구함: R [Ω]',
        '공식: R=ρℓ/A',
        '단위 통일: A=2.5mm²=2.5×10⁻⁶ m²',
        '대입: R=1.72e-8 × 100 / 2.5e-6',
        '중간: 1.72e-6 / 2.5e-6 = 0.688',
        '결과: R≈0.69 Ω',
        '검산: 길이가 2배면 R도 약 2배 → 합리적',
      ],
      measurement:
          '멀티미터 저항 모드로 무전원 상태에서 측정한다. '
          '통전 중 저항 측정은 기기 손상·오측정의 원인이 된다. '
          '전압은 병렬, 전류는 직렬(또는 클램프)로 측정한다.',
      wrongCases: [
        'mm²를 m²로 바꾸지 않아 저항이 10⁶배 틀리는 경우',
        '전압·전류·저항 삼각형을 암기만 하고 어느 양이 독립변수인지 모르는 경우',
      ],
      hazards: [
        '통전 회로에 저항 레인지로 프로브를 대면 계기 손상·아크 위험',
        '전선 저항을 무시하고 전압만 보면 장거리 배선에서 전압강하를 놓침',
      ],
      diagnosisSteps: [
        '전원 차단·무전압 확인',
        '예상 R과 측정 R 비교',
        '접촉 저항·산화·헐거움 점검',
        '부하 투입 후 전압·전류가 V=IR에 맞는지 확인',
      ],
      safetyNotes: [
        '측정 전 전원 차단과 검전을 우선한다',
        '실제 전선 굵기·허용전류는 이 계산만으로 확정하지 않는다(포설·온도·보호협조 필요)',
      ],
      commonMistakes: ['단면적 단위 변환 누락', '저항률 단위(Ω·m vs Ω·mm²/m) 혼동'],
      fieldUse: '전선 저항·전압강하 개략 검토, 접촉불량으로 인한 발열 이해.',
      examTrends: ['R=ρℓ/A 계산', '온도에 따른 저항 변화 개념'],
      confusableConcepts: ['저항과 리액턴스', '저항률과 전도율'],
      practicalLink: '실기 전압강하·전선 굵기 개념과 연결. 최종 선정은 설계기준 확인.',
      checkProblem: 'V=12V, R=4Ω인 선형저항에서 전류는? 저항이 2Ω으로 줄면 전류는?',
      checkSolution:
          'I=V/R=12/4=3A. R이 절반(2Ω)이면 I=6A로 2배. '
          '전압이 일정할 때 전류는 저항에 반비례한다.',
      keyTakeaways: [
        'V·I·R는 물리적 의미가 다른 양이며 선형저항에서 V=IR로 연결된다',
        'R=ρℓ/A에서 단위 통일이 핵심이다',
        '계산 결과만으로 전선·차단기를 확정하지 않는다',
      ],
      checkQuestionIds: ['q_cc_x001'],
      relatedFormulaIds: ['f_ccx_01', 'f_emx_resistivity'],
      relatedQuestionIds: ['q_cc_x001'],
      relatedTermIds: const [],
      tags: ['기초', '저항', '전압', '전류', '교재형'],
      track: 'written',
      qualityTier: 'A',
      meta: _meta,
    ),

    // 2. 옴의 법칙
    Lesson(
      id: 'ccx_01',
      subjectId: WrittenSubjectIds.circuitControl,
      chapter: '옴의 법칙',
      section: '옴의 법칙',
      title: '옴의 법칙과 적용 조건',
      objectives: [
        'V=IR의 의미와 변형식 I=V/R, R=V/I를 설명한다',
        '선형 저항에 적용 가능한 조건을 판별한다',
        '단계별 계산과 검산을 수행한다',
      ],
      importance: [
        ImportanceBadge.mustMemorize,
        ImportanceBadge.calculationEssential,
        ImportanceBadge.frequentlyAsked,
      ],
      difficulty: Difficulty.easy,
      estimatedMinutes: 40,
      prerequisites: ['전압·전류·저항의 의미'],
      summary:
          '옴의 법칙은 선형 저항에서 전압이 전류에 비례한다는 관계 V=IR이다. '
          '비선형 소자·과도상태·교류의 복소 임피던스에는 단순 실수형 V=IR만으로 부족하다.',
      easyExplain:
          '같은 저항이면 전압을 올리면 전류도 같은 비율로 커진다. '
          '전구의 필라멘트처럼 뜨거워지면 저항이 바뀌는 경우는 “항상 같은 R”로 단정하면 안 된다.',
      whyNeeded: '직류회로 해석, 분압·분류, 전력 P=I²R 계산의 기초이며 전기기사 전 과목의 공통 선수 지식이다.',
      keyTerms: ['옴성(선형) 저항: V-I 특성이 원점을 지나는 직선', '비선형 소자: 다이오드, 아크, 일부 램프 등'],
      theory:
          '금속 도체에서 일정 온도·일정 재질이면 많은 경우 옴의 법칙에 가깝다. '
          '회로 해석에서는 저항을 이상화하여 V=IR을 쓴다. '
          '교류에서는 저항뿐 아니라 리액턴스가 있어 V=IZ(복소)로 일반화된다. '
          '직류 정상상태 저항회로에서는 실수 V=IR이 충분하다. '
          '램프·반도체처럼 동작점에서 저항이 바뀌면 “한 점에서의 미분저항” 개념이 필요하며, '
          '시험·실무에서는 먼저 선형 가정 여부를 확인한다.',
      formulas: [
        r'V = IR',
        r'I = \dfrac{V}{R}',
        r'R = \dfrac{V}{I}',
        r'P = VI = I^2 R = \dfrac{V^2}{R}',
      ],
      symbolMeanings: {'V': '전압', 'I': '전류', 'R': '저항', 'P': '전력'},
      units: {'V': 'V', 'I': 'A', 'R': 'Ω', 'P': 'W'},
      conditions:
          '선형 저항, 직류 또는 실효값 기준의 저항성 부하. '
          '반도체·아크·자기포화 구간에는 적용 범위를 제한한다.',
      derivation: '실험적 비례관계이며, 거시적으로는 J=σE로부터 유도할 수 있다.',
      example: '전압 220V, 저항 44Ω일 때 전류와 소비전력을 구하라.',
      steps: [
        '주어짐: V=220V, R=44Ω / 구함: I, P',
        '공식: I=V/R, P=VI 또는 P=V²/R',
        '대입: I=220/44=5 A',
        '전력: P=220×5=1100 W (또는 220²/44=1100 W)',
        '검산1: I²R=25×44=1100 W로 일치',
        '검산2: R이 22Ω이면 I=10A로 2배 → 전압 일정 시 반비례 확인',
      ],
      measurement:
          '전압은 부하 양단에 병렬 측정, 전류는 회로를 끊고 직렬 또는 클램프미터. '
          '저항 측정은 전원 분리 후.',
      wrongCases: [
        'mA·kΩ 단위를 섞어 계산하는 경우',
        '교류 유도성 부하에 직류용 V=IR만 적용해 전류를 과소평가하는 경우',
      ],
      hazards: ['계산상 전류가 커도 차단기·전선 여유 없이 통전하면 발열·화재 위험', '통전 중 저항 측정 시도'],
      diagnosisSteps: [
        '무부하 전압 측정',
        '부하 투입 후 전압·전류 측정',
        'R_eq≈V/I와 명판·설계값 비교',
        '이상 시 접촉·단선·지락 점검',
      ],
      safetyNotes: [
        '대전류 회로 작업 시 자격·절차·보호구를 준수한다',
        '차단기 정격은 “계산 전류보다 조금 큰 값”으로 단순 올리면 보호 협조가 깨질 수 있다',
      ],
      commonMistakes: ['단위 접두어(m, k) 누락', '전력 공식 혼용 시 단위 불일치'],
      fieldUse: '히터·저항부하 전류 산정, 간이 고장 판단.',
      examTrends: ['V=IR 변형', 'P=I²R와 연계'],
      confusableConcepts: ['옴의 법칙과 키르히호프 법칙', '저항과 임피던스'],
      practicalLink: '실기 부하전류·전압강하 계산의 기초.',
      checkProblem: '10V가 2kΩ에 걸렸을 때 전류[mA]는?',
      checkSolution:
          'R=2000Ω, I=10/2000=0.005A=5mA. '
          '흔한 오답: 10/2=5A로 보고 kΩ을 무시하는 것.',
      keyTakeaways: [
        'V=IR은 선형저항의 기본 관계다',
        '항상 단위를 맞춘 뒤 대입한다',
        '비선형·교류 리액턴스에는 확장 개념이 필요하다',
      ],
      checkQuestionIds: ['q_cc_x001'],
      relatedFormulaIds: ['f_ccx_01', 'f_ohms'],
      relatedQuestionIds: ['q_cc_x001', 'q_cc_01'],
      tags: ['옴의자유', '기초', '교재형'],
      track: 'written',
      qualityTier: 'A',
      meta: _meta,
    ),

    // 3. 직렬·병렬
    Lesson(
      id: 'ccx_03',
      subjectId: WrittenSubjectIds.circuitControl,
      chapter: '직렬·병렬회로',
      section: '직렬·병렬회로',
      title: '직렬회로와 병렬회로',
      objectives: ['직렬·병렬의 전류·전압 분배를 설명한다', '합성저항을 계산한다', '분압·분류의 실무 의미를 연결한다'],
      importance: [
        ImportanceBadge.calculationEssential,
        ImportanceBadge.frequentlyAsked,
        ImportanceBadge.mustMemorize,
      ],
      difficulty: Difficulty.easy,
      estimatedMinutes: 45,
      prerequisites: ['옴의 법칙'],
      summary:
          '직렬은 전류가 같고 전압이 분배되며 R_s=ΣR. '
          '병렬은 전압이 같고 전류가 나뉘며 1/R_p=Σ(1/R).',
      easyExplain: '직렬은 한 줄로 이어 같은 물이 흐르는 관, 병렬은 같은 수압의 여러 갈래 관에 비유할 수 있다.',
      whyNeeded: '분압회로, 부하 병설, 전열기·조명 회로 해석과 시험 계산의 핵심이다.',
      keyTerms: ['분압', '분류', '합성저항', '등가저항'],
      theory:
          '직렬: I 동일, V_i=IR_i, V=ΣV_i. 큰 저항에 전압이 더 걸린다. '
          '병렬: V 동일, I_i=V/R_i, I=ΣI_i. 작은 저항으로 전류가 더 많이 흐른다. '
          '직·병렬 혼합은 블록으로 묶어 단계적으로 등가화한다. '
          '현장에서 “병렬로 붙였다”는 말은 같은 전압을 공유한다는 뜻이고, '
          '합성저항이 항상 가장 작은 가지보다 작아진다는 성질을 검산에 쓴다. '
          '배터리·콘덴서 직병렬은 추가 제약(내부저항·밸런스)이 있으므로 저항회로와 동일시하지 않는다.',
      formulas: [
        r'R_s = R_1+R_2+\cdots',
        r'\dfrac{1}{R_p}=\dfrac{1}{R_1}+\dfrac{1}{R_2}+\cdots',
        r'V_1 = V\dfrac{R_1}{R_1+R_2}\quad (직렬분압)',
      ],
      symbolMeanings: {'Rs': '직렬 합성저항', 'Rp': '병렬 합성저항'},
      units: {'R': 'Ω', 'V': 'V', 'I': 'A'},
      conditions: '선형 저항, 이상 전원. 상호유도·분포정수 선로는 별도 모델.',
      derivation: '옴의 법칙과 KCL/KVL을 직렬·병렬 위상에 적용한 결과다.',
      example: 'R1=30Ω, R2=60Ω이 (1)직렬 (2)병렬일 때 합성저항과, 직렬일 때 90V 인가 시 각 전압.',
      steps: [
        '직렬: Rs=30+60=90Ω',
        '직렬분압: V1=90×30/90=30V, V2=60V',
        '검산: 30+60=90V',
        '병렬: 1/Rp=1/30+1/60=1/20 → Rp=20Ω',
        '검산: 병렬 합성은 가장 작은 저항(30Ω)보다 작아야 함 → 20Ω OK',
      ],
      measurement: '직렬·병렬 여부를 회로도·실배선에서 확인한 뒤 전압·전류를 측정한다.',
      wrongCases: ['병렬 합성을 산술평균으로 구하는 오류', '직렬분압에서 전류가 다르다고 가정하는 오류'],
      hazards: [
        '병렬로 저저항을 잘못 연결하면 과전류·차단기 트립·발열',
        '직렬 측정용 저항을 실수해 주회로에 넣으면 부하 미동작·이상전압',
      ],
      diagnosisSteps: ['결선이 직렬인지 병렬인지 확인', '각 소자 전압·전류 측정', '등가저항 역산과 비교'],
      safetyNotes: ['부하를 병설할 때는 전원·배선 용량을 먼저 검토한다'],
      commonMistakes: ['병렬 공식 뒤집기', '혼합회로에서 묶음 순서 오류'],
      fieldUse: '센서 분압, 히터 병설, 배터리 직·병렬 개념(실제는 셀 관리 필요).',
      examTrends: ['합성저항', '분압비'],
      confusableConcepts: ['직렬전류=동일 vs 병렬전압=동일'],
      practicalLink: '실기 간선·분기 개념과 전류 분담 이해.',
      checkProblem: '10Ω과 10Ω 병렬의 합성은?',
      checkSolution: '1/Rp=1/10+1/10=1/5 → Rp=5Ω. 같은 저항 n개 병렬은 R/n.',
      keyTakeaways: [
        '직렬: 전류 공통, 전압 분배',
        '병렬: 전압 공통, 전류 분배',
        '병렬 합성은 최소 저항보다 작다',
      ],
      checkQuestionIds: ['q_cc_x003'],
      relatedFormulaIds: ['f_ccx_02', 'f_ccx_03'],
      relatedQuestionIds: ['q_cc_x003'],
      tags: ['직렬', '병렬', '교재형'],
      track: 'written',
      qualityTier: 'A',
      meta: _meta,
    ),

    // 4. 키르히호프
    Lesson(
      id: 'ccx_02',
      subjectId: WrittenSubjectIds.circuitControl,
      chapter: '키르히호프 법칙',
      section: '키르히호프 법칙',
      title: '키르히호프 전압·전류 법칙',
      objectives: [
        'KCL·KVL의 물리 근거(전하·에너지 보존)를 설명한다',
        '노드·루프에서 부호 규칙을 정해 방정식을 세운다',
        '간단한 회로를 풀어 검산한다',
      ],
      importance: [
        ImportanceBadge.mustMemorize,
        ImportanceBadge.calculationEssential,
        ImportanceBadge.frequentlyAsked,
      ],
      difficulty: Difficulty.medium,
      estimatedMinutes: 50,
      prerequisites: ['옴의 법칙', '직렬·병렬'],
      summary:
          'KCL: 노드로 들어오는 전류의 합=0(전하 보존). '
          'KVL: 닫힌 루프에서 전압 상승·강하의 대수합=0(에너지 보존).',
      easyExplain:
          '교차로에 들어오는 차와 나가는 차가 같듯 전류도 쌓이지 않는다. '
          '한 바퀴 돌며 오르막·내리막을 합하면 원래 높이로 돌아오듯 전압도 한 바퀴에서 합이 0이다.',
      whyNeeded: '직·병렬로 바로 안 되는 회로, 다중 전원 회로 해석의 표준 도구다.',
      keyTerms: ['노드', '루프', '기준방향', '망로법', '절점법'],
      theory:
          '방정식 전에는 전류·전압의 가정 방향을 반드시 표시한다. '
          '계산 결과가 음수면 실제 방향이 가정과 반대라는 뜻이지, 답이 “틀렸다”는 뜻이 아니다. '
          '저항에서의 전압강하는 가정 전류 방향으로 +IR 또는 −IR로 일관되게 둔다. '
          '절점법·망로법은 KCL/KVL을 체계화한 것이며, 미지수 수와 독립 방정식 수를 맞추는 것이 핵심이다. '
          '전원 내부저항·종속전원이 있으면 같은 법칙을 확장해 적용한다.',
      formulas: [
        r'\sum I_{in}=\sum I_{out}\quad (KCL)',
        r'\sum V = 0\quad (KVL)',
        r'V_R = IR',
      ],
      symbolMeanings: {'I': '가지 전류', 'V': '가지 전압'},
      units: {'I': 'A', 'V': 'V'},
      conditions: '집중정수 회로, 저주파에서 유효. 전송선·전자파 영역은 별도.',
      derivation: '전하 보존 → KCL, 전위의 경로 독립성(정전·준정적) → KVL.',
      example: '단일 루프: E=12V, R1=2Ω, R2=4Ω. 전류와 각 저항 전압을 구하라.',
      steps: [
        '방향: 전지 + → R1 → R2 → − 로 I 가정',
        'KVL: 12 − 2I − 4I = 0 → 6I=12 → I=2A',
        'V1=I·R1=4V, V2=8V',
        '검산(KVL): 4+8=12V',
        '검산(전력): 공급 EI=12×2=24W, 소비 I²R1+I²R2=8+16=24W',
      ],
      measurement: '클램프·멀티미터로 가지 전류·노드 전압을 측정해 방정식과 비교한다.',
      wrongCases: [
        '부호를 루프마다 다르게 바꿔 방정식이 모순되는 경우',
        '음수 전류를 “불가능”으로 버리고 재계산하지 않는 경우',
      ],
      hazards: ['해석 오류로 과전류 경로를 방치하면 보호기기 오동작·발열'],
      diagnosisSteps: [
        '회로도에서 노드·루프 표시',
        '측정값으로 KCL/KVL 잔차 확인',
        '잔차가 크면 결선·접촉·센서 오류 의심',
      ],
      safetyNotes: ['활선 측정 시 정격·프로브·절연구간을 지킨다'],
      commonMistakes: ['부호 규칙 불일치', '옴의 법칙 방향과 KVL 부호 혼동'],
      fieldUse: '제어반 내부 다중 전원·귀로 해석의 기초.',
      examTrends: ['루프 방정식', '음수 전류의 의미'],
      confusableConcepts: ['KCL과 전류 분배만의 직관'],
      practicalLink: '실기 회로도 판독·고장점 추정.',
      checkProblem: 'E=24V, R=8Ω 단일 루프에서 I는?',
      checkSolution: 'KVL: 24−8I=0 → I=3A. 검산 P=24×3=72W, I²R=9×8=72W.',
      keyTakeaways: [
        'KCL은 전하 보존, KVL은 에너지·전위 보존',
        '부호·방향을 먼저 고정한다',
        '음수는 방향 반대를 뜻한다',
      ],
      checkQuestionIds: ['q_cc_x002'],
      relatedFormulaIds: ['f_ccx_01'],
      relatedQuestionIds: ['q_cc_x002'],
      tags: ['KCL', 'KVL', '교재형'],
      track: 'written',
      qualityTier: 'A',
      meta: _meta,
    ),

    // 5. 전력과 전력량
    Lesson(
      id: 'ccx_16',
      subjectId: WrittenSubjectIds.circuitControl,
      chapter: '교류전력',
      section: '전력과 전력량',
      title: '전력과 전력량',
      objectives: [
        '전력(W)과 전력량(Wh)의 차이를 설명한다',
        'P=VI, P=I²R, P=V²/R를 조건에 맞게 선택한다',
        '설비용량(kW)과 요금 산정용 전력량(kWh)을 구분한다',
      ],
      importance: [
        ImportanceBadge.mustMemorize,
        ImportanceBadge.calculationEssential,
        ImportanceBadge.frequentlyAsked,
      ],
      difficulty: Difficulty.easy,
      estimatedMinutes: 45,
      prerequisites: ['옴의 법칙'],
      summary:
          '전력 P는 순간(또는 평균) 일률[W], 전력량 W는 전력×시간[Wh 또는 kWh]이다. '
          '저항부하에서는 P=VI=I²R=V²/R가 동치다.',
      easyExplain:
          '전력이 “얼마나 세게 쓰는지”라면 전력량은 “얼마나 오래·많이 썼는지”다. '
          '2kW 히터를 3시간 켜면 6kWh를 쓴다.',
      whyNeeded: '전기요금·발열·설비 용량·시험 계산의 공통 언어다.',
      keyTerms: ['전력 P [W, kW]', '전력량 [Wh, kWh]', '피상전력 S [VA] (교류)'],
      theory:
          '직류 또는 역률 1인 저항부하에서 P=VI. '
          '같은 전력을 I²R로 보면 전류가 클수록 전선 손실이 커진다. '
          'V²/R는 전압이 고정된 히터 용량 이해에 유용하다. '
          '교류 일반에서는 유효전력 P=VI cosθ이며, 설비용량은 종종 kVA로도 다룬다.',
      formulas: [
        r'P = VI = I^{2}R = \dfrac{V^{2}}{R}',
        r'W = P \times t',
        r'1\,\mathrm{kWh}=1000\,\mathrm{W}\times3600\,\mathrm{s}=3.6\,\mathrm{MJ}',
      ],
      symbolMeanings: {'P': '전력', 'W': '전력량(에너지)', 't': '시간'},
      units: {'P': 'W', 'W_energy': 'Wh 또는 J', 't': 'h 또는 s'},
      conditions: '저항부하·직류 또는 pf=1. 일반 교류는 cosθ를 곱한다.',
      derivation: '일률의 정의 P=dW/dt와 전기력·전류의 관계로부터 P=VI.',
      example: '220V, 10A 저항부하를 2시간 사용. 전력과 전력량은?',
      steps: [
        'P=VI=220×10=2200W=2.2kW',
        '검산: R=V/I=22Ω, P=V²/R=48400/22=2200W',
        '전력량=2.2kW×2h=4.4kWh',
        '검산(J): 2200W×7200s=15.84MJ ≈ 4.4×3.6MJ',
      ],
      measurement: '전력계·전력량계(또는 클램프+전압+역률)로 확인. 멀티미터만으로는 전력량을 바로 못 본다.',
      wrongCases: ['kW와 kWh를 같은 단위로 취급', '손실 전력 I²R을 부하 출력과 혼동'],
      hazards: ['전력 계산을 무시하고 장시간 과부하 → 전선·접속부 과열'],
      diagnosisSteps: ['명판 전력과 측정 전력 비교', '이상 발열이 있으면 전류·접촉저항 확인'],
      safetyNotes: ['대용량 부하는 전용회로·적정 보호기기를 사용한다'],
      commonMistakes: ['시간 단위(분/시) 혼동', '삼상 전력에 단상 공식 사용'],
      fieldUse: '요금 개략, 발열 검토, 발전기·UPS 용량 개념.',
      examTrends: ['P=I²R', 'kWh 환산'],
      confusableConcepts: ['kW(용량) vs kWh(사용량)', 'W vs VA'],
      practicalLink: '실기 부하계산·요금·손실.',
      checkProblem: '1.5kW 장치를 40분 사용하면 전력량[kWh]은?',
      checkSolution: 't=40/60=2/3 h, W=1.5×2/3=1.0 kWh.',
      keyTakeaways: [
        '전력은 세기, 전력량은 사용 에너지',
        '세 공식 P=VI=I²R=V²/R는 저항부하에서 동치',
        '설비 kW와 요금 kWh를 구분한다',
      ],
      checkQuestionIds: ['q_cc_x016'],
      relatedFormulaIds: ['f_ac_power', 'f_ccx_14'],
      relatedQuestionIds: ['q_cc_01'],
      tags: ['전력', '전력량', '교재형'],
      track: 'written',
      qualityTier: 'A',
      meta: _meta,
    ),

    // 6. 교류 실효값
    Lesson(
      id: 'ccx_10',
      subjectId: WrittenSubjectIds.circuitControl,
      chapter: '평균값과 실효값',
      section: '교류의 주파수·위상·실효값',
      title: '교류의 주파수·위상·실효값',
      objectives: [
        '주기·주파수·각주파수를 연결한다',
        '최대값과 실효값(√2 관계)을 변환한다',
        '멀티미터 표시값이 보통 실효값임을 이해한다',
      ],
      importance: [
        ImportanceBadge.mustMemorize,
        ImportanceBadge.calculationEssential,
        ImportanceBadge.frequentlyAsked,
      ],
      difficulty: Difficulty.medium,
      estimatedMinutes: 45,
      prerequisites: ['정현파 개념'],
      summary:
          '정현파 v=Vm sin(ωt+φ). f=1/T, ω=2πf. '
          '실효값 Vrms=Vm/√2 (정현파). 가정용 220V는 대략 실효값이다.',
      easyExplain:
          '교류는 크기와 방향이 시간에 따라 변한다. '
          '우리가 “220V”라고 부르는 값은 대부분 실효값(가열 효과가 같은 직류 등가)이다.',
      whyNeeded: '교류 전력·변압기·전동기·계측 모든 계산의 기준 값이다.',
      keyTerms: ['주기 T', '주파수 f', '최대값 Vm', '실효값 Vrms', '위상 φ'],
      theory:
          '실효값은 한 주기 평균 전력과 같은 직류값으로 정의된다. '
          '정현파에 한해 Vrms=Vm/√2, Irms=Im/√2. '
          '위상이 다르면 순시전력에 맥동이 생기고 평균 유효전력은 cosθ에 비례한다. '
          '유도성 부하는 전류가 전압보다 늦고, 용량성은 앞선다.',
      formulas: [
        r'f=\dfrac{1}{T},\quad \omega=2\pi f',
        r'V_{rms}=\dfrac{V_m}{\sqrt{2}}\approx 0.707 V_m',
        r'V_m=\sqrt{2}\,V_{rms}',
      ],
      symbolMeanings: {'T': '주기', 'f': '주파수', 'Vm': '최대값', 'Vrms': '실효값'},
      units: {'T': 's', 'f': 'Hz', 'V': 'V'},
      conditions: '정현파. 왜형파·고조파가 있으면 True RMS 계측과 정의 확장이 필요하다.',
      derivation: 'P_avg = (Vm Im /2) cosθ 로부터 실효값 정의와 일치하도록 Vm/√2를 얻는다.',
      example: '실효값 220V 정현파의 최대값과, f=60Hz일 때 주기는?',
      steps: [
        'Vm=220√2≈311.1 V',
        'T=1/60≈0.0167 s = 16.7 ms',
        '검산: 311/√2≈220',
      ],
      measurement:
          '일반 멀티미터 AC 모드는 대개 실효값(또는 평균응답을 실효로 교정). '
          '비정현파에는 True RMS 여부를 확인한다.',
      wrongCases: ['220V를 최대값으로 보고 √2를 또 곱하는 오류', '평균값과 실효값을 혼동'],
      hazards: ['최대값(약 311V)을 잊고 감전 위험을 과소평가'],
      diagnosisSteps: [
        '파형(스코프)으로 정현 여부 확인',
        '실효값·주파수를 계측',
        '위상은 전력분석기·스코프로 확인',
      ],
      safetyNotes: ['교류 감전·아크 위험은 직류와 특성이 다를 수 있다. 활선 작업 금지·절차 준수'],
      commonMistakes: ['√2 방향(실효↔최대) 반대', '50/60Hz 혼동'],
      fieldUse: '수전전압 확인, 인버터 출력 왜형 인식.',
      examTrends: ['Vm=√2 Vrms', '주기·주파수'],
      confusableConcepts: ['평균값(전파정류) vs 실효값'],
      practicalLink: '실기 전압 측정·파형 이상.',
      checkProblem: 'Vm=100√2 V일 때 Vrms는?',
      checkSolution: 'Vrms=100V. (100√2)/√2=100.',
      keyTakeaways: ['표시 전압은 대개 실효값', '정현파에서 Vm=√2 Vrms', '위상은 역률·전력과 직결'],
      checkQuestionIds: ['q_cc_x010'],
      relatedFormulaIds: ['f_ccx_06'],
      relatedQuestionIds: ['q_cc_x010'],
      tags: ['교류', '실효값', '교재형'],
      track: 'written',
      qualityTier: 'A',
      meta: _meta,
    ),

    // 7. 삼상
    Lesson(
      id: 'ccx_20',
      subjectId: WrittenSubjectIds.circuitControl,
      chapter: '삼상회로',
      section: '단상과 삼상 전력',
      title: '단상과 삼상 전력',
      objectives: [
        '선간전압·상전압, 선전류·상전류를 구분한다',
        'Y·Δ에서 √3 관계를 유도·적용한다',
        '삼상 유효전력 P=√3 VL IL cosθ를 계산한다',
      ],
      importance: [
        ImportanceBadge.mustMemorize,
        ImportanceBadge.calculationEssential,
        ImportanceBadge.practicalLinked,
      ],
      difficulty: Difficulty.medium,
      estimatedMinutes: 55,
      prerequisites: ['교류 실효값', '전력'],
      summary:
          '평형 삼상 Y결선에서 VL=√3 VP, IL=IP. '
          'Δ결선에서 VL=VP, IL=√3 IP. '
          '삼상 유효전력 P=√3 VL IL cosθ = 3 VP IP cosθ.',
      easyExplain:
          '삼상은 120°씩 어긋난 세 전원이 힘을 나눠 전달한다. '
          '공장 전동기·수전설비가 삼상을 쓰는 이유다.',
      whyNeeded: '전력공학·전기기기·실기 수변전 계산의 핵심이다.',
      keyTerms: ['선간전압 VL', '상전압 VP', '선전류 IL', '상전류 IP', 'Y', 'Δ'],
      theory:
          '√3은 120° 위상차로 두 상전압 벡터 차를 낼 때 나타난다. '
          '|Vab|=|Va−Vb|=√3 |Va|(평형). '
          '결선 착오·결상 시 전동기 과열·진동·소손 위험이 커진다. '
          '단상 전력 P=VI cosθ, 삼상은 위 공식.',
      formulas: [
        r'P_{1\phi}=VI\cos\theta',
        r'P_{3\phi}=\sqrt{3} V_L I_L \cos\theta',
        r'Y:\ V_L=\sqrt{3}V_P,\ I_L=I_P',
        r'\Delta:\ V_L=V_P,\ I_L=\sqrt{3}I_P',
      ],
      symbolMeanings: {'VL': '선간전압', 'VP': '상전압', 'IL': '선전류', 'IP': '상전류'},
      units: {'V': 'V', 'I': 'A', 'P': 'W'},
      conditions: '평형·정현·선형. 불평형·고조파는 대칭좌표 등 확장이 필요.',
      derivation: '세 상의 순시전력 합의 평균이 √3 VL IL cosθ로 정리된다.',
      example: 'VL=380V, IL=10A, pf=0.85 평형 삼상 유효전력은?',
      steps: [
        'P=√3×380×10×0.85',
        '√3×380≈658.2',
        '658.2×10=6582',
        '6582×0.85≈5594.7 W ≈ 5.59 kW',
        '검산: S=√3 VL IL≈6.58 kVA, P=S·pf≈5.59 kW',
      ],
      measurement: '선간전압 3개, 선전류 3개, 전력계 또는 2전력계법.',
      wrongCases: ['단상 공식 VI cosθ에 선간전압·선전류를 그대로 넣어 √3 누락', 'Y/Δ 관계 반대로 적용'],
      hazards: ['결상 운전 시 전동기 소손', '잘못된 결선으로 전압 불일치·단락'],
      diagnosisSteps: ['삼상 전압 균형 확인', '전류 균형·결상 여부', '전력·역률 측정'],
      safetyNotes: ['수전·전동기 결선 변경은 전원 차단·잠금표찰 후 자격자가 수행'],
      commonMistakes: ['√3 위치 오류', 'kW/kVA 혼동'],
      fieldUse: '수전용량, 전동기 입력, 케이블 전류.',
      examTrends: ['P=√3 VL IL cosθ', 'Y/Δ 전압전류'],
      confusableConcepts: ['선·상 전압', '피상·유효'],
      practicalLink: '실기 변압기·전동기·수전 계산.',
      checkProblem: 'VL=220V, IL=5A, cosθ=1일 때 P[kW]는?',
      checkSolution: 'P=√3×220×5×1≈1.905 kW.',
      keyTakeaways: [
        '삼상 전력에 √3을 빼먹지 않는다',
        'Y와 Δ의 선·상 관계가 다르다',
        '결상은 심각한 설비 위험이다',
      ],
      checkQuestionIds: ['q_cc_x020'],
      relatedFormulaIds: ['f_pex_p3', 'f_ccx_25'],
      relatedQuestionIds: ['q_pe_x001'],
      tags: ['삼상', '전력', '교재형'],
      track: 'written',
      qualityTier: 'A',
      meta: _meta,
    ),

    // 8. 역률
    Lesson(
      id: 'cc_ac_power',
      subjectId: WrittenSubjectIds.circuitControl,
      chapter: '교류회로',
      section: '전력·역률',
      title: '역률과 무효전력',
      objectives: [
        '유효·무효·피상전력을 구분한다',
        '역률 저하가 전류·손실에 미치는 영향을 설명한다',
        '콘덴서 보상의 원리와 과보상 주의를 이해한다',
      ],
      importance: [
        ImportanceBadge.mustMemorize,
        ImportanceBadge.calculationEssential,
        ImportanceBadge.frequentlyAsked,
        ImportanceBadge.practicalLinked,
      ],
      difficulty: Difficulty.medium,
      estimatedMinutes: 50,
      prerequisites: ['교류 실효값', '전력'],
      summary:
          'P=VI cosθ, Q=VI sinθ, S=VI, cosθ=P/S. '
          '역률이 낮으면 같은 P에 전류가 커져 손실·전압강하가 증가한다.',
      easyExplain:
          '유효전력은 실제로 일한 양, 무효전력은 자계·전계를 만들고 오가는 양, '
          '피상전력은 설비가 감당해야 하는 전체 부담에 가깝다.',
      whyNeeded: '수전설비·요금·케이블 용량·실기 역률개선 계산의 핵심이다.',
      keyTerms: ['유효 P[W]', '무효 Q[var]', '피상 S[VA]', '진상·지상', '과보상'],
      theory:
          '유도성 부하(전동기·변압기)는 지상 역률이 되기 쉽다. '
          '병렬 콘덴서로 Q를 보상하면 전원측 전류가 줄고 역률이 개선된다. '
          '필요 이상으로 보상하면 진상·전압 상승·공진 위험이 있다. '
          '삼상에서는 P=√3 VL IL cosθ.',
      formulas: [
        r'P=VI\cos\theta,\quad Q=VI\sin\theta,\quad S=VI',
        r'S=\sqrt{P^2+Q^2},\quad \cos\theta=P/S',
        r'Q_C=P(\tan\theta_1-\tan\theta_2)',
      ],
      symbolMeanings: {
        'P': '유효전력',
        'Q': '무효전력',
        'S': '피상전력',
        'θ': '위상각',
        'Qc': '보상 콘덴서 용량',
      },
      units: {'P': 'W', 'Q': 'var', 'S': 'VA', 'Qc': 'var'},
      conditions: '정현파 정상상태. 고조파·왜형 시 역률 정의·측정이 달라질 수 있다.',
      derivation: '복소전력 S=P+jQ, 순시전력 평균이 P.',
      example: '단상 220V, 10A, pf=0.8 지상. P,Q,S와 pf=0.95로 개선 시 Qc.',
      steps: [
        'S=220×10=2200 VA',
        'P=1760 W, Q=1320 var (sinθ=0.6)',
        '검산: √(1760²+1320²)=2200',
        'θ1=cos⁻¹0.8, θ2=cos⁻¹0.95',
        'Qc=P(tanθ1−tanθ2)≈1760(0.75−0.3287)≈741 var',
      ],
      measurement: '전력분석기·역률계. 전류만 보고 역률을 짐작하지 않는다.',
      wrongCases: ['진상·지상 구분 없이 콘덴서만 추가', '단상 공식으로 삼상 보상량을 계산'],
      hazards: ['과보상으로 전압 상승·기기 스트레스', '고조파와 콘덴서 공진'],
      diagnosisSteps: ['현재 P,Q,S·역률 측정', '목표 역률 설정', 'Qc 산정 후 단계 투입·감시'],
      safetyNotes: ['콘덴서 회로는 잔류전하에 주의(방전 확인)', '실제 뱅크 선정은 고조파·전압·제조사 지침을 따른다'],
      commonMistakes: ['sinθ 오계산', '√(1−pf²) 부호·지상만 가정'],
      fieldUse: '수전 역률 관리, 전기요금, 케이블 여유.',
      examTrends: ['PQS 삼각형', 'Qc=P(tan1−tan2)'],
      confusableConcepts: ['역률과 효율', 'VA와 W'],
      practicalLink: '실기 역률개선·콘덴서 용량.',
      checkProblem: 'S=100kVA, P=80kW일 때 역률은?',
      checkSolution: 'cosθ=P/S=0.8. Q=60 kvar (3-4-5).',
      keyTakeaways: ['역률= P/S', '낮은 역률은 전류·손실 증가', '보상은 필요량만큼, 과보상 주의'],
      checkQuestionIds: ['q_cc_01'],
      relatedFormulaIds: ['f_ac_power', 'f_pf', 'f_pex_qc'],
      relatedQuestionIds: ['q_cc_01', 'q_cc_02'],
      tags: ['역률', '무효전력', '교재형'],
      track: 'written',
      qualityTier: 'A',
      meta: _meta,
    ),

    // 9. 차단기·접지
    Lesson(
      id: 'fs_grounding',
      subjectId: WrittenSubjectIds.facilityStandards,
      chapter: '접지·보호',
      section: '차단기·누전차단기·접지',
      title: '차단기·누전차단기·접지',
      objectives: [
        '과부하·단락·누전의 차이를 설명한다',
        '배선용차단기와 누전차단기의 역할을 구분한다',
        '접지·본딩의 목적과 안전 절차를 서술한다',
      ],
      importance: [
        ImportanceBadge.conceptual,
        ImportanceBadge.regulationLatest,
        ImportanceBadge.practicalLinked,
        ImportanceBadge.frequentlyAsked,
      ],
      difficulty: Difficulty.medium,
      estimatedMinutes: 50,
      prerequisites: ['전류·전력 기초', '감전 위험 인식'],
      summary:
          '과부하는 정격 초과 지속 전류, 단락은 낮은 임피던스 대전류, '
          '누전(지락)은 의도치 않은 대지로의 전류다. '
          '차단기·누전차단기·접지는 목적과 동작 원리가 다르며, '
          '구체 정격·시설방법은 최신 KEC·법령·설계조건을 확인한다.',
      easyExplain:
          '차단기는 전선·기기가 견디지 못할 전류를 끊고, '
          '누전차단기는 사람에게 위험한 누설을 빠르게 감지해 끊는 쪽에 가깝다. '
          '접지는 고장 전류와 이상전압이 안전하게 흘러가도록 길을 만든다.',
      whyNeeded: '감전·화재 예방과 전기기사 설비기준·실기 안전관리의 핵심이다.',
      keyTerms: [
        'MCCB/배선용차단기',
        'ELB/누전차단기(또는 누전차단 기능)',
        '과부하·단락·지락',
        '접지·등전위본딩',
        'LOTO(잠금·표찰)',
      ],
      theory:
          '차단기 정격만 키우면 “안 끊기는” 상태가 되어 전선이 먼저 과열될 수 있다. '
          '보호협조는 전선 허용전류·차단기·상위 보호와의 관계로 설계한다. '
          '접지는 감전 방지, 보호기기 동작, 뇌서지·이상전압 억제 등에 기여한다. '
          '수치(접지저항 목표값, 감도전류 등)는 개정되므로 암기 숫자로 단정하지 않는다.',
      formulas: [
        r'\text{(개념) 고장전류} \gg \text{부하전류}',
        r'I_n,\ I_{cu}\ \text{등 정격은 제조사·설계도서 확인}',
      ],
      symbolMeanings: {'In': '정격전류(개념)', 'Icu': '정격차단용량(개념)'},
      units: {'I': 'A'},
      conditions:
          '학습용 원칙. 시설·수치는 Q-Net 출제기준, KEC, 국가법령정보센터, '
          '한국전기안전공사·제조사 자료를 확인일 기준으로 재확인.',
      derivation: '해당 없음(안전·시설 원칙).',
      example: '부하전류가 늘어 트립이 잦다고 차단기만 상향하는 것이 왜 위험한지 서술하라.',
      steps: [
        '현상: 트립 빈발',
        '원인 후보: 실제 과부하, 기동전류, 고장, 오선정',
        '차단기만 상향 → 전선·기기가 과전류에 노출될 수 있음',
        '올바른 접근: 부하·배선·보호협조를 함께 검토(전문가)',
      ],
      measurement:
          '절연저항계·클램프(누설)·접지저항계 등은 목적에 맞게. '
          '활선 측정은 위험하므로 절차·자격 필요.',
      wrongCases: ['트립 짜증으로 정격만 상향', '접지선을 임의 제거', '누전차단기를 과전류 차단기와 동일시'],
      hazards: ['감전', '아크·화재', '고장 시 금속 외함에 위험한 전위'],
      diagnosisSteps: [
        '전원 차단·검전·잠금표찰',
        '육안·냄새·변색 확인',
        '절연·접지·결선 확인',
        '이상 시 자격 있는 전기 전문가에게 의뢰',
      ],
      safetyNotes: [
        '전기 작업은 전원 차단, 무전압 확인, 잠금·표찰, 보호구가 기본이다',
        '특정 용량·굵기를 모든 현장에 동일 적용한다고 단정하지 않는다',
        '확인일: 2026-07-22 — 응시·시공 전 공식 자료 재확인',
      ],
      commonMistakes: ['누전과 단락을 같은 말로 사용', '법령 수치를 출처 없이 암기'],
      fieldUse: '분전반 구성, 안전점검, 감리 지적 사항 이해.',
      examTrends: ['접지 목적', '보호기기 역할 구분', 'KEC 반영 흐름'],
      confusableConcepts: ['과전류차단 vs 누전차단', '접지 vs 중성선'],
      practicalLink: '실기 안전관리·수변전·점검.',
      checkProblem: '차단기 정격만 높이는 것이 위험한 이유를 한 가지 쓰시오.',
      checkSolution:
          '전선·부하가 과전류를 견디지 못하는데 보호기기만 늦게/안 동작하면 '
          '과열·화재 위험이 커진다. 보호협조·배선 용량을 함께 봐야 한다.',
      keyTakeaways: [
        '과부하·단락·누전은 다르다',
        '차단기 상향만으로 해결하지 않는다',
        '접지·차단·절차가 안전을 만든다',
        '수치는 공식 자료로 재확인한다',
      ],
      checkQuestionIds: ['q_fs_01'],
      relatedFormulaIds: ['f_fsx_01'],
      relatedQuestionIds: ['q_fs_01', 'q_fs_02'],
      tags: ['접지', '차단기', '안전', '교재형', 'needsReview'],
      track: 'written',
      qualityTier: 'A',
      meta: _metaFs,
    ),

    // 10. 시퀀스·전동기
    Lesson(
      id: 'ccx_41',
      subjectId: WrittenSubjectIds.circuitControl,
      chapter: '시퀀스제어 연계',
      section: '전동기와 시퀀스 제어',
      title: '전동기와 시퀀스 제어',
      objectives: [
        '전자접촉기·열동계전기·자기유지·인터록을 설명한다',
        '정역운전과 비상정지의 기본 논리를 서술한다',
        '기동전류·결상·과부하 증상을 연결한다',
      ],
      importance: [
        ImportanceBadge.practicalLinked,
        ImportanceBadge.frequentlyAsked,
        ImportanceBadge.conceptual,
      ],
      difficulty: Difficulty.medium,
      estimatedMinutes: 55,
      prerequisites: ['유도전동기 기초', '릴레이 접점 개념'],
      summary:
          '시퀀스제어는 접점 논리로 전동기 기동·정지·보호를 구성한다. '
          '자기유지는 운전 a접점으로 회로를 유지하고, 정지·보호는 b접점으로 끊는다. '
          '정역은 인터록으로 동시 투입을 막는다.',
      easyExplain:
          '누름 버튼을 떼도 계속 도는 것은 “자기유지” 덕분이고, '
          '정방향·역방향을 동시에 넣지 못하게 막는 것이 “인터록”이다.',
      whyNeeded: '전기기사 실기 시퀀스·자동제어와 현장 제어반의 기본이다.',
      keyTerms: [
        'MC(전자접촉기)',
        'THR(열동계전기)',
        'a접점(닫힘)·b접점(열림)',
        '자기유지',
        '인터록',
        '비상정지(EMS)',
      ],
      theory:
          '기동 시 유도전동기는 정격전류의 수배(기종·기동방식에 따라 상이)가 흐를 수 있어 '
          '전압강하·차단기 선정에 영향을 준다. '
          '열동계전기는 과부하에 의한 과열을 감지해 회로를 차단하는 데 쓰인다. '
          '결상 시 남은 상 전류가 증가하고 토크 부족·진동·소손이 발생할 수 있다. '
          '비상정지는 우선적으로 전원을 안전하게 차단하는 경로를 제공한다.',
      formulas: [
        r'N_s=120f/P,\quad s=(N_s-N)/N_s',
        r'\text{기동전류는 명판·기동방식·설계자료로 확인}',
      ],
      symbolMeanings: {'Ns': '동기속도', 's': '슬립', 'MC': '전자접촉기'},
      units: {'N': 'r/min', 'f': 'Hz'},
      conditions: '학습용 일반 구성. 실제 회로는 도면·안전기준·제조사 매뉴얼을 따른다.',
      derivation: '릴레이 논리는 논리식(AND/OR/NOT)과 등가.',
      example: '자기유지 회로에서 운전(a)·MC 보조(a)·정지(b)·THR(b)의 역할을 설명하라.',
      steps: [
        '운전 버튼(a) 순간 투입 → MC 여자',
        'MC 보조 a가 자기유지',
        '정지 b 또는 THR b가 열리면 유지 해제',
        '검산: 정지 시 반드시 코일 전원 차단되는지 확인',
      ],
      measurement:
          '제어전원 확인, 코일 전압, 접점 도통, 모터 전류(클램프). '
          '타임차트와 실측 순서를 비교한다.',
      wrongCases: ['정역 인터록 누락으로 상간 단락', '비상정지 우회 배선', 'THR를 단락해 과부하 보호 무력화'],
      hazards: ['끼임·회전부 상해', '단락·아크', '결상·과부하로 화재·소손'],
      diagnosisSteps: [
        '비상정지·전원 상태 확인',
        '제어회로 도통·코일 소손 여부',
        '모터 전류·진동·온도',
        '결상·과부하·기구 이상 판정',
      ],
      safetyNotes: ['회전부 작업 전 전원 차단·잠금표찰', '시운전은 사람·부하 상태를 확인한 뒤 진행'],
      commonMistakes: ['a/b접점 혼동', '자기유지와 인터록을 같은 것으로 이해'],
      fieldUse: '반송·펌프·팬 제어반, PLC 이전 단계의 유접점 논리.',
      examTrends: ['자기유지', '정역 인터록', '열동계전기'],
      confusableConcepts: ['주회로 vs 제어회로', 'MC vs 릴레이'],
      practicalLink: '실기 시퀀스·prac_sequence 자기유지 문제와 연계.',
      checkProblem: '자기유지에 필요한 접점 조합을 쓰시오.',
      checkSolution: '운전용 a(순간) + MC 자기유지 a, 정지·보호용 b가 직렬로 코일 회로를 구성.',
      keyTakeaways: [
        '자기유지=운전 유지, 인터록=동시 투입 방지',
        '보호접점을 우회하지 않는다',
        '기동전류·결상·과부하를 함께 본다',
      ],
      checkQuestionIds: const [],
      relatedFormulaIds: ['f_mx_ns', 'f_mx_slip'],
      relatedQuestionIds: ['q_emach_02'],
      tags: ['시퀀스', '전동기', '교재형'],
      track: 'written',
      qualityTier: 'A',
      meta: _meta,
    ),
  ];
}

import '../../models/learning_models.dart';
import '../../core/constants/app_constants.dart';

class SubjectsData {
  static const List<SubjectInfo> all = [
    SubjectInfo(
      id: WrittenSubjectIds.electromagnetics,
      name: '전기자기학',
      shortName: '전기자기',
      description: '정전계·정자계·전자유도·전자파 등 전자기학 기초와 계산',
      chapters: ['정전계', '정자계', '전자유도', '전자파·맥스웰', '유전체·자성체'],
    ),
    SubjectInfo(
      id: WrittenSubjectIds.powerEngineering,
      name: '전력공학',
      shortName: '전력',
      description: '발전·송전·배전, 선로정수, 고장계산, 안정도, 보호',
      chapters: ['발전', '송전', '배전', '선로정수·코로나', '고장·안정도·보호'],
    ),
    SubjectInfo(
      id: WrittenSubjectIds.electricalMachines,
      name: '전기기기',
      shortName: '기기',
      description: '직류기·변압기·유도기·동기기·정류기 구조와 특성',
      chapters: ['직류기', '변압기', '유도전동기', '동기기', '특수기기·정류'],
    ),
    SubjectInfo(
      id: WrittenSubjectIds.circuitControl,
      name: '회로이론 및 제어공학',
      shortName: '회로·제어',
      description: '회로해석, 과도현상, 4단자, 제어계 응답·안정도',
      chapters: ['직류회로', '교류회로', '과도·라플라스', '4단자·필터', '제어공학'],
    ),
    SubjectInfo(
      id: WrittenSubjectIds.facilityStandards,
      name: '전기설비기술기준',
      shortName: '설비기준',
      description: 'KEC 기반 전기설비 기술기준(구 판단기준 명칭과 병행 안내)',
      chapters: ['총칙·전선', '접지·피뢰', '저압·고압', '발전·변전', '안전·검사'],
    ),
  ];

  static SubjectInfo? byId(String id) {
    for (final s in all) {
      if (s.id == id) return s;
    }
    return null;
  }
}

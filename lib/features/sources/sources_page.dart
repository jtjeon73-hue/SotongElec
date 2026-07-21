import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../data/catalog.dart';
import '../../shared/widgets/common_widgets.dart';

class SourcesPage extends StatelessWidget {
  const SourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionTitle('자료 출처·업데이트 이력'),
          Text('콘텐츠 버전 ${AppConstants.contentVersion}'),
          Text('최종 업데이트 ${AppConstants.lastContentUpdate}'),
          const SectionTitle('공식 출처'),
          const Text('· Q-Net (한국산업인력공단) — 출제기준·검정방법·일정'),
          Text('· ${AppConstants.qnetUrl}'),
          const Text('· 국가법령정보센터 — 관련 법령'),
          const Text('· 한국전기설비규정(KEC) 관련 공식 자료'),
          const SectionTitle('자체 제작 콘텐츠'),
          Text(
            '강의 ${Catalog.lessonCount}, 공식 ${Catalog.formulaCount}, '
            '기출유형 연습문제 ${Catalog.questionCount}, 실기 ${Catalog.practicalCount}, '
            '용어 ${Catalog.termCount}, 전기상식 ${Catalog.knowledgeCount}, '
            '도구 ${Catalog.toolCount}, 계산기 ${Catalog.calculatorCount}',
          ),
          const InfoCallout(
            text:
                '「기출유형 연습문제」는 출제 경향을 반영해 자체 작성한 문제입니다. '
                '특정 연도 기출 원문·유료 해설집을 복제하지 않습니다. '
                '존재하지 않는 기출·출처를 표기하지 않습니다.',
          ),
          const SectionTitle('저작권'),
          const Text(
            '저작권이 있는 문제집·강의·해설집을 복사하지 않습니다. '
            '공개 범위가 불확실한 기출 원문은 사용하지 않습니다.',
          ),
          const SectionTitle('최신 확인 방법'),
          const Text('1. Q-Net 출제기준 자료실에서 해당 종목 최신 파일 확인'),
          const Text('2. 법령·KEC 개정 여부 확인'),
          const Text('3. 시험 직전 회차 공지 재확인'),
          const SectionTitle('오류 제보'),
          const Text(
            'GitHub 저장소 이슈로 제보해 주세요: '
            'https://github.com/jtjeon73-hue/SotongElec',
          ),
          const SectionTitle('검토 상태'),
          const StatusBadge(label: '공학 원리·계산: 자체 검토', needsReview: false),
          const SizedBox(height: 8),
          const StatusBadge(
            label: '법령·기술기준 수치: 시험 전 Q-Net/법령 재확인 필요',
            needsReview: true,
          ),
        ],
      ),
    );
  }
}

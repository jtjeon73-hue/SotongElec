import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../data/subjects/subjects_data.dart';
import '../../shared/widgets/common_widgets.dart';

class ExamGuidePage extends StatelessWidget {
  const ExamGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionTitle('전기기사 시험 안내'),
          InfoCallout(
            text:
                '아래 내용은 한국산업인력공단 Q-Net에 공개된 기사 등급 일반 검정기준·출제기준을 참고한 학습용 정리입니다. '
                '회차별 일정·세부 출제범위·응시자격은 반드시 ${AppConstants.qnetUrl} 에서 재확인하세요.',
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '출제기준 적용 기간',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(AppConstants.examStandardPeriod),
                  Text('출처: ${AppConstants.examStandardSource}'),
                  const SizedBox(height: 8),
                  const StatusBadge(label: '공식 출처 재확인 권장', needsReview: true),
                ],
              ),
            ),
          ),
          const SectionTitle('필기시험'),
          Text(
            '과목 수: ${AppConstants.writtenSubjectCount}과목\n'
            '문항: 과목당 ${AppConstants.writtenQuestionsPerSubject}문항 (객관식 4지 택일)\n'
            '시간: 과목당 ${AppConstants.writtenMinutesPerSubject}분 '
            '(총 ${AppConstants.writtenTotalMinutes}분, CBT 운영 방식은 공단 안내 확인)\n'
            '합격: 과목당 ${AppConstants.writtenPassPerSubject.toInt()}점 이상, '
            '전 과목 평균 ${AppConstants.writtenPassAverage.toInt()}점 이상',
          ),
          const SizedBox(height: 12),
          ...SubjectsData.all.map(
            (s) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.book_outlined),
              title: Text(s.name),
              subtitle: Text(s.description),
            ),
          ),
          const InfoCallout(
            text:
                '과목명 안내: 현재 과목명은 「전기설비기술기준」입니다. '
                '과거 「전기설비기술기준 및 판단기준」 명칭으로 학습한 수험생도 많으니 자료에서 병기될 수 있습니다. '
                '내용은 KEC(한국전기설비규정) 반영 흐름을 따릅니다.',
            color: Color(0xFF0D9488),
          ),
          const SectionTitle('실기시험'),
          Text(
            '과목: 전기설비설계 및 관리\n'
            '방법: 필답형\n'
            '시간: ${AppConstants.practicalMinutes}분 (2시간 30분)\n'
            '합격: ${AppConstants.practicalPassScore.toInt()}점 이상',
          ),
          const SectionTitle('학습 권장 흐름'),
          const Text(
            '이론 학습 → 핵심 공식 → 공학용 계산기 → 대표 예제 → 기출유형 → '
            '오답 복습 → 모의고사 → 실기 대비 → 취약점 분석 → 합격 준비도 확인',
          ),
        ],
      ),
    );
  }
}

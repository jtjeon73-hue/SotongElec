import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/storage/study_progress_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../data/catalog.dart';
import '../../data/subjects/subjects_data.dart';
import '../../models/learning_models.dart';
import '../../shared/widgets/common_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<StudyProgressController>();
    final readiness = p.readinessScore();
    final days = p.examDate == null
        ? null
        : p.examDate!.difference(DateTime.now()).inDays;
    final formula =
        Catalog.formulas[DateTime.now().day % Catalog.formulas.length];
    final knowledge =
        Catalog.knowledge[DateTime.now().day % Catalog.knowledge.length];
    final recent = <Lesson>[];
    for (final id in p.recentLessonIds) {
      final l = Catalog.lessonById(id);
      if (l != null) recent.add(l);
      if (recent.length >= 5) break;
    }

    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.deepNavy, AppColors.navy, AppColors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppConstants.appName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  AppConstants.appSubtitle,
                  style: TextStyle(color: Color(0xFFCCFBF1), fontSize: 16),
                ),
                const SizedBox(height: 12),
                Text(
                  '등록 콘텐츠 · 강의 ${Catalog.lessonCount} · 공식 ${Catalog.formulaCount} · '
                  '문제 ${Catalog.questionCount} · 용어 ${Catalog.termCount} · '
                  '계산기 ${Catalog.calculatorCount}',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 220,
                child: StatTile(
                  label: '오늘의 학습 목표',
                  value: '${p.dailyGoalMinutes}분',
                  subtitle: '오늘 ${p.todayStudyMinutes()}분 완료',
                ),
              ),
              SizedBox(
                width: 220,
                child: StatTile(
                  label: '시험까지',
                  value: days == null ? '미설정' : '$days일',
                  subtitle: '학습계획에서 시험일 설정',
                  color: AppColors.teal,
                ),
              ),
              SizedBox(
                width: 220,
                child: StatTile(
                  label: '누적 풀이',
                  value: '${p.totalSolved}',
                  subtitle:
                      '정답률 ${(p.overallCorrectRate() * 100).toStringAsFixed(0)}%',
                  color: AppColors.blue,
                ),
              ),
              SizedBox(
                width: 220,
                child: StatTile(
                  label: '합격 준비도',
                  value: '${readiness.toStringAsFixed(0)}',
                  subtitle: '참고 지표',
                  color: AppColors.practicalAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const InfoCallout(
            text:
                '이 준비도는 실제 합격을 보장하는 공식 지표가 아니라 학습관리용 참고지표입니다. '
                '강의 완료·정답률·오답 복습·모의고사·학습 꾸준함을 반영합니다.',
            icon: Icons.warning_amber_outlined,
            color: AppColors.warning,
          ),
          const SectionTitle('필기 과목별 학습률'),
          ...SubjectsData.all.map((s) {
            final rate = p.subjectProgress(s.id);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => context.go('/written/${s.id}'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(s.name)),
                        Text('${(rate * 100).toStringAsFixed(0)}%'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: rate,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],
                ),
              ),
            );
          }),
          Text(
            '실기 학습률 ${(p.practicalProgress * 100).toStringAsFixed(0)}%',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: p.practicalProgress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
            color: AppColors.practicalAccent,
          ),
          const SectionTitle('학습 이어하기 · 최근 강의'),
          if (recent.isEmpty)
            const Text('아직 학습 기록이 없습니다. 필기 전체 학습에서 시작하세요.')
          else
            ...recent.map(
              (l) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.title),
                subtitle: Text('${l.chapter} · ${l.section}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('/lesson/${l.id}'),
              ),
            ),
          const SectionTitle('오늘 풀 문제 · 취약 과목'),
          FilledButton.icon(
            onPressed: () => context.go('/questions'),
            icon: const Icon(Icons.quiz_outlined),
            label: Text('기출유형 문제 ${Catalog.questionCount}문항 풀기'),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: p.weakSubjects().map((id) {
              final s = SubjectsData.byId(id);
              return ActionChip(
                label: Text(s?.shortName ?? id),
                onPressed: () => context.go('/written/$id'),
              );
            }).toList(),
          ),
          const SectionTitle('최근 오답 · 추천 복습'),
          if (p.wrongAnswers.isEmpty)
            const Text('오답이 없습니다. 문제를 풀어보세요.')
          else
            ...p.wrongAnswers.take(3).map((w) {
              final q = Catalog.questionById(w.questionId);
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.close, color: AppColors.danger),
                title: Text(q?.stem ?? w.questionId, maxLines: 2),
                onTap: () => context.go('/wrong'),
              );
            }),
          const SectionTitle('오늘의 공식 · 전기상식'),
          Card(
            child: ListTile(
              title: Text(formula.name),
              subtitle: Text(formula.meaning),
              trailing: const Icon(Icons.functions),
              onTap: () => context.go('/formulas?focus=${formula.id}'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text(knowledge.title),
              subtitle: Text(knowledge.overview),
              onTap: () => context.go('/knowledge/${knowledge.id}'),
            ),
          ),
          const SectionTitle('주간 학습 · 빠른 메뉴'),
          Text('이번 주 학습시간 ${p.weekStudyMinutes()}분'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                [
                      ('시험 안내', '/exam-guide'),
                      ('필기 학습', '/written'),
                      ('모의고사', '/mock'),
                      ('실기', '/practical'),
                      ('공식', '/formulas'),
                      ('계산기', '/calculators'),
                      ('오답노트', '/wrong'),
                      ('검색', '/search'),
                    ]
                    .map(
                      (e) => OutlinedButton(
                        onPressed: () => context.go(e.$2),
                        child: Text(e.$1),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}

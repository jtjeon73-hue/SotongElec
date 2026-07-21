import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/storage/study_progress_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../data/catalog.dart';
import '../../shared/widgets/common_widgets.dart';

class WrongAnswersPage extends StatelessWidget {
  const WrongAnswersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<StudyProgressController>();
    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionTitle('오답노트'),
          Text('${p.wrongAnswers.length}건'),
          if (p.wrongAnswers.isEmpty)
            const Text('오답이 없습니다.')
          else
            ...p.wrongAnswers.map((w) {
              final q = Catalog.questionById(w.questionId);
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(q?.stem ?? w.questionId),
                      Text('내 답: ${w.selectedAnswer}'),
                      Text('정답: ${w.correctAnswer}'),
                      Text('틀린 횟수: ${w.wrongCount} · ${w.wrongAt}'),
                      if (w.cause != null) Text('원인: ${w.cause}'),
                      Wrap(
                        spacing: 8,
                        children: [
                          FilterChip(
                            label: Text(w.mastered ? '숙달' : '미숙달'),
                            selected: w.mastered,
                            onSelected: (v) =>
                                p.markWrongMastered(w.questionId, v),
                          ),
                          ActionChip(
                            label: const Text('다시 풀기'),
                            onPressed: () =>
                                context.go('/questions?id=${w.questionId}'),
                          ),
                          ...w.relatedLessonIds.map(
                            (id) => ActionChip(
                              label: const Text('강의'),
                              onPressed: () => context.go('/lesson/$id'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          const SectionTitle('오답 원인 예시'),
          const Text(
            '개념 부족 · 공식 암기 부족 · 계산 실수 · 단위 실수 · '
            '문제 해석 실수 · 시간 부족 · 법규 혼동 · 단순 실수',
          ),
        ],
      ),
    );
  }
}

class StudyPlanPage extends StatelessWidget {
  const StudyPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<StudyProgressController>();
    final incomplete = Catalog.lessons
        .where((l) => !p.completedLessons.contains(l.id))
        .take(5)
        .toList();

    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionTitle('학습계획 · 진도'),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('시험일'),
            subtitle: Text(
              p.examDate == null
                  ? '미설정'
                  : p.examDate!.toIso8601String().substring(0, 10),
            ),
            trailing: FilledButton(
              onPressed: () async {
                final d = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 730)),
                  initialDate:
                      p.examDate ??
                      DateTime.now().add(const Duration(days: 90)),
                );
                if (d != null) await p.setExamDate(d);
              },
              child: const Text('설정'),
            ),
          ),
          Text('하루 공부 가능 시간: ${p.dailyGoalMinutes}분'),
          Slider(
            value: p.dailyGoalMinutes.toDouble(),
            min: 30,
            max: 300,
            divisions: 27,
            label: '${p.dailyGoalMinutes}분',
            onChanged: (v) => p.setDailyGoal(v.round()),
          ),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('필기'),
                selected: p.focusTrack == 'written',
                onSelected: (_) => p.setFocusTrack('written'),
              ),
              ChoiceChip(
                label: const Text('실기'),
                selected: p.focusTrack == 'practical',
                onSelected: (_) => p.setFocusTrack('practical'),
              ),
              ChoiceChip(
                label: const Text('병행'),
                selected: p.focusTrack == 'both',
                onSelected: (_) => p.setFocusTrack('both'),
              ),
            ],
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('다크모드'),
            value: p.darkMode,
            onChanged: p.setDarkMode,
          ),
          const SectionTitle('오늘 할 일'),
          ...incomplete.map(
            (l) => ListTile(
              leading: const Icon(Icons.play_circle_outline),
              title: Text(l.title),
              subtitle: Text('예상 ${l.estimatedMinutes}분'),
              onTap: () => context.go('/lesson/${l.id}'),
            ),
          ),
          if (p.wrongAnswers.where((w) => !w.mastered).isNotEmpty)
            ListTile(
              leading: const Icon(Icons.replay, color: AppColors.danger),
              title: Text(
                '오답 복습 ${p.wrongAnswers.where((w) => !w.mastered).length}건',
              ),
              onTap: () => context.go('/wrong'),
            ),
          const SectionTitle('시험 전 최종 점검표'),
          const Text('· 출제기준·시험일 Q-Net 확인'),
          const Text('· 과목별 공식 암기'),
          const Text('· 모의고사 과락 여부 점검'),
          const Text('· 실기 단답·계산 키워드 점검'),
          const Text('· 계산기 DEG/메모리 초기화'),
        ],
      ),
    );
  }
}

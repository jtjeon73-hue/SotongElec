import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/storage/study_progress_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../data/catalog.dart';
import '../../data/subjects/subjects_data.dart';
import '../../models/content_meta.dart';
import '../../shared/widgets/common_widgets.dart';

class WrittenHubPage extends StatelessWidget {
  const WrittenHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<StudyProgressController>();
    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionTitle('필기 전체 학습'),
          Text('등록 강의 ${Catalog.lessonCount}개 · 문제 ${Catalog.questionCount}문항'),
          const SizedBox(height: 12),
          ...SubjectsData.all.map((s) {
            final lessons = Catalog.lessonsBySubject(s.id);
            final rate = p.subjectProgress(s.id);
            return Card(
              child: ListTile(
                title: Text(s.name),
                subtitle: Text(
                  '${s.description}\n강의 ${lessons.length} · 학습률 ${(rate * 100).toStringAsFixed(0)}%',
                ),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('/written/${s.id}'),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class SubjectPage extends StatelessWidget {
  const SubjectPage({super.key, required this.subjectId});

  final String subjectId;

  @override
  Widget build(BuildContext context) {
    final subject = SubjectsData.byId(subjectId);
    final lessons = Catalog.lessonsBySubject(subjectId);
    final p = context.watch<StudyProgressController>();

    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionTitle(subject?.name ?? subjectId),
          Text(subject?.description ?? ''),
          const SizedBox(height: 8),
          Text('대단원: ${subject?.chapters.join(' · ') ?? ''}'),
          const SizedBox(height: 16),
          ...lessons.map((l) {
            final done = p.completedLessons.contains(l.id);
            return Card(
              child: ListTile(
                leading: Icon(
                  done ? Icons.check_circle : Icons.play_circle_outline,
                  color: done ? AppColors.success : AppColors.blue,
                ),
                title: Text(l.title),
                subtitle: Text(
                  '${l.chapter} › ${l.section} · ${l.estimatedMinutes}분 · ${l.difficulty.label}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('/lesson/${l.id}'),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class LessonPage extends StatefulWidget {
  const LessonPage({super.key, required this.lessonId});

  final String lessonId;

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  late final TextEditingController _memo;

  @override
  void initState() {
    super.initState();
    final p = context.read<StudyProgressController>();
    _memo = TextEditingController(text: p.notes[widget.lessonId] ?? '');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StudyProgressController>().markLessonOpened(widget.lessonId);
    });
  }

  @override
  void dispose() {
    _memo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lesson = Catalog.lessonById(widget.lessonId);
    if (lesson == null) {
      return const PageFrame(child: Text('강의를 찾을 수 없습니다.'));
    }
    final p = context.watch<StudyProgressController>();
    final all = Catalog.lessonsBySubject(lesson.subjectId);
    final idx = all.indexWhere((e) => e.id == lesson.id);
    final done = p.completedLessons.contains(lesson.id);
    final bookmarked = p.bookmarks.contains(lesson.id);

    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionTitle(lesson.title),
          Text('${lesson.chapter} › ${lesson.section}'),
          const SizedBox(height: 8),
          ImportanceChips(lesson.importance),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              Chip(label: Text('난이도 ${lesson.difficulty.label}')),
              Chip(label: Text('예상 ${lesson.estimatedMinutes}분')),
              if (lesson.meta?.needsReview == true)
                const StatusBadge(label: '최신 기준 검토 필요', needsReview: true),
            ],
          ),
          const SectionTitle('학습목표'),
          ...lesson.objectives.map((o) => Text('· $o')),
          const SectionTitle('핵심 요약'),
          Text(lesson.summary),
          const SectionTitle('상세 이론'),
          Text(lesson.theory),
          const SectionTitle('공식'),
          ...lesson.formulas.map((f) => FormulaBox(f)),
          const SectionTitle('기호 · 단위'),
          ...lesson.symbolMeanings.entries.map(
            (e) => Text('${e.key}: ${e.value}'),
          ),
          ...lesson.units.entries.map((e) => Text('${e.key} 단위: ${e.value}')),
          const SectionTitle('사용 조건 · 유도/원리'),
          Text(lesson.conditions),
          Text(lesson.derivation),
          const SectionTitle('대표 예제 · 단계별 풀이'),
          Text(lesson.example),
          ...lesson.steps.asMap().entries.map(
            (e) => Text('${e.key + 1}. ${e.value}'),
          ),
          const SectionTitle('자주 틀리는 부분 · 현장 활용'),
          ...lesson.commonMistakes.map((m) => Text('· $m')),
          Text(lesson.fieldUse),
          const SectionTitle('확인 문제 · 관련 자료'),
          Wrap(
            spacing: 8,
            children: [
              ...lesson.checkQuestionIds.map(
                (id) => ActionChip(
                  label: Text('문제 $id'),
                  onPressed: () => context.go('/questions?id=$id'),
                ),
              ),
              ...lesson.relatedFormulaIds.map(
                (id) => ActionChip(
                  label: Text('공식 $id'),
                  onPressed: () => context.go('/formulas?focus=$id'),
                ),
              ),
            ],
          ),
          const SectionTitle('학습 완료 · 즐겨찾기 · 메모'),
          Wrap(
            spacing: 8,
            children: [
              FilledButton.icon(
                onPressed: () => p.toggleLessonComplete(lesson.id),
                icon: Icon(done ? Icons.check : Icons.check_box_outline_blank),
                label: Text(done ? '학습 완료됨' : '학습 완료 표시'),
              ),
              OutlinedButton.icon(
                onPressed: () => p.toggleBookmark(lesson.id),
                icon: Icon(bookmarked ? Icons.bookmark : Icons.bookmark_border),
                label: Text(bookmarked ? '북마크됨' : '즐겨찾기'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _memo,
            maxLines: 3,
            decoration: const InputDecoration(labelText: '개인 메모'),
            onChanged: (v) => p.setNote(lesson.id, v),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (idx > 0)
                OutlinedButton(
                  onPressed: () => context.go('/lesson/${all[idx - 1].id}'),
                  child: const Text('이전 강의'),
                ),
              const Spacer(),
              if (idx >= 0 && idx < all.length - 1)
                FilledButton(
                  onPressed: () => context.go('/lesson/${all[idx + 1].id}'),
                  child: const Text('다음 강의'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

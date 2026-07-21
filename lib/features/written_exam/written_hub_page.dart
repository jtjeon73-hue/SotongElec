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
          Text(
            '등록 강의 ${Catalog.lessonCount}개 · 문제 ${Catalog.questionCount}문항 · '
            '공식 ${Catalog.formulaCount}개',
          ),
          const SizedBox(height: 12),
          ...SubjectsData.all.map((s) {
            final lessons = Catalog.lessonsBySubject(s.id);
            final qs = Catalog.questionsBySubject(s.id);
            final fs = Catalog.formulasBySubject(s.id);
            final rate = p.subjectProgress(s.id);
            return Card(
              child: ListTile(
                title: Text(s.name),
                subtitle: Text(
                  '${s.description}\n'
                  '강의 ${lessons.length} · 공식 ${fs.length} · 문제 ${qs.length} · '
                  '학습률 ${(rate * 100).toStringAsFixed(0)}%',
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
          Text(
            '강의 ${lessons.length} · '
            '공식 ${Catalog.formulasBySubject(subjectId).length} · '
            '문제 ${Catalog.questionsBySubject(subjectId).length}',
          ),
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
          const SectionTitle('1. 이번 강의에서 배울 내용'),
          ...lesson.objectives.map((o) => Text('· $o')),
          if (lesson.prerequisites.isNotEmpty) ...[
            const Text('선수 지식'),
            ...lesson.prerequisites.map((p) => Text('· $p')),
          ],
          const SectionTitle('2. 한눈에 보는 핵심'),
          Text(lesson.summary),
          const SectionTitle('3. 개념 이해'),
          if (lesson.easyExplain.isNotEmpty) ...[
            Text(lesson.easyExplain, style: const TextStyle(height: 1.45)),
            const SizedBox(height: 8),
          ],
          Text(lesson.theory),
          if (lesson.confusableConcepts.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text('혼동하기 쉬운 개념'),
            ...lesson.confusableConcepts.map((c) => Text('· $c')),
          ],
          const SectionTitle('4. 공식과 단위'),
          ...lesson.formulas.map((f) => FormulaBox(f)),
          ...lesson.symbolMeanings.entries.map(
            (e) => Text('${e.key}: ${e.value}'),
          ),
          ...lesson.units.entries.map((e) => Text('${e.key} 단위: ${e.value}')),
          Text('적용 조건: ${lesson.conditions}'),
          Text('유도/원리: ${lesson.derivation}'),
          const SectionTitle('5. 대표 예제'),
          Text(lesson.example),
          const SectionTitle('6. 단계별 풀이'),
          ...lesson.steps.asMap().entries.map(
            (e) => Text('${e.key + 1}. ${e.value}'),
          ),
          if (lesson.examTrends.isNotEmpty) ...[
            const SectionTitle('7. 시험에 자주 나오는 부분'),
            ...lesson.examTrends.map((t) => Text('· $t')),
          ],
          const SectionTitle('8. 자주 틀리는 부분'),
          ...lesson.commonMistakes.map((m) => Text('· $m')),
          const SectionTitle('9. 실기·현장 연결'),
          Text(lesson.fieldUse),
          if (lesson.practicalLink.isNotEmpty) Text(lesson.practicalLink),
          const SectionTitle('10. 확인 문제'),
          Wrap(
            spacing: 8,
            children: [
              ...lesson.checkQuestionIds.map(
                (id) => ActionChip(
                  label: Text('문제 $id'),
                  onPressed: () => context.go('/questions?id=$id'),
                ),
              ),
            ],
          ),
          const SectionTitle('11. 관련 학습'),
          Wrap(
            spacing: 8,
            children: [
              ...lesson.relatedFormulaIds.map(
                (id) => ActionChip(
                  label: Text('공식 $id'),
                  onPressed: () => context.go('/formulas?focus=$id'),
                ),
              ),
              ...lesson.relatedQuestionIds.map(
                (id) => ActionChip(
                  label: Text('문제 $id'),
                  onPressed: () => context.go('/questions?id=$id'),
                ),
              ),
              ...lesson.relatedTermIds.map(
                (id) => ActionChip(
                  label: Text('용어 $id'),
                  onPressed: () => context.go('/glossary?id=$id'),
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

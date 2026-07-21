import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/storage/study_progress_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../data/catalog.dart';
import '../../data/subjects/subjects_data.dart';
import '../../models/content_meta.dart';
import '../../models/learning_models.dart';
import '../../shared/widgets/common_widgets.dart';

class QuestionBankPage extends StatefulWidget {
  const QuestionBankPage({super.key, this.initialId});

  final String? initialId;

  @override
  State<QuestionBankPage> createState() => _QuestionBankPageState();
}

class _QuestionBankPageState extends State<QuestionBankPage> {
  String? subjectFilter;
  Difficulty? difficultyFilter;
  Question? current;
  int? selected;
  bool submitted = false;
  final _sw = Stopwatch();

  @override
  void initState() {
    super.initState();
    if (widget.initialId != null) {
      current = Catalog.questionById(widget.initialId!);
      _sw.start();
    }
  }

  List<Question> get filtered {
    return Catalog.questions.where((q) {
      if (subjectFilter != null && q.subjectId != subjectFilter) return false;
      if (difficultyFilter != null && q.difficulty != difficultyFilter) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<StudyProgressController>();
    if (current != null) {
      return _quizView(p, current!);
    }
    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionTitle('필기 기출유형 문제'),
          Text(
            '자체 작성 연습문제 ${Catalog.questionCount}문항 '
            '(특정 기출 원문 복제 아님)',
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                label: const Text('전체 과목'),
                selected: subjectFilter == null,
                onSelected: (_) => setState(() => subjectFilter = null),
              ),
              ...SubjectsData.all.map(
                (s) => FilterChip(
                  label: Text(s.shortName),
                  selected: subjectFilter == s.id,
                  onSelected: (_) => setState(() => subjectFilter = s.id),
                ),
              ),
              ...Difficulty.values.map(
                (d) => FilterChip(
                  label: Text('난이도 ${d.label}'),
                  selected: difficultyFilter == d,
                  onSelected: (v) =>
                      setState(() => difficultyFilter = v ? d : null),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...filtered.map(
            (q) => Card(
              child: ListTile(
                title: Text(
                  q.stem,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${SubjectsData.byId(q.subjectId)?.shortName ?? ''} · '
                  '${q.chapter} · ${q.difficulty.label}'
                  '${q.needsReview ? ' · 검토필요' : ''}',
                ),
                trailing: const Icon(Icons.play_arrow),
                onTap: () => setState(() {
                  current = q;
                  selected = null;
                  submitted = false;
                  _sw
                    ..reset()
                    ..start();
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quizView(StudyProgressController p, Question q) {
    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () => setState(() => current = null),
                child: const Text('목록'),
              ),
              const Spacer(),
              if (q.needsReview)
                const StatusBadge(label: '검토 필요', needsReview: true),
            ],
          ),
          Text(q.stem, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...List.generate(q.choices.length, (i) {
            final isSel = selected == i;
            Color? border;
            IconData? icon;
            String? status;
            if (submitted) {
              if (i == q.answerIndex) {
                border = AppColors.success;
                icon = Icons.check_circle;
                status = '정답';
              } else if (isSel) {
                border = AppColors.danger;
                icon = Icons.cancel;
                status = '오답';
              }
            }
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: border ?? AppColors.border,
                  width: border == null ? 1 : 2,
                ),
              ),
              child: ListTile(
                leading: icon != null
                    ? Icon(icon, color: border)
                    : CircleAvatar(child: Text('${i + 1}')),
                title: Text(q.choices[i]),
                subtitle: status == null ? null : Text(status),
                selected: isSel && !submitted,
                onTap: submitted ? null : () => setState(() => selected = i),
              ),
            );
          }),
          const SizedBox(height: 12),
          if (!submitted)
            FilledButton(
              onPressed: selected == null
                  ? null
                  : () async {
                      _sw.stop();
                      await p.recordAnswer(
                        question: q,
                        selectedIndex: selected!,
                        elapsedSeconds: _sw.elapsed.inSeconds,
                      );
                      setState(() => submitted = true);
                    },
              child: const Text('정답 제출'),
            )
          else ...[
            InfoCallout(
              text: q.isCorrect(selected!)
                  ? '정답입니다. 해설을 확인하세요.'
                  : '오답입니다. 오답노트에 저장되었습니다.',
              color: q.isCorrect(selected!)
                  ? AppColors.success
                  : AppColors.danger,
              icon: q.isCorrect(selected!)
                  ? Icons.check_circle_outline
                  : Icons.highlight_off,
            ),
            const SectionTitle('해설'),
            Text(q.explanation),
            if (q.calculationSteps.isNotEmpty) ...[
              const SectionTitle('계산 과정'),
              ...q.calculationSteps.map((s) => Text('· $s')),
            ],
            if (q.wrongReasons.isNotEmpty) ...[
              const SectionTitle('오답이 되는 이유'),
              ...q.wrongReasons.map((s) => Text('· $s')),
            ],
            Wrap(
              spacing: 8,
              children: [
                ...q.relatedFormulaIds.map(
                  (id) => ActionChip(
                    label: const Text('관련 공식'),
                    onPressed: () => context.go('/formulas?focus=$id'),
                  ),
                ),
                ...q.relatedLessonIds.map(
                  (id) => ActionChip(
                    label: const Text('관련 강의'),
                    onPressed: () => context.go('/lesson/$id'),
                  ),
                ),
                ActionChip(
                  label: Text(p.bookmarks.contains(q.id) ? '북마크됨' : '즐겨찾기'),
                  onPressed: () => p.toggleBookmark(q.id),
                ),
                ActionChip(
                  label: const Text('다시 풀기'),
                  onPressed: () => setState(() {
                    selected = null;
                    submitted = false;
                    _sw
                      ..reset()
                      ..start();
                  }),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

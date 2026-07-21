import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/storage/study_progress_controller.dart';
import '../../core/storage/study_storage.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/study_metrics.dart';
import '../../data/catalog.dart';
import '../../data/subjects/subjects_data.dart';
import '../../models/learning_models.dart';
import '../../shared/widgets/common_widgets.dart';

class MockExamPage extends StatefulWidget {
  const MockExamPage({super.key});

  @override
  State<MockExamPage> createState() => _MockExamPageState();
}

class _MockExamPageState extends State<MockExamPage> {
  String mode = 'full';
  int questionCount = 10;
  List<Question> paper = [];
  Map<String, int> answers = {};
  int index = 0;
  Timer? timer;
  int remainSec = 0;
  bool started = false;
  MockExamResult? lastResult;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _start(StudyProgressController p) {
    final qs = <Question>[];
    if (mode == 'subject') {
      qs.addAll(Catalog.questions.take(questionCount));
    } else if (mode == 'weak') {
      final weak = p.weakSubjects();
      final pool = Catalog.questions
          .where((q) => weak.contains(q.subjectId) || weak.isEmpty)
          .toList();
      qs.addAll(pool.take(questionCount));
    } else {
      for (final s in SubjectsData.all) {
        qs.addAll(Catalog.questionsBySubject(s.id).take(2));
      }
      while (qs.length < questionCount &&
          qs.length < Catalog.questions.length) {
        for (final q in Catalog.questions) {
          if (!qs.contains(q)) qs.add(q);
          if (qs.length >= questionCount) break;
        }
      }
    }
    final limited = qs.take(questionCount).toList();
    setState(() {
      paper = limited;
      answers = {};
      index = 0;
      started = true;
      lastResult = null;
      remainSec =
          (limited.length *
                  (AppConstants.writtenMinutesPerSubject /
                      AppConstants.writtenQuestionsPerSubject) *
                  60)
              .round()
              .clamp(60, AppConstants.writtenTotalMinutes * 60);
    });
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainSec <= 0) {
        _submit(p);
      } else {
        setState(() => remainSec--);
      }
    });
  }

  Future<void> _submit(StudyProgressController p) async {
    timer?.cancel();
    final unanswered = paper.where((q) => !answers.containsKey(q.id)).length;
    if (unanswered > 0 && mounted) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('미응답 확인'),
          content: Text('미응답 $unanswered문항이 있습니다. 제출할까요?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('계속 풀기'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('제출'),
            ),
          ],
        ),
      );
      if (ok != true) {
        timer = Timer.periodic(const Duration(seconds: 1), (_) {
          if (remainSec <= 0) {
            _submit(p);
          } else {
            setState(() => remainSec--);
          }
        });
        return;
      }
    }

    final subjectScores = <String, double>{};
    final weakChapters = <String>[];
    var correct = 0;
    for (final s in SubjectsData.all) {
      final subQs = paper.where((q) => q.subjectId == s.id).toList();
      if (subQs.isEmpty) continue;
      var c = 0;
      for (final q in subQs) {
        final a = answers[q.id];
        if (a != null && q.isCorrect(a)) {
          c++;
          correct++;
        } else if (a != null) {
          weakChapters.add(q.chapter);
          await p.recordAnswer(
            question: q,
            selectedIndex: a,
            elapsedSeconds: 30,
          );
        }
      }
      subjectScores[s.id] = (c / subQs.length) * 100;
    }
    // count corrects for subjects not in loop already counted... fix: recount
    correct = 0;
    for (final q in paper) {
      final a = answers[q.id];
      if (a != null && q.isCorrect(a)) correct++;
    }

    final judgement = StudyMetrics.judgeWritten(subjectScores);
    final elapsed =
        (paper.length *
                (AppConstants.writtenMinutesPerSubject /
                    AppConstants.writtenQuestionsPerSubject) *
                60)
            .round() -
        remainSec;
    final result = MockExamResult(
      id: const Uuid().v4(),
      takenAt: DateTime.now().toIso8601String(),
      mode: mode,
      subjectScores: subjectScores,
      average: judgement.average,
      hasFailSubject: judgement.hasFailSubject,
      correctRate: paper.isEmpty ? 0 : correct / paper.length,
      elapsedSeconds: elapsed.clamp(0, 99999),
      weakChapters: weakChapters.toSet().toList(),
    );
    await p.addMockResult(result);
    setState(() {
      started = false;
      lastResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<StudyProgressController>();
    if (started && paper.isNotEmpty) {
      final q = paper[index];
      return PageFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  '남은 시간 ${(remainSec ~/ 60).toString().padLeft(2, '0')}:${(remainSec % 60).toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.danger,
                  ),
                ),
                const Spacer(),
                Text('${index + 1}/${paper.length}'),
              ],
            ),
            const SizedBox(height: 12),
            Text(q.stem, style: Theme.of(context).textTheme.titleLarge),
            ...List.generate(
              q.choices.length,
              (i) => RadioListTile<int>(
                value: i,
                groupValue: answers[q.id],
                title: Text(q.choices[i]),
                onChanged: (v) => setState(() => answers[q.id] = v!),
              ),
            ),
            Row(
              children: [
                OutlinedButton(
                  onPressed: index == 0 ? null : () => setState(() => index--),
                  child: const Text('이전'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: index >= paper.length - 1
                      ? null
                      : () => setState(() => index++),
                  child: const Text('다음'),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () => _submit(p),
                  child: const Text('최종 제출'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 4,
              children: List.generate(
                paper.length,
                (i) => ActionChip(
                  label: Text('${i + 1}'),
                  backgroundColor: answers.containsKey(paper[i].id)
                      ? AppColors.teal.withValues(alpha: 0.2)
                      : null,
                  onPressed: () => setState(() => index = i),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionTitle('필기 모의고사'),
          const Text(
            '실제 시험: 과목당 20문항·30분, 과목 40점 이상·평균 60점 이상 '
            '(Q-Net 기준, 변경 가능).',
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('전체 모의'),
                selected: mode == 'full',
                onSelected: (_) => setState(() => mode = 'full'),
              ),
              ChoiceChip(
                label: const Text('과목 혼합'),
                selected: mode == 'subject',
                onSelected: (_) => setState(() => mode = 'subject'),
              ),
              ChoiceChip(
                label: const Text('취약 집중'),
                selected: mode == 'weak',
                onSelected: (_) => setState(() => mode = 'weak'),
              ),
            ],
          ),
          Row(
            children: [
              const Text('문항 수'),
              Expanded(
                child: Slider(
                  value: questionCount.toDouble(),
                  min: 5,
                  max: Catalog.questionCount.toDouble().clamp(5, 50),
                  divisions: (Catalog.questionCount - 5).clamp(1, 45),
                  label: '$questionCount',
                  onChanged: (v) => setState(() => questionCount = v.round()),
                ),
              ),
              Text('$questionCount'),
            ],
          ),
          FilledButton(onPressed: () => _start(p), child: const Text('시험 시작')),
          if (lastResult != null) ...[
            const SectionTitle('직전 결과'),
            Text(
              '평균 ${lastResult!.average.toStringAsFixed(1)}점 · '
              '정답률 ${(lastResult!.correctRate * 100).toStringAsFixed(0)}% · '
              '${lastResult!.hasFailSubject ? '과락 있음' : '과락 없음'}',
            ),
            ...lastResult!.subjectScores.entries.map((e) {
              final name = SubjectsData.byId(e.key)?.shortName ?? e.key;
              return Text('$name: ${e.value.toStringAsFixed(0)}점');
            }),
          ],
          if (p.mockResults.isNotEmpty) ...[
            const SectionTitle('회차별 점수 변화'),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        for (var i = 0; i < p.mockResults.length && i < 10; i++)
                          FlSpot(
                            i.toDouble(),
                            p.mockResults.reversed.toList()[i].average,
                          ),
                      ],
                      color: AppColors.blue,
                      barWidth: 3,
                    ),
                  ],
                  minY: 0,
                  maxY: 100,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

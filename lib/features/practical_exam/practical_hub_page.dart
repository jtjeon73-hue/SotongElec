import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/storage/study_progress_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../data/catalog.dart';
import '../../models/learning_models.dart';
import '../../shared/widgets/common_widgets.dart';

class PracticalHubPage extends StatelessWidget {
  const PracticalHubPage({super.key, this.category});

  final String? category;

  @override
  Widget build(BuildContext context) {
    final items = Catalog.practicalItems
        .where((p) => category == null || p.category == category)
        .toList();
    final cats = Catalog.practicalItems.map((e) => e.category).toSet().toList();

    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionTitle('실기 전체 학습'),
          Text('등록 실기 항목 ${Catalog.practicalCount}개'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ActionChip(
                label: const Text('전체'),
                onPressed: () => context.go('/practical'),
              ),
              ...cats.map(
                (c) => ActionChip(
                  label: Text(c),
                  onPressed: () => context.go(
                    '/practical?cat=${Uri.encodeQueryComponent(c)}',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map(
            (p) => Card(
              color: const Color(0xFFFFF7ED),
              child: ListTile(
                title: Text(p.title),
                subtitle: Text(p.category),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('/practical/item/${p.id}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PracticalItemPage extends StatefulWidget {
  const PracticalItemPage({super.key, required this.id});

  final String id;

  @override
  State<PracticalItemPage> createState() => _PracticalItemPageState();
}

class _PracticalItemPageState extends State<PracticalItemPage> {
  final answer = TextEditingController();
  bool showHint = false;
  bool showModel = false;
  KeywordCheckResult? check;

  @override
  void dispose() {
    answer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = Catalog.practicalById(widget.id);
    if (item == null) {
      return const PageFrame(child: Text('항목 없음'));
    }
    final p = context.watch<StudyProgressController>();
    final key = 'prac_${item.id}';
    final done = p.completedLessons.contains(key);

    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionTitle(item.title),
          Text(
            item.category,
            style: const TextStyle(color: AppColors.practicalAccent),
          ),
          const SectionTitle('문제 · 요구사항'),
          Text(item.prompt),
          ...item.requirements.map((r) => Text('· $r')),
          const SectionTitle('내 답안'),
          TextField(
            controller: answer,
            maxLines: 6,
            decoration: const InputDecoration(hintText: '답안을 입력하세요'),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton(
                onPressed: () => setState(() => showHint = true),
                child: const Text('단계별 힌트'),
              ),
              FilledButton(
                onPressed: () => setState(() {
                  check = item.selfCheck(answer.text);
                  showModel = true;
                }),
                child: const Text('키워드 자체점검'),
              ),
              OutlinedButton(
                onPressed: () => p.toggleLessonComplete(key),
                child: Text(done ? '완료됨' : '학습 완료'),
              ),
            ],
          ),
          if (showHint) ...[
            const SectionTitle('힌트'),
            ...item.hints.map((h) => Text('· $h')),
            ...item.solutionOrder.asMap().entries.map(
              (e) => Text('${e.key + 1}. ${e.value}'),
            ),
          ],
          if (check != null) ...[
            const SectionTitle('자체점검 결과'),
            const InfoCallout(
              text: '필수 키워드 포함 여부 점검입니다. 실제 공식 채점을 대신하지 않습니다.',
              color: AppColors.warning,
            ),
            Text('포함률 ${(check!.coverage * 100).toStringAsFixed(0)}%'),
            Text('포함: ${check!.found.join(', ')}'),
            Text('미포함: ${check!.missing.join(', ')}'),
          ],
          if (showModel) ...[
            const SectionTitle('모범답안 · 채점 안내'),
            Text(item.modelAnswer),
            Text(item.scoringGuide),
            const SectionTitle('계산식 · 단위 · 감점 요소'),
            ...item.formulas.map((f) => FormulaBox(f)),
            Text('단위: ${item.units.join(', ')}'),
            ...item.deductionRisks.map((d) => Text('· $d')),
            ...item.commonMistakes.map((d) => Text('실수: $d')),
          ],
        ],
      ),
    );
  }
}

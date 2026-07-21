import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/storage/study_progress_controller.dart';
import '../../data/catalog.dart';
import '../../data/subjects/subjects_data.dart';
import '../../models/content_meta.dart';
import '../../shared/widgets/common_widgets.dart';

class FormulasPage extends StatefulWidget {
  const FormulasPage({super.key, this.focusId});

  final String? focusId;

  @override
  State<FormulasPage> createState() => _FormulasPageState();
}

class _FormulasPageState extends State<FormulasPage> {
  String query = '';
  String? subjectId;
  bool mustOnly = false;

  @override
  Widget build(BuildContext context) {
    final p = context.watch<StudyProgressController>();
    final list = Catalog.formulas.where((f) {
      if (subjectId != null && f.subjectId != subjectId) return false;
      if (mustOnly && !f.importance.contains(ImportanceBadge.mustMemorize)) {
        return false;
      }
      if (query.isNotEmpty) {
        final blob = '${f.name} ${f.meaning} ${f.mnemonic}'.toLowerCase();
        if (!blob.contains(query.toLowerCase())) return false;
      }
      return true;
    }).toList();

    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionTitle('공식 암기실'),
          Text('등록 공식 ${Catalog.formulaCount}개'),
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: '공식 검색',
            ),
            onChanged: (v) => setState(() => query = v),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: const Text('전체'),
                selected: subjectId == null,
                onSelected: (_) => setState(() => subjectId = null),
              ),
              ...SubjectsData.all.map(
                (s) => FilterChip(
                  label: Text(s.shortName),
                  selected: subjectId == s.id,
                  onSelected: (_) => setState(() => subjectId = s.id),
                ),
              ),
              FilterChip(
                label: const Text('반드시 암기'),
                selected: mustOnly,
                onSelected: (v) => setState(() => mustOnly = v),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...list.map((f) {
            final focused = widget.focusId == f.id;
            return Card(
              color: focused ? const Color(0xFFECFDF5) : null,
              child: ExpansionTile(
                initiallyExpanded: focused,
                title: Text(f.name),
                subtitle: Text(f.chapter),
                childrenPadding: const EdgeInsets.all(16),
                children: [
                  FormulaBox(f.latex),
                  Text(f.meaning),
                  ImportanceChips(f.importance),
                  Text('조건: ${f.conditions}'),
                  Text('암기: ${f.mnemonic}'),
                  Text('예제: ${f.example}'),
                  if (f.unitTraps.isNotEmpty)
                    Text('단위 실수: ${f.unitTraps.join(', ')}'),
                  Text(f.writtenPracticalLinked ? '필기·실기 연계' : '필기 중심'),
                  TextButton.icon(
                    onPressed: () => p.toggleBookmark(f.id),
                    icon: Icon(
                      p.bookmarks.contains(f.id)
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                    ),
                    label: const Text('즐겨찾기'),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({super.key});

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  int index = 0;
  bool flipped = false;
  final wrong = <int>[];
  bool quizMode = false;

  @override
  Widget build(BuildContext context) {
    final formulas = Catalog.formulas;
    if (formulas.isEmpty) {
      return const PageFrame(child: Text('공식 없음'));
    }
    final f = formulas[index % formulas.length];
    return PageFrame(
      child: Column(
        children: [
          const SectionTitle('암기카드'),
          Row(
            children: [
              FilterChip(
                label: const Text('학습 모드'),
                selected: !quizMode,
                onSelected: (_) => setState(() => quizMode = false),
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('랜덤 퀴즈'),
                selected: quizMode,
                onSelected: (_) => setState(() {
                  quizMode = true;
                  flipped = false;
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => setState(() => flipped = !flipped),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 220),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: flipped
                      ? const [Color(0xFF0D9488), Color(0xFF134E4A)]
                      : const [Color(0xFF1E3A5F), Color(0xFF0B1F3A)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: flipped
                  ? Column(
                      children: [
                        FormulaBox(f.latex),
                        Text(
                          f.meaning,
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : Center(
                      child: Text(
                        f.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          const Text('카드를 눌러 앞/뒤를 전환'),
          const SizedBox(height: 16),
          Row(
            children: [
              OutlinedButton(
                onPressed: () => setState(() {
                  wrong.add(index);
                  flipped = false;
                  index = (index + 1) % formulas.length;
                }),
                child: const Text('틀림 · 다음'),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => setState(() {
                  flipped = false;
                  index = (index + 1) % formulas.length;
                }),
                child: const Text('알았음 · 다음'),
              ),
            ],
          ),
          if (wrong.isNotEmpty)
            TextButton(
              onPressed: () => setState(() {
                index = wrong.removeLast();
                flipped = false;
              }),
              child: Text('틀린 공식 반복 (${wrong.length})'),
            ),
        ],
      ),
    );
  }
}

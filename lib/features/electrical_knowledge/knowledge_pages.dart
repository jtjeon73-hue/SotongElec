import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/catalog.dart';
import '../../models/learning_models.dart';
import '../../shared/widgets/common_widgets.dart';

class KnowledgeListPage extends StatelessWidget {
  const KnowledgeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionTitle('일반 전기상식'),
          Text('${Catalog.knowledgeCount}개 글'),
          ...Catalog.knowledge.map(
            (k) => Card(
              child: ListTile(
                title: Text(k.title),
                subtitle: Text(k.overview),
                onTap: () => context.go('/knowledge/${k.id}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class KnowledgeDetailPage extends StatelessWidget {
  const KnowledgeDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    KnowledgeArticle? article;
    for (final e in Catalog.knowledge) {
      if (e.id == id) article = e;
    }
    if (article == null) {
      return const PageFrame(child: Text('글 없음'));
    }
    final a = article;
    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionTitle(a.title),
          const SectionTitle('한눈에 보기'),
          Text(a.overview),
          const SectionTitle('쉬운 설명'),
          Text(a.easyExplain),
          const SectionTitle('핵심 원리'),
          Text(a.principle),
          const SectionTitle('현장 사례'),
          Text(a.fieldCase),
          const SectionTitle('주의사항'),
          ...a.cautions.map((c) => Text('· $c')),
          const SectionTitle('관련 자격증 내용'),
          Text(a.certLink),
          Wrap(
            spacing: 8,
            children: [
              ...a.relatedLessonIds.map(
                (lid) => ActionChip(
                  label: const Text('관련 강의'),
                  onPressed: () => context.go('/lesson/$lid'),
                ),
              ),
              ...a.relatedQuestionIds.map(
                (qid) => ActionChip(
                  label: const Text('관련 문제'),
                  onPressed: () => context.go('/questions?id=$qid'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

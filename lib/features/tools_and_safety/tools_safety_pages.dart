import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../data/catalog.dart';
import '../../models/learning_models.dart';
import '../../shared/widgets/common_widgets.dart';

class ToolsListPage extends StatelessWidget {
  const ToolsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionTitle('전기인의 도구'),
          Text('${Catalog.toolCount}개'),
          ...Catalog.tools.map(
            (t) => Card(
              child: ListTile(
                title: Text(t.name),
                subtitle: Text(t.purpose),
                onTap: () => context.go('/tools/${t.id}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ToolDetailPage extends StatelessWidget {
  const ToolDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    ToolItem? tool;
    for (final t in Catalog.tools) {
      if (t.id == id) tool = t;
    }
    if (tool == null) {
      return const PageFrame(child: Text('도구 없음'));
    }
    final t = tool;
    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionTitle(t.name),
          Text('용도: ${t.purpose}'),
          const SectionTitle('기본 사용법'),
          Text(t.howToUse),
          const SectionTitle('사용 전 점검'),
          ...t.preCheck.map((e) => Text('· $e')),
          const SectionTitle('잘못된 사용'),
          ...t.misuse.map((e) => Text('· $e')),
          const SectionTitle('안전수칙'),
          ...t.safety.map((e) => Text('· $e')),
          Text('관련 측정값: ${t.relatedValues}'),
          const SectionTitle('선택 시 확인'),
          ...t.selectionTips.map((e) => Text('· $e')),
          Text('보관: ${t.storage}'),
          const InfoCallout(
            text: '실제 작업은 법령·매뉴얼·현장 책임자 지시를 우선합니다.',
            color: AppColors.warning,
          ),
        ],
      ),
    );
  }
}

class SafetyPage extends StatelessWidget {
  const SafetyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionTitle('현장 안전·사고 예방'),
          const InfoCallout(
            text:
                '안전 콘텐츠는 생명과 직결됩니다. 근거 없이 작업 방법을 단정하지 않으며, '
                '법령·공식 안전기준·제조사 매뉴얼·현장 책임자 지시가 우선입니다.',
            color: AppColors.danger,
            icon: Icons.health_and_safety,
          ),
          ...Catalog.safety.map(
            (s) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(s.body),
                    const SizedBox(height: 8),
                    StatusBadge(label: s.priorityNote, needsReview: true),
                    const SizedBox(height: 8),
                    Text('참고: ${s.sources.join(' · ')}'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

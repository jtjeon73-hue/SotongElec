import 'package:flutter/material.dart';

import '../../data/catalog.dart';
import '../../models/learning_models.dart';
import '../../shared/widgets/common_widgets.dart';

class GlossaryPage extends StatefulWidget {
  const GlossaryPage({super.key, this.initialId});

  final String? initialId;

  @override
  State<GlossaryPage> createState() => _GlossaryPageState();
}

class _GlossaryPageState extends State<GlossaryPage> {
  String query = '';
  GlossaryTerm? selected;

  @override
  void initState() {
    super.initState();
    if (widget.initialId != null) {
      for (final g in Catalog.glossary) {
        if (g.id == widget.initialId) selected = g;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = Catalog.glossary.where((g) {
      if (query.isEmpty) return true;
      final q = query.toLowerCase();
      return g.korean.contains(query) ||
          g.english.toLowerCase().contains(q) ||
          g.simple.contains(query);
    }).toList()..sort((a, b) => a.korean.compareTo(b.korean));

    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionTitle('전기 용어사전'),
          Text('${Catalog.termCount}개 용어 · 가나다순'),
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: '한글·영문 검색',
            ),
            onChanged: (v) => setState(() => query = v),
          ),
          const SizedBox(height: 12),
          if (selected != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${selected!.korean} (${selected!.english})',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (selected!.symbol != null)
                      Text('기호: ${selected!.symbol}'),
                    if (selected!.unit != null) Text('단위: ${selected!.unit}'),
                    Text('쉬운 설명: ${selected!.simple}'),
                    Text('전문 설명: ${selected!.technical}'),
                    if (selected!.confusable.isNotEmpty)
                      Text('혼동 주의: ${selected!.confusable.join(', ')}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          ...list.map(
            (g) => ListTile(
              title: Text(g.korean),
              subtitle: Text(g.english),
              selected: selected?.id == g.id,
              onTap: () => setState(() => selected = g),
            ),
          ),
        ],
      ),
    );
  }
}

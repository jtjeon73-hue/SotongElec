import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/catalog.dart';
import '../../shared/widgets/common_widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, this.initialQuery = ''});

  final String initialQuery;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _controller;
  List<SearchHit> hits = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
    if (widget.initialQuery.isNotEmpty) {
      hits = SearchService.search(widget.initialQuery);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionTitle('전체 검색'),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: '강의·공식·문제·실기·상식·도구·용어·계산기',
            ),
            onSubmitted: (v) => setState(() => hits = SearchService.search(v)),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () =>
                setState(() => hits = SearchService.search(_controller.text)),
            child: const Text('검색'),
          ),
          Text('${hits.length}건'),
          ...hits.map(
            (h) => Card(
              child: ListTile(
                leading: Chip(label: Text(h.type)),
                title: Text(h.title),
                subtitle: Text(
                  [
                    h.subtitle,
                    if (h.importance != null) h.importance!,
                  ].join(' · '),
                ),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () => context.go(h.route),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

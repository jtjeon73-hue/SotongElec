import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import 'brand_logo.dart';

class NavItem {
  const NavItem({
    required this.label,
    required this.path,
    required this.icon,
    this.group,
  });

  final String label;
  final String path;
  final IconData icon;
  final String? group;
}

class AppNav {
  static const items = <NavItem>[
    NavItem(label: '01. 홈·합격 대시보드', path: '/', icon: Icons.dashboard_outlined),
    NavItem(
      label: '02. 전기기사 시험 안내',
      path: '/exam-guide',
      icon: Icons.info_outline,
    ),
    NavItem(
      label: '03. 필기 전체 학습',
      path: '/written',
      icon: Icons.menu_book_outlined,
    ),
    NavItem(
      label: '04. 전기자기학',
      path: '/written/electromagnetics',
      icon: Icons.bolt_outlined,
    ),
    NavItem(
      label: '05. 전력공학',
      path: '/written/power_engineering',
      icon: Icons.electrical_services,
    ),
    NavItem(
      label: '06. 전기기기',
      path: '/written/electrical_machines',
      icon: Icons.settings_suggest_outlined,
    ),
    NavItem(
      label: '07. 회로이론 및 제어공학',
      path: '/written/circuit_control',
      icon: Icons.schema_outlined,
    ),
    NavItem(
      label: '08. 전기설비기술기준',
      path: '/written/facility_standards',
      icon: Icons.gavel_outlined,
    ),
    NavItem(
      label: '09. 필기 기출유형 문제',
      path: '/questions',
      icon: Icons.quiz_outlined,
    ),
    NavItem(label: '10. 필기 모의고사', path: '/mock', icon: Icons.timer_outlined),
    NavItem(
      label: '11. 실기 전체 학습',
      path: '/practical',
      icon: Icons.handyman_outlined,
    ),
    NavItem(
      label: '12. 단답형 핵심정리',
      path: '/practical?cat=단답형 핵심정리',
      icon: Icons.short_text,
    ),
    NavItem(
      label: '13. 계산형 문제',
      path: '/practical?cat=계산형 문제',
      icon: Icons.calculate_outlined,
    ),
    NavItem(
      label: '14. 도면·시퀀스',
      path: '/practical?cat=도면·시퀀스',
      icon: Icons.account_tree_outlined,
    ),
    NavItem(
      label: '15. 설계·감리·견적',
      path: '/practical?cat=설계·감리·견적',
      icon: Icons.architecture,
    ),
    NavItem(
      label: '16. 실기 기출유형 문제',
      path: '/practical',
      icon: Icons.assignment_outlined,
    ),
    NavItem(label: '17. 공식 암기실', path: '/formulas', icon: Icons.functions),
    NavItem(
      label: '18. 공학용 계산기 사용법',
      path: '/calc-guide',
      icon: Icons.keyboard_outlined,
    ),
    NavItem(
      label: '19. 전기 계산 도구',
      path: '/calculators',
      icon: Icons.science_outlined,
    ),
    NavItem(
      label: '20. 오답노트',
      path: '/wrong',
      icon: Icons.report_gmailerrorred_outlined,
    ),
    NavItem(label: '21. 암기카드', path: '/flashcards', icon: Icons.style_outlined),
    NavItem(
      label: '22. 학습계획·진도',
      path: '/plan',
      icon: Icons.calendar_month_outlined,
    ),
    NavItem(
      label: '23. 일반 전기상식',
      path: '/knowledge',
      icon: Icons.lightbulb_outline,
    ),
    NavItem(label: '24. 전기인의 도구', path: '/tools', icon: Icons.build_outlined),
    NavItem(
      label: '25. 현장 안전·사고 예방',
      path: '/safety',
      icon: Icons.health_and_safety_outlined,
    ),
    NavItem(label: '26. 전기 용어사전', path: '/glossary', icon: Icons.menu_book),
    NavItem(label: '27. 전체 검색', path: '/search', icon: Icons.search),
    NavItem(
      label: '28. 자료 출처·업데이트',
      path: '/sources',
      icon: Icons.source_outlined,
    ),
  ];
}

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final location = GoRouterState.of(context).uri.toString();
    final isMobile = width < 800;
    final isTablet = width >= 800 && width < 1100;

    if (isMobile) {
      return Scaffold(
        appBar: AppBar(
          title: const BrandLogo(
            compact: false,
            onDark: true,
            symbolSize: 32,
            showSubtitle: true,
          ),
          actions: [
            IconButton(
              tooltip: '검색',
              onPressed: () => context.go('/search'),
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        drawer: Drawer(
          child: SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: BrandLogo(onDark: false, symbolSize: 40),
                ),
                const Divider(),
                Expanded(child: _NavList(location: location)),
              ],
            ),
          ),
        ),
        body: child,
        bottomNavigationBar: NavigationBar(
          selectedIndex: _mobileIndex(location),
          onDestinationSelected: (i) {
            final paths = [
              '/',
              '/written',
              '/questions',
              '/practical',
              '/search',
            ];
            context.go(paths[i]);
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), label: '홈'),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              label: '필기',
            ),
            NavigationDestination(icon: Icon(Icons.quiz_outlined), label: '문제'),
            NavigationDestination(
              icon: Icon(Icons.handyman_outlined),
              label: '실기',
            ),
            NavigationDestination(icon: Icon(Icons.search), label: '검색'),
          ],
        ),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          _SideNav(location: location, collapsed: isTablet),
          Expanded(
            child: Column(
              children: [
                Material(
                  color: Colors.white,
                  elevation: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: AppColors.border),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _titleFor(location),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        SizedBox(
                          width: 280,
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: '강의·공식·문제 검색',
                              prefixIcon: Icon(Icons.search),
                              isDense: true,
                            ),
                            onSubmitted: (v) => context.go(
                              '/search?q=${Uri.encodeComponent(v)}',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          tooltip: '설정',
                          onPressed: () => context.go('/plan'),
                          icon: const Icon(Icons.tune),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppConstants.contentMaxWidth,
                      ),
                      child: child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static int _mobileIndex(String location) {
    if (location.startsWith('/search')) return 4;
    if (location.startsWith('/practical')) return 3;
    if (location.startsWith('/questions') || location.startsWith('/mock')) {
      return 2;
    }
    if (location.startsWith('/written') || location.startsWith('/lesson')) {
      return 1;
    }
    return 0;
  }

  static String _titleFor(String location) {
    for (final item in AppNav.items) {
      if (item.path == location ||
          location.startsWith(item.path.split('?').first) && item.path != '/') {
        if (item.path == '/') continue;
        return item.label;
      }
    }
    if (location == '/' || location.isEmpty) return '홈·합격 대시보드';
    return AppConstants.appSubtitle;
  }
}

class _SideNav extends StatelessWidget {
  const _SideNav({required this.location, required this.collapsed});

  final String location;
  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: collapsed
          ? AppConstants.sidebarCollapsedWidth
          : AppConstants.sidebarWidth,
      color: AppColors.deepNavy,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(collapsed ? 12 : 20),
              child: collapsed
                  ? const Center(
                      child: BrandLogo(compact: true, symbolSize: 36),
                    )
                  : const BrandLogo(symbolSize: 44, onDark: true),
            ),
            Expanded(
              child: _NavList(location: location, collapsed: collapsed),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavList extends StatelessWidget {
  const _NavList({required this.location, this.collapsed = false});

  final String location;
  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: AppNav.items.length,
      itemBuilder: (context, index) {
        final item = AppNav.items[index];
        final selected = _isSelected(location, item.path);
        return Tooltip(
          message: item.label,
          child: ListTile(
            selected: selected,
            selectedTileColor: Colors.white.withValues(alpha: 0.12),
            leading: Icon(
              item.icon,
              color: selected ? AppColors.tealLight : const Color(0xFF94A3B8),
            ),
            title: collapsed
                ? null
                : Text(
                    item.label,
                    style: TextStyle(
                      color: selected ? Colors.white : const Color(0xFFCBD5E1),
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
            dense: true,
            onTap: () {
              Navigator.of(context).maybePop();
              context.go(item.path);
            },
          ),
        );
      },
    );
  }

  bool _isSelected(String location, String path) {
    final base = path.split('?').first;
    if (base == '/') return location == '/' || location.isEmpty;
    return location == path ||
        location.startsWith('$base/') ||
        location.startsWith(base);
  }
}

import 'package:go_router/go_router.dart';

import '../../shared/widgets/app_shell.dart';
import '../../features/home/home_page.dart';
import '../../features/exam_guide/exam_guide_page.dart';
import '../../features/written_exam/written_hub_page.dart';
import '../../features/written_exam/subject_page.dart';
import '../../features/written_exam/lesson_page.dart';
import '../../features/question_bank/question_bank_page.dart';
import '../../features/mock_exam/mock_exam_page.dart';
import '../../features/practical_exam/practical_hub_page.dart';
import '../../features/practical_exam/practical_item_page.dart';
import '../../features/formulas/formulas_page.dart';
import '../../features/calculators/calc_guide_page.dart';
import '../../features/calculators/calculators_hub_page.dart';
import '../../features/calculators/calculator_page.dart';
import '../../features/wrong_answers/wrong_answers_page.dart';
import '../../features/electrical_knowledge/knowledge_pages.dart';
import '../../features/tools_and_safety/tools_safety_pages.dart';
import '../../features/glossary/glossary_page.dart';
import '../../features/search/search_page.dart';
import '../../features/sources/sources_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomePage()),
          GoRoute(
            path: '/exam-guide',
            builder: (context, state) => const ExamGuidePage(),
          ),
          GoRoute(
            path: '/written',
            builder: (context, state) => const WrittenHubPage(),
          ),
          GoRoute(
            path: '/written/:subjectId',
            builder: (context, state) => SubjectPage(
              subjectId: state.pathParameters['subjectId']!,
            ),
          ),
          GoRoute(
            path: '/lesson/:id',
            builder: (context, state) =>
                LessonPage(lessonId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/questions',
            builder: (context, state) => QuestionBankPage(
              initialId: state.uri.queryParameters['id'],
            ),
          ),
          GoRoute(
            path: '/mock',
            builder: (context, state) => const MockExamPage(),
          ),
          GoRoute(
            path: '/practical',
            builder: (context, state) => PracticalHubPage(
              category: state.uri.queryParameters['cat'],
            ),
          ),
          GoRoute(
            path: '/practical/item/:id',
            builder: (context, state) => PracticalItemPage(
              id: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/formulas',
            builder: (context, state) => FormulasPage(
              focusId: state.uri.queryParameters['focus'],
            ),
          ),
          GoRoute(
            path: '/calc-guide',
            builder: (context, state) => const CalcGuidePage(),
          ),
          GoRoute(
            path: '/calculators',
            builder: (context, state) => const CalculatorsHubPage(),
          ),
          GoRoute(
            path: '/calculators/:id',
            builder: (context, state) =>
                CalculatorPage(id: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/wrong',
            builder: (context, state) => const WrongAnswersPage(),
          ),
          GoRoute(
            path: '/flashcards',
            builder: (context, state) => const FlashcardsPage(),
          ),
          GoRoute(
            path: '/plan',
            builder: (context, state) => const StudyPlanPage(),
          ),
          GoRoute(
            path: '/knowledge',
            builder: (context, state) => const KnowledgeListPage(),
          ),
          GoRoute(
            path: '/knowledge/:id',
            builder: (context, state) =>
                KnowledgeDetailPage(id: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/tools',
            builder: (context, state) => const ToolsListPage(),
          ),
          GoRoute(
            path: '/tools/:id',
            builder: (context, state) =>
                ToolDetailPage(id: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/safety',
            builder: (context, state) => const SafetyPage(),
          ),
          GoRoute(
            path: '/glossary',
            builder: (context, state) => GlossaryPage(
              initialId: state.uri.queryParameters['id'],
            ),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => SearchPage(
              initialQuery: state.uri.queryParameters['q'] ?? '',
            ),
          ),
          GoRoute(
            path: '/sources',
            builder: (context, state) => const SourcesPage(),
          ),
        ],
      ),
    ],
  );
}

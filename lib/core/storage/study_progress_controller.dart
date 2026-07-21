import 'package:flutter/foundation.dart';

import '../storage/study_storage.dart';
import '../../models/learning_models.dart';
import '../../data/catalog.dart';
import '../utils/study_metrics.dart';
import '../constants/app_constants.dart';

class StudyProgressController extends ChangeNotifier {
  StudyProgressController(this._storage);

  final StudyStorage _storage;

  final Set<String> completedLessons = {};
  final Set<String> bookmarks = {};
  final Map<String, String> notes = {};
  final Map<String, int> attemptCounts = {};
  final Map<String, int> correctCounts = {};
  final List<WrongAnswerRecord> wrongAnswers = [];
  final List<MockExamResult> mockResults = [];
  final List<String> recentLessonIds = [];
  final Map<String, int> studyMinutesByDay = {};
  DateTime? examDate;
  bool darkMode = false;
  int dailyGoalMinutes = 90;
  String focusTrack = 'written'; // written | practical | both

  bool _ready = false;
  bool get ready => _ready;

  Future<void> init() async {
    await _storage.init();
    final data = await _storage.loadAll();
    completedLessons
      ..clear()
      ..addAll(
        ((data['completedLessons'] as List<dynamic>?) ?? const []).map(
          (e) => e.toString(),
        ),
      );
    bookmarks
      ..clear()
      ..addAll(
        ((data['bookmarks'] as List<dynamic>?) ?? const []).map(
          (e) => e.toString(),
        ),
      );
    notes
      ..clear()
      ..addAll(
        Map<String, String>.from(
          (data['notes'] as Map?)?.map(
                (k, v) => MapEntry(k.toString(), v.toString()),
              ) ??
              {},
        ),
      );
    attemptCounts
      ..clear()
      ..addAll(
        Map<String, int>.from(
          (data['attemptCounts'] as Map?)?.map(
                (k, v) => MapEntry(k.toString(), (v as num).toInt()),
              ) ??
              {},
        ),
      );
    correctCounts
      ..clear()
      ..addAll(
        Map<String, int>.from(
          (data['correctCounts'] as Map?)?.map(
                (k, v) => MapEntry(k.toString(), (v as num).toInt()),
              ) ??
              {},
        ),
      );
    wrongAnswers
      ..clear()
      ..addAll(
        ((data['wrongAnswers'] as List<dynamic>?) ?? const []).map(
          (e) =>
              WrongAnswerRecord.fromJson(Map<String, dynamic>.from(e as Map)),
        ),
      );
    mockResults
      ..clear()
      ..addAll(
        ((data['mockResults'] as List<dynamic>?) ?? const []).map(
          (e) => MockExamResult.fromJson(Map<String, dynamic>.from(e as Map)),
        ),
      );
    recentLessonIds
      ..clear()
      ..addAll(
        ((data['recentLessonIds'] as List<dynamic>?) ?? const []).map(
          (e) => e.toString(),
        ),
      );
    studyMinutesByDay
      ..clear()
      ..addAll(
        Map<String, int>.from(
          (data['studyMinutesByDay'] as Map?)?.map(
                (k, v) => MapEntry(k.toString(), (v as num).toInt()),
              ) ??
              {},
        ),
      );
    final exam = data['examDate'] as String?;
    examDate = exam == null || exam.isEmpty ? null : DateTime.tryParse(exam);
    darkMode = data['darkMode'] as bool? ?? false;
    dailyGoalMinutes = data['dailyGoalMinutes'] as int? ?? 90;
    focusTrack = data['focusTrack'] as String? ?? 'written';
    _ready = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    await _storage.saveAll({
      'completedLessons': completedLessons.toList(),
      'bookmarks': bookmarks.toList(),
      'notes': notes,
      'attemptCounts': attemptCounts,
      'correctCounts': correctCounts,
      'wrongAnswers': wrongAnswers.map((e) => e.toJson()).toList(),
      'mockResults': mockResults.map((e) => e.toJson()).toList(),
      'recentLessonIds': recentLessonIds,
      'studyMinutesByDay': studyMinutesByDay,
      'examDate': examDate?.toIso8601String(),
      'darkMode': darkMode,
      'dailyGoalMinutes': dailyGoalMinutes,
      'focusTrack': focusTrack,
    });
  }

  Future<void> toggleLessonComplete(String lessonId) async {
    if (completedLessons.contains(lessonId)) {
      completedLessons.remove(lessonId);
    } else {
      completedLessons.add(lessonId);
      _touchLesson(lessonId);
      addStudyMinutes(15);
    }
    await _persist();
    notifyListeners();
  }

  void _touchLesson(String lessonId) {
    recentLessonIds.remove(lessonId);
    recentLessonIds.insert(0, lessonId);
    if (recentLessonIds.length > 20) {
      recentLessonIds.removeRange(20, recentLessonIds.length);
    }
  }

  Future<void> markLessonOpened(String lessonId) async {
    _touchLesson(lessonId);
    await _persist();
    notifyListeners();
  }

  Future<void> toggleBookmark(String id) async {
    if (bookmarks.contains(id)) {
      bookmarks.remove(id);
    } else {
      bookmarks.add(id);
    }
    await _persist();
    notifyListeners();
  }

  Future<void> setNote(String id, String text) async {
    if (text.trim().isEmpty) {
      notes.remove(id);
    } else {
      notes[id] = text.trim();
    }
    await _persist();
    notifyListeners();
  }

  Future<void> recordAnswer({
    required Question question,
    required int selectedIndex,
    required int elapsedSeconds,
    String? cause,
  }) async {
    attemptCounts[question.id] = (attemptCounts[question.id] ?? 0) + 1;
    final correct = question.isCorrect(selectedIndex);
    if (correct) {
      correctCounts[question.id] = (correctCounts[question.id] ?? 0) + 1;
      wrongAnswers.removeWhere((w) => w.questionId == question.id);
    } else {
      WrongAnswerRecord? existing;
      for (final w in wrongAnswers) {
        if (w.questionId == question.id) {
          existing = w;
          break;
        }
      }
      if (existing != null) {
        existing.wrongCount += 1;
        existing.cause = cause;
      } else {
        wrongAnswers.add(
          WrongAnswerRecord(
            questionId: question.id,
            selectedAnswer: question.choices[selectedIndex],
            correctAnswer: question.choices[question.answerIndex],
            wrongAt: DateTime.now().toIso8601String(),
            cause: cause,
            relatedFormulaIds: question.relatedFormulaIds,
            relatedLessonIds: question.relatedLessonIds,
          ),
        );
      }
    }
    addStudyMinutes((elapsedSeconds / 60).ceil().clamp(1, 30));
    await _persist();
    notifyListeners();
  }

  Future<void> addMockResult(MockExamResult result) async {
    mockResults.insert(0, result);
    await _persist();
    notifyListeners();
  }

  void addStudyMinutes(int minutes) {
    final key = DateTime.now().toIso8601String().substring(0, 10);
    studyMinutesByDay[key] = (studyMinutesByDay[key] ?? 0) + minutes;
  }

  Future<void> setExamDate(DateTime? date) async {
    examDate = date;
    await _persist();
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    darkMode = value;
    await _persist();
    notifyListeners();
  }

  Future<void> setDailyGoal(int minutes) async {
    dailyGoalMinutes = minutes;
    await _persist();
    notifyListeners();
  }

  Future<void> setFocusTrack(String track) async {
    focusTrack = track;
    await _persist();
    notifyListeners();
  }

  Future<void> markWrongMastered(String questionId, bool mastered) async {
    for (final w in wrongAnswers) {
      if (w.questionId == questionId) {
        w.mastered = mastered;
        w.lastReviewAt = DateTime.now().toIso8601String();
      }
    }
    await _persist();
    notifyListeners();
  }

  double subjectProgress(String subjectId) {
    final lessons = Catalog.lessons
        .where((l) => l.subjectId == subjectId)
        .toList();
    if (lessons.isEmpty) return 0;
    final done = lessons.where((l) => completedLessons.contains(l.id)).length;
    return done / lessons.length;
  }

  double get practicalProgress {
    final items = Catalog.practicalItems;
    if (items.isEmpty) return 0;
    final done = items
        .where((p) => completedLessons.contains('prac_${p.id}'))
        .length;
    return done / items.length;
  }

  double overallCorrectRate() {
    final attempts = attemptCounts.values.fold<int>(0, (a, b) => a + b);
    if (attempts == 0) return 0;
    final corrects = correctCounts.values.fold<int>(0, (a, b) => a + b);
    return corrects / attempts;
  }

  double subjectCorrectRate(String subjectId) {
    final qs = Catalog.questions
        .where((q) => q.subjectId == subjectId)
        .toList();
    var attempts = 0;
    var corrects = 0;
    for (final q in qs) {
      attempts += attemptCounts[q.id] ?? 0;
      corrects += correctCounts[q.id] ?? 0;
    }
    if (attempts == 0) return 0;
    return corrects / attempts;
  }

  List<String> weakSubjects({int top = 3}) {
    final rates =
        WrittenSubjectIds.all
            .map((id) => MapEntry(id, subjectCorrectRate(id)))
            .where(
              (e) => (attemptCounts.keys.any((qid) {
                final q = Catalog.questionById(qid);
                return q?.subjectId == e.key;
              })),
            )
            .toList()
          ..sort((a, b) => a.value.compareTo(b.value));
    return rates.take(top).map((e) => e.key).toList();
  }

  int get totalSolved => attemptCounts.values.fold<int>(0, (a, b) => a + b);

  int weekStudyMinutes() {
    final now = DateTime.now();
    var sum = 0;
    for (var i = 0; i < 7; i++) {
      final d = now.subtract(Duration(days: i));
      final key = d.toIso8601String().substring(0, 10);
      sum += studyMinutesByDay[key] ?? 0;
    }
    return sum;
  }

  int todayStudyMinutes() {
    final key = DateTime.now().toIso8601String().substring(0, 10);
    return studyMinutesByDay[key] ?? 0;
  }

  /// 학습관리용 참고 준비도 (0~100). 합격 보장 지표 아님.
  double readinessScore() {
    return StudyMetrics.computeReadiness(
      lessonCompletion: Catalog.lessons.isEmpty
          ? 0
          : completedLessons
                    .where((id) => Catalog.lessons.any((l) => l.id == id))
                    .length /
                Catalog.lessons.length,
      correctRate: overallCorrectRate(),
      wrongReviewRate: wrongAnswers.isEmpty
          ? 1
          : wrongAnswers.where((w) => w.mastered).length / wrongAnswers.length,
      mockAverage: mockResults.isEmpty
          ? 0
          : mockResults.map((m) => m.average).reduce((a, b) => a + b) /
                mockResults.length /
                100,
      studyConsistency: (weekStudyMinutes() / (dailyGoalMinutes * 7))
          .clamp(0, 1)
          .toDouble(),
    );
  }
}

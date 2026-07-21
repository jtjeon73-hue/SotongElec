import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// 저장소 추상화 — 초기에는 SharedPreferences, 이후 Firestore로 교체 가능
abstract class StudyStorage {
  Future<void> init();
  Future<Map<String, dynamic>> loadAll();
  Future<void> saveAll(Map<String, dynamic> data);
  Future<void> clear();
}

class SharedPrefsStudyStorage implements StudyStorage {
  static const _key = 'sotong_elec_study_v1';
  SharedPreferences? _prefs;

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<Map<String, dynamic>> loadAll() async {
    final raw = _prefs?.getString(_key);
    if (raw == null || raw.isEmpty) return {};
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) return decoded;
    return Map<String, dynamic>.from(decoded as Map);
  }

  @override
  Future<void> saveAll(Map<String, dynamic> data) async {
    await _prefs?.setString(_key, jsonEncode(data));
  }

  @override
  Future<void> clear() async {
    await _prefs?.remove(_key);
  }
}

/// 인메모리 저장소 (테스트용)
class MemoryStudyStorage implements StudyStorage {
  Map<String, dynamic> _data = {};

  @override
  Future<void> init() async {}

  @override
  Future<Map<String, dynamic>> loadAll() async =>
      Map<String, dynamic>.from(_data);

  @override
  Future<void> saveAll(Map<String, dynamic> data) async {
    _data = Map<String, dynamic>.from(data);
  }

  @override
  Future<void> clear() async {
    _data = {};
  }
}

class WrongAnswerRecord {
  WrongAnswerRecord({
    required this.questionId,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.wrongAt,
    this.wrongCount = 1,
    this.cause,
    this.relatedFormulaIds = const [],
    this.relatedLessonIds = const [],
    this.lastReviewAt,
    this.retryAt,
    this.mastered = false,
  });

  final String questionId;
  final String selectedAnswer;
  final String correctAnswer;
  final String wrongAt;
  int wrongCount;
  String? cause;
  List<String> relatedFormulaIds;
  List<String> relatedLessonIds;
  String? lastReviewAt;
  String? retryAt;
  bool mastered;

  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'selectedAnswer': selectedAnswer,
    'correctAnswer': correctAnswer,
    'wrongAt': wrongAt,
    'wrongCount': wrongCount,
    'cause': cause,
    'relatedFormulaIds': relatedFormulaIds,
    'relatedLessonIds': relatedLessonIds,
    'lastReviewAt': lastReviewAt,
    'retryAt': retryAt,
    'mastered': mastered,
  };

  factory WrongAnswerRecord.fromJson(Map<String, dynamic> json) =>
      WrongAnswerRecord(
        questionId: json['questionId'] as String,
        selectedAnswer: json['selectedAnswer'] as String,
        correctAnswer: json['correctAnswer'] as String,
        wrongAt: json['wrongAt'] as String,
        wrongCount: json['wrongCount'] as int? ?? 1,
        cause: json['cause'] as String?,
        relatedFormulaIds:
            (json['relatedFormulaIds'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
        relatedLessonIds:
            (json['relatedLessonIds'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
        lastReviewAt: json['lastReviewAt'] as String?,
        retryAt: json['retryAt'] as String?,
        mastered: json['mastered'] as bool? ?? false,
      );
}

class MockExamResult {
  MockExamResult({
    required this.id,
    required this.takenAt,
    required this.mode,
    required this.subjectScores,
    required this.average,
    required this.hasFailSubject,
    required this.correctRate,
    required this.elapsedSeconds,
    required this.weakChapters,
  });

  final String id;
  final String takenAt;
  final String mode;
  final Map<String, double> subjectScores;
  final double average;
  final bool hasFailSubject;
  final double correctRate;
  final int elapsedSeconds;
  final List<String> weakChapters;

  Map<String, dynamic> toJson() => {
    'id': id,
    'takenAt': takenAt,
    'mode': mode,
    'subjectScores': subjectScores,
    'average': average,
    'hasFailSubject': hasFailSubject,
    'correctRate': correctRate,
    'elapsedSeconds': elapsedSeconds,
    'weakChapters': weakChapters,
  };

  factory MockExamResult.fromJson(Map<String, dynamic> json) => MockExamResult(
    id: json['id'] as String,
    takenAt: json['takenAt'] as String,
    mode: json['mode'] as String,
    subjectScores: Map<String, double>.from(
      (json['subjectScores'] as Map).map(
        (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
      ),
    ),
    average: (json['average'] as num).toDouble(),
    hasFailSubject: json['hasFailSubject'] as bool,
    correctRate: (json['correctRate'] as num).toDouble(),
    elapsedSeconds: json['elapsedSeconds'] as int,
    weakChapters: (json['weakChapters'] as List<dynamic>)
        .map((e) => e.toString())
        .toList(),
  );
}

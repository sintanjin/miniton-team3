import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'school_data.dart';

class AiApiService {
  AiApiService({http.Client? client}) : _client = client ?? http.Client();

  static final AiApiService instance = AiApiService();

  static const _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://172.18.156.26:8080',
  );

  final http.Client _client;

  Future<RecommendationResponse> getRecommendations(SchoolData school) async {
    final json = await _post(
      '/api/v1/ai/recommendations',
      {'school': school.toAiRequestJson()},
    );
    return RecommendationResponse.fromJson(json);
  }

  Future<IdeaEvaluationResponse> evaluateIdea({
    required SchoolData school,
    required String idea,
  }) async {
    final json = await _post(
      '/api/v1/ai/idea-evaluations',
      {
        'school': school.toAiRequestJson(),
        'idea': idea,
      },
    );
    return IdeaEvaluationResponse.fromJson(json);
  }

  Future<FinalCheckpointResponse> getFinalCheckpoints({
    required SchoolData school,
    required FinalCheckpointArguments arguments,
  }) async {
    final json = await _post(
      '/api/v1/ai/final-checkpoints',
      arguments.toRequestJson(school),
    );
    return FinalCheckpointResponse.fromJson(json);
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$_baseUrl$path'),
            headers: const {
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 40));

      final decoded = response.bodyBytes.isEmpty
          ? <String, dynamic>{}
          : jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw AiApiException.fromJson(
          decoded,
          statusCode: response.statusCode,
        );
      }
      return decoded;
    } on TimeoutException {
      throw const AiApiException(
        code: 'AI_REQUEST_TIMEOUT',
        message: 'AI 분석 시간이 초과되었습니다. 잠시 후 다시 시도해 주세요.',
      );
    } on AiApiException {
      rethrow;
    } on FormatException {
      throw const AiApiException(
        code: 'AI_RESPONSE_INVALID',
        message: 'AI 분석 결과를 읽을 수 없습니다.',
      );
    } catch (_) {
      throw const AiApiException(
        code: 'NETWORK_ERROR',
        message: '백엔드 서버에 연결할 수 없습니다.',
      );
    }
  }
}

class AiApiException implements Exception {
  const AiApiException({
    required this.code,
    required this.message,
    this.requestId,
    this.statusCode,
  });

  final String code;
  final String message;
  final String? requestId;
  final int? statusCode;

  factory AiApiException.fromJson(
    Map<String, dynamic> json, {
    required int statusCode,
  }) {
    return AiApiException(
      code: json['code'] as String? ?? 'HTTP_$statusCode',
      message: json['message'] as String? ?? '요청을 처리하지 못했습니다.',
      requestId: json['requestId'] as String?,
      statusCode: statusCode,
    );
  }

  @override
  String toString() => message;
}

class RecommendationResponse {
  const RecommendationResponse({
    required this.analysisId,
    required this.schoolId,
    required this.recommendations,
    required this.createdAt,
  });

  final String analysisId;
  final String schoolId;
  final List<RecommendationItem> recommendations;
  final DateTime? createdAt;

  factory RecommendationResponse.fromJson(Map<String, dynamic> json) {
    final items = (json['recommendations'] as List<dynamic>? ?? const [])
        .map((item) => RecommendationItem.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
    if (items.length != 3) {
      throw const AiApiException(
        code: 'AI_RESPONSE_INVALID',
        message: '추천 결과가 올바르지 않습니다.',
      );
    }
    return RecommendationResponse(
      analysisId: json['analysisId'] as String? ?? '',
      schoolId: json['schoolId'] as String? ?? '',
      recommendations: items,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
    );
  }
}

class RecommendationItem {
  const RecommendationItem({
    required this.id,
    required this.rank,
    required this.title,
    required this.description,
    required this.strengths,
    required this.risks,
  });

  final String id;
  final int rank;
  final String title;
  final String description;
  final List<String> strengths;
  final List<String> risks;

  factory RecommendationItem.fromJson(Map<String, dynamic> json) {
    return RecommendationItem(
      id: json['id'] as String? ?? '',
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      strengths: _stringList(json['strengths']),
      risks: _stringList(json['risks']),
    );
  }

  Map<String, dynamic> toFinalCheckpointJson() => {
        'recommendationId': id,
        'rank': rank,
        'title': title,
        'description': description,
        'advantages': strengths,
        'limitations': risks,
      };
}

class IdeaEvaluationResponse {
  const IdeaEvaluationResponse({
    required this.analysisId,
    required this.schoolId,
    required this.idea,
    required this.summary,
    required this.overallGrade,
    required this.metrics,
    required this.strengths,
    required this.weaknesses,
    required this.alternativeModels,
    required this.recommendation,
    required this.createdAt,
  });

  final String analysisId;
  final String schoolId;
  final String idea;
  final String summary;
  final Grade overallGrade;
  final EvaluationMetrics metrics;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> alternativeModels;
  final String recommendation;
  final DateTime? createdAt;

  factory IdeaEvaluationResponse.fromJson(Map<String, dynamic> json) {
    return IdeaEvaluationResponse(
      analysisId: json['analysisId'] as String? ?? '',
      schoolId: json['schoolId'] as String? ?? '',
      idea: json['idea'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      overallGrade: Grade.parse(json['overallGrade']),
      metrics: EvaluationMetrics.fromJson(
        json['metrics'] as Map<String, dynamic>? ?? const {},
      ),
      strengths: _stringList(json['strengths']),
      weaknesses: _stringList(json['weaknesses']),
      alternativeModels: _stringList(json['alternativeModels']),
      recommendation: json['recommendation'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
    );
  }

  Map<String, dynamic> toFinalCheckpointJson() => {
        'evaluationId': analysisId,
        'idea': idea,
        'overallGrade': overallGrade.code,
        'summary': summary,
        'metrics': metrics.toJson(),
        'strengths': strengths,
        'weaknesses': weaknesses,
        'alternativeModels': alternativeModels,
        'recommendation': recommendation,
      };
}

class EvaluationMetrics {
  const EvaluationMetrics({
    required this.spaceSuitability,
    required this.accessibility,
    required this.regionalDemand,
    required this.similarCaseSuitability,
    required this.executionFeasibility,
  });

  final MetricEvaluation spaceSuitability;
  final MetricEvaluation accessibility;
  final MetricEvaluation regionalDemand;
  final MetricEvaluation similarCaseSuitability;
  final MetricEvaluation executionFeasibility;

  factory EvaluationMetrics.fromJson(Map<String, dynamic> json) {
    return EvaluationMetrics(
      spaceSuitability: MetricEvaluation.fromJson(json['spaceSuitability']),
      accessibility: MetricEvaluation.fromJson(json['accessibility']),
      regionalDemand: MetricEvaluation.fromJson(json['regionalDemand']),
      similarCaseSuitability: MetricEvaluation.fromJson(json['similarCaseSuitability']),
      executionFeasibility: MetricEvaluation.fromJson(json['executionFeasibility']),
    );
  }

  Map<String, dynamic> toJson() => {
        'spaceSuitability': spaceSuitability.toJson(),
        'accessibility': accessibility.toJson(),
        'regionalDemand': regionalDemand.toJson(),
        'similarCaseSuitability': similarCaseSuitability.toJson(),
        'executionFeasibility': executionFeasibility.toJson(),
      };
}

class MetricEvaluation {
  const MetricEvaluation({required this.grade, required this.reasons});

  final Grade grade;
  final List<String> reasons;

  factory MetricEvaluation.fromJson(Object? value) {
    if (value is String) {
      return MetricEvaluation(grade: Grade.parse(value), reasons: const []);
    }
    if (value is! Map<String, dynamic>) {
      throw const AiApiException(
        code: 'AI_RESPONSE_INVALID',
        message: '평가 항목의 형식이 올바르지 않습니다.',
      );
    }
    return MetricEvaluation(
      grade: Grade.parse(value['grade']),
      reasons: _stringList(value['reasons']),
    );
  }

  Map<String, dynamic> toJson() => {
        'grade': grade.code,
        'reasons': reasons,
      };
}

enum Grade {
  veryLow('VERY_LOW', '매우 낮음'),
  low('LOW', '낮음'),
  medium('MEDIUM', '보통'),
  high('HIGH', '우수'),
  veryHigh('VERY_HIGH', '매우 우수');

  const Grade(this.code, this.label);

  final String code;
  final String label;

  static Grade parse(Object? value) {
    return Grade.values.firstWhere(
      (grade) => grade.code == value,
      orElse: () => throw const AiApiException(
        code: 'AI_RESPONSE_INVALID',
        message: '알 수 없는 평가 등급입니다.',
      ),
    );
  }
}

class IdeaEvaluationArguments {
  const IdeaEvaluationArguments({required this.schoolId, required this.idea});

  final String schoolId;
  final String idea;
}

enum FinalCheckpointSourceType {
  recommendation('RECOMMENDATION'),
  ideaEvaluation('IDEA_EVALUATION');

  const FinalCheckpointSourceType(this.code);

  final String code;
}

class FinalCheckpointArguments {
  const FinalCheckpointArguments.recommendation({
    required this.schoolId,
    required this.analysisId,
    required RecommendationItem recommendation,
  })  : sourceType = FinalCheckpointSourceType.recommendation,
        selectedRecommendation = recommendation,
        ideaEvaluation = null;

  const FinalCheckpointArguments.ideaEvaluation({
    required this.schoolId,
    required this.analysisId,
    required IdeaEvaluationResponse evaluation,
  })  : sourceType = FinalCheckpointSourceType.ideaEvaluation,
        selectedRecommendation = null,
        ideaEvaluation = evaluation;

  final String schoolId;
  final String analysisId;
  final FinalCheckpointSourceType sourceType;
  final RecommendationItem? selectedRecommendation;
  final IdeaEvaluationResponse? ideaEvaluation;

  Map<String, dynamic> toRequestJson(SchoolData school) => {
        'sourceType': sourceType.code,
        'analysisId': analysisId,
        'school': school.toAiRequestJson(),
        if (selectedRecommendation != null)
          'selectedRecommendation': selectedRecommendation!.toFinalCheckpointJson(),
        if (ideaEvaluation != null)
          'ideaEvaluation': ideaEvaluation!.toFinalCheckpointJson(),
      };
}

class FinalCheckpointResponse {
  const FinalCheckpointResponse({
    required this.checkpointId,
    required this.analysisId,
    required this.schoolId,
    required this.items,
    required this.createdAt,
  });

  final String checkpointId;
  final String analysisId;
  final String schoolId;
  final List<FinalCheckpointItem> items;
  final DateTime? createdAt;

  factory FinalCheckpointResponse.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List<dynamic>? ?? const [])
        .map((item) => FinalCheckpointItem.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
    final categories = items.map((item) => item.category).toSet();
    if (items.length != CheckpointCategory.values.length ||
        categories.length != CheckpointCategory.values.length) {
      throw const AiApiException(
        code: 'CHECKPOINT_RESPONSE_INVALID',
        message: '최종 체크포인트 결과가 올바르지 않습니다.',
      );
    }
    items.sort((a, b) => a.category.index.compareTo(b.category.index));
    return FinalCheckpointResponse(
      checkpointId: json['checkpointId'] as String? ?? '',
      analysisId: json['analysisId'] as String? ?? '',
      schoolId: json['schoolId'] as String? ?? '',
      items: items,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
    );
  }
}

class FinalCheckpointItem {
  const FinalCheckpointItem({
    required this.category,
    required this.priority,
    required this.note,
    required this.tip,
  });

  final CheckpointCategory category;
  final CheckpointPriority priority;
  final String note;
  final String tip;

  factory FinalCheckpointItem.fromJson(Map<String, dynamic> json) {
    final note = json['note'] as String? ?? '';
    final tip = json['tip'] as String? ?? '';
    if (note.trim().isEmpty || tip.trim().isEmpty) {
      throw const AiApiException(
        code: 'CHECKPOINT_RESPONSE_INVALID',
        message: '체크포인트 문장이 비어 있습니다.',
      );
    }
    return FinalCheckpointItem(
      category: CheckpointCategory.parse(json['category']),
      priority: CheckpointPriority.parse(json['priority']),
      note: note,
      tip: tip,
    );
  }
}

enum CheckpointCategory {
  administration('ADMINISTRATION', '행정'),
  facility('FACILITY', '시설'),
  budget('BUDGET', '예산'),
  demand('DEMAND', '수요'),
  operatingSustainability('OPERATING_SUSTAINABILITY', '운영 지속성'),
  communityAcceptance('COMMUNITY_ACCEPTANCE', '지역수용성');

  const CheckpointCategory(this.code, this.label);

  final String code;
  final String label;

  static CheckpointCategory parse(Object? value) => CheckpointCategory.values.firstWhere(
        (category) => category.code == value,
        orElse: () => throw const AiApiException(
          code: 'CHECKPOINT_RESPONSE_INVALID',
          message: '알 수 없는 체크포인트 항목입니다.',
        ),
      );
}

enum CheckpointPriority {
  high('HIGH'),
  medium('MEDIUM'),
  low('LOW');

  const CheckpointPriority(this.code);

  final String code;

  static CheckpointPriority parse(Object? value) => CheckpointPriority.values.firstWhere(
        (priority) => priority.code == value,
        orElse: () => throw const AiApiException(
          code: 'CHECKPOINT_RESPONSE_INVALID',
          message: '알 수 없는 체크포인트 우선순위입니다.',
        ),
      );
}

List<String> _stringList(Object? value) {
  return (value as List<dynamic>? ?? const [])
      .whereType<String>()
      .toList(growable: false);
}

import 'dart:convert';

import 'package:flutter/services.dart';

class SchoolData {
  const SchoolData({
    required this.id,
    required this.status,
    required this.region,
    required this.name,
    required this.closedDate,
    required this.address,
    required this.landAreaSqm,
    required this.landAreaText,
    required this.buildingAreaSqm,
    required this.buildingAreaText,
    required this.plan,
    required this.nearbyResources,
    required this.image,
  });

  final String id;
  final String status;
  final String region;
  final String name;
  final String closedDate;
  final String address;
  final num? landAreaSqm;
  final String landAreaText;
  final num? buildingAreaSqm;
  final String buildingAreaText;
  final String plan;
  final String nearbyResources;
  final String? image;

  List<String> get nearbyResourceList => nearbyResources
      .split(',')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList(growable: false);

  Map<String, dynamic> toAiRequestJson() {
    return {
      'schoolId': id,
      'schoolName': name,
      'address': address,
      'closedDate': _normalizedClosedDate,
      'siteArea': landAreaSqm ?? 0,
      'buildingArea': buildingAreaSqm ?? 0,
      'utilizationPlan': status,
      'promotionPlan': plan,
      'nearbyResources': nearbyResourceList,
    };
  }

  String? get _normalizedClosedDate {
    final numbers = RegExp(r'\d+').allMatches(closedDate).map((match) => match.group(0)!).toList();
    if (numbers.length < 3) return null;
    final year = int.tryParse(numbers[0]);
    final month = int.tryParse(numbers[1]);
    final day = int.tryParse(numbers[2]);
    if (year == null || month == null || day == null) return null;
    return '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }

  factory SchoolData.fromJson(Map<String, dynamic> json) {
    return SchoolData(
      id: json['id'] as String,
      status: json['status'] as String,
      region: json['region'] as String,
      name: json['name'] as String,
      closedDate: json['closedDate'] as String,
      address: json['address'] as String,
      landAreaSqm: json['landAreaSqm'] as num?,
      landAreaText: json['landAreaText'] as String,
      buildingAreaSqm: json['buildingAreaSqm'] as num?,
      buildingAreaText: json['buildingAreaText'] as String,
      plan: json['plan'] as String,
      nearbyResources: json['nearbyResources'] as String? ?? '',
      image: json['image'] as String?,
    );
  }
}

class SchoolRepository {
  const SchoolRepository._();

  static Future<List<SchoolData>> loadSchools() async {
    final raw = await rootBundle.loadString('assets/data/schools.json');
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => SchoolData.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<List<SchoolData>> loadTopSchools({int count = 9}) async {
    final schools = await loadSchools();
    return schools.take(count).toList();
  }

  static Future<SchoolData> loadSchool(String schoolId) async {
    final schools = await loadSchools();
    return schools.firstWhere(
      (school) => school.id == schoolId,
      orElse: () => throw StateError('School not found: $schoolId'),
    );
  }
}

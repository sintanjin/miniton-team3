import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../data/ai_api.dart';
import '../data/school_data.dart';

class ReportPdfService {
  const ReportPdfService._();

  static Future<void> save({
    required SchoolData school,
    required FinalCheckpointArguments arguments,
    required FinalCheckpointResponse checkpoints,
  }) async {
    final bytes = await build(
      school: school,
      arguments: arguments,
      checkpoints: checkpoints,
    );
    final safeName = school.name.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    await Printing.sharePdf(
      bytes: bytes,
      filename: '${safeName}_폐교활용진단.pdf',
    );
  }

  static Future<Uint8List> build({
    required SchoolData school,
    required FinalCheckpointArguments arguments,
    required FinalCheckpointResponse checkpoints,
  }) async {
    final regular = pw.Font.ttf(
      await rootBundle.load('assets/fonts/NotoSansKR-Regular.ttf'),
    );
    final bold = pw.Font.ttf(
      await rootBundle.load('assets/fonts/NotoSansKR-Bold.ttf'),
    );
    final image = await _loadSchoolImage(school.image);
    final document = pw.Document(
      title: '${school.name} 폐교 활용 진단 결과',
      author: '다시, 학교',
    );
    final theme = pw.ThemeData.withFont(base: regular, bold: bold);

    document.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.fromLTRB(42, 48, 42, 48),
          theme: theme,
          buildBackground: (context) => pw.FullPage(
            ignoreMargins: true,
            child: pw.Container(color: PdfColors.white),
          ),
        ),
        header: (context) => pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 18),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('다시, 학교', style: pw.TextStyle(font: bold, fontSize: 12, color: PdfColors.indigo700)),
              pw.Text('${school.name} 활용 진단 보고서', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
            ],
          ),
        ),
        footer: (context) => pw.Padding(
          padding: const pw.EdgeInsets.only(top: 14),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('AI 기반 폐교 활용가능성 진단 서비스', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
              pw.Text('${context.pageNumber} / ${context.pagesCount}', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
            ],
          ),
        ),
        build: (context) => [
          _title('1. 학교 정보', bold),
          pw.SizedBox(height: 14),
          _schoolImage(image),
          pw.SizedBox(height: 16),
          _schoolInfo(school, bold),
          pw.NewPage(),
          _title('2. AI 분석 결과', bold),
          pw.SizedBox(height: 14),
          if (arguments.sourceType == FinalCheckpointSourceType.recommendation)
            _recommendationSection(arguments.selectedRecommendation!, bold)
          else
            _evaluationSection(arguments.ideaEvaluation!, bold),
          pw.NewPage(),
          _title('3. 최종 체크포인트', bold),
          pw.SizedBox(height: 8),
          pw.Text(
            '선택한 학교와 활용모델을 기준으로 사업 추진 전에 확인할 내용을 정리했습니다.',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 14),
          ...checkpoints.items.expand(
            (item) => [
              pw.NewPage(freeSpace: 150),
              _checkpointCard(item, bold),
            ],
          ),
        ],
      ),
    );

    return document.save();
  }

  static Future<Uint8List?> _loadSchoolImage(String? path) async {
    if (path == null || path.trim().isEmpty) return null;
    try {
      final data = await rootBundle.load(path);
      return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    } catch (_) {
      return null;
    }
  }

  static pw.Widget _title(String text, pw.Font bold) => pw.Text(
        text,
        style: pw.TextStyle(font: bold, fontSize: 22, color: PdfColors.grey900),
      );

  static pw.Widget _schoolImage(Uint8List? bytes) {
    if (bytes == null) {
      return pw.Container(
        height: 190,
        width: double.infinity,
        alignment: pw.Alignment.center,
        decoration: pw.BoxDecoration(
          color: PdfColors.grey200,
          borderRadius: pw.BorderRadius.circular(12),
        ),
        child: pw.Text('등록된 학교 이미지가 없습니다.', style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey600)),
      );
    }
    return pw.Container(
      height: 230,
      width: double.infinity,
      decoration: pw.BoxDecoration(borderRadius: pw.BorderRadius.circular(12)),
      child: pw.ClipRRect(
        horizontalRadius: 12,
        verticalRadius: 12,
        child: pw.Image(pw.MemoryImage(bytes), fit: pw.BoxFit.cover),
      ),
    );
  }

  static pw.Widget _schoolInfo(SchoolData school, pw.Font bold) {
    final rows = [
      ('학교명', school.name),
      ('주소', school.address),
      ('폐교일', school.closedDate),
      ('부지 면적', school.landAreaText),
      ('건물 면적', school.buildingAreaText),
      ('추진 계획', school.plan.isEmpty ? '확인 필요' : school.plan),
      ('주변 자원', school.nearbyResources.isEmpty ? '확인 필요' : school.nearbyResources),
    ];
    return pw.Container(
      padding: const pw.EdgeInsets.all(18),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(12),
      ),
      child: pw.Column(
        children: rows
            .map(
              (row) => pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 5),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(width: 82, child: pw.Text(row.$1, style: pw.TextStyle(font: bold, fontSize: 10))),
                    pw.Expanded(child: pw.Text(row.$2, style: const pw.TextStyle(fontSize: 10, lineSpacing: 3))),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  static pw.Widget _recommendationSection(RecommendationItem item, pw.Font bold) => pw.Container(
        padding: const pw.EdgeInsets.all(20),
        decoration: _sectionDecoration(),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _badge('AI 추천 활용모델', PdfColors.indigo50, PdfColors.indigo700, bold),
            pw.SizedBox(height: 12),
            pw.Text(item.title, style: pw.TextStyle(font: bold, fontSize: 17)),
            pw.SizedBox(height: 8),
            pw.Text(item.description, style: const pw.TextStyle(fontSize: 10.5, lineSpacing: 4)),
            pw.SizedBox(height: 16),
            _listBlock('장점', item.strengths, PdfColors.green700, bold),
            pw.SizedBox(height: 12),
            _listBlock('확인할 점', item.risks, PdfColors.red600, bold),
          ],
        ),
      );

  static pw.Widget _evaluationSection(IdeaEvaluationResponse value, pw.Font bold) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(color: PdfColors.grey200, borderRadius: pw.BorderRadius.circular(10)),
            child: pw.Text(value.idea, style: const pw.TextStyle(fontSize: 11, lineSpacing: 4)),
          ),
          pw.SizedBox(height: 10),
          pw.Container(
            padding: const pw.EdgeInsets.all(18),
            decoration: _sectionDecoration(),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(child: pw.Text(value.summary, style: pw.TextStyle(font: bold, fontSize: 11, lineSpacing: 4))),
                    pw.SizedBox(width: 12),
                    _badge('적합도: ${value.overallGrade.label}', PdfColors.amber100, PdfColors.orange800, bold),
                  ],
                ),
                pw.SizedBox(height: 16),
                _metric('공간 적합성', value.metrics.spaceSuitability, bold),
                _metric('접근성', value.metrics.accessibility, bold),
                _metric('지역 수요', value.metrics.regionalDemand, bold),
                _metric('유사사례 적합성', value.metrics.similarCaseSuitability, bold),
                _metric('실행 가능성', value.metrics.executionFeasibility, bold),
              ],
            ),
          ),
          pw.SizedBox(height: 12),
          _listBlock('장점', value.strengths, PdfColors.green700, bold),
          pw.SizedBox(height: 10),
          _listBlock('단점', value.weaknesses, PdfColors.red600, bold),
          pw.SizedBox(height: 10),
          _listBlock('대안 활용모델', value.alternativeModels, PdfColors.indigo700, bold),
          pw.SizedBox(height: 12),
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(14),
            decoration: pw.BoxDecoration(color: PdfColors.indigo50, borderRadius: pw.BorderRadius.circular(8)),
            child: pw.Text('추천: ${value.recommendation}', style: pw.TextStyle(font: bold, fontSize: 10.5, color: PdfColors.indigo700)),
          ),
        ],
      );

  static pw.Widget _metric(String label, MetricEvaluation value, pw.Font bold) => pw.Container(
        margin: const pw.EdgeInsets.only(bottom: 6),
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(color: PdfColors.grey100, borderRadius: pw.BorderRadius.circular(7)),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(width: 92, child: pw.Text(label, style: pw.TextStyle(font: bold, fontSize: 9.5))),
            pw.SizedBox(width: 58, child: pw.Text(value.grade.label, style: pw.TextStyle(font: bold, fontSize: 9, color: PdfColors.indigo700))),
            pw.Expanded(child: pw.Text(value.reasons.join(' '), style: const pw.TextStyle(fontSize: 8.8, lineSpacing: 3))),
          ],
        ),
      );

  static pw.Widget _checkpointCard(FinalCheckpointItem item, pw.Font bold) => pw.Container(
        margin: const pw.EdgeInsets.only(bottom: 10),
        padding: const pw.EdgeInsets.all(16),
        decoration: _sectionDecoration(),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              children: [
                pw.Text(item.category.label, style: pw.TextStyle(font: bold, fontSize: 13)),
                if (item.priority == CheckpointPriority.high) ...[
                  pw.SizedBox(width: 8),
                  _badge('우선 확인', PdfColors.red50, PdfColors.red600, bold),
                ],
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Text(item.note, style: const pw.TextStyle(fontSize: 10, lineSpacing: 4)),
            pw.SizedBox(height: 9),
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(color: PdfColors.indigo50, borderRadius: pw.BorderRadius.circular(6)),
              child: pw.Text('TIP  ${item.tip}', style: const pw.TextStyle(fontSize: 9, color: PdfColors.indigo700, lineSpacing: 3)),
            ),
          ],
        ),
      );

  static pw.Widget _listBlock(String title, List<String> items, PdfColor color, pw.Font bold) => pw.Container(
        width: double.infinity,
        padding: const pw.EdgeInsets.all(14),
        decoration: pw.BoxDecoration(color: PdfColors.white, border: pw.Border.all(color: PdfColors.grey300), borderRadius: pw.BorderRadius.circular(8)),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(title, style: pw.TextStyle(font: bold, fontSize: 11, color: color)),
            pw.SizedBox(height: 7),
            if (items.isEmpty)
              pw.Text('제공된 내용이 없습니다.', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600))
            else
              ...items.map((item) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 4),
                    child: pw.Text('• $item', style: const pw.TextStyle(fontSize: 9.5, lineSpacing: 3)),
                  )),
          ],
        ),
      );

  static pw.Widget _badge(String text, PdfColor background, PdfColor foreground, pw.Font bold) => pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: pw.BoxDecoration(color: background, borderRadius: pw.BorderRadius.circular(20)),
        child: pw.Text(text, style: pw.TextStyle(font: bold, fontSize: 8.5, color: foreground)),
      );

  static pw.BoxDecoration _sectionDecoration() => pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(12),
      );
}

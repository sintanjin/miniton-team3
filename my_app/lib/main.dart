import 'package:flutter/material.dart';

import 'pages/ai_recommendation_page.dart';
import 'pages/checklist_page.dart';
import 'pages/idea_input_page.dart';
import 'pages/idea_page.dart';
import 'pages/landing_page.dart';
import 'pages/school_detail_page.dart';
import 'pages/school_selection_page.dart';

void main() => runApp(const ReSchoolApp());

class ReSchoolApp extends StatelessWidget {
  const ReSchoolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: K.h('{d,a}{s,i}, {h,a,g}{g,yo}'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FE),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5661E8),
          brightness: Brightness.light,
        ),
        fontFamilyFallback: const ['Pretendard', 'Noto Sans KR', 'Malgun Gothic'],
      ),
      initialRoute: LandingPage.routeName,
      routes: {
        LandingPage.routeName: (_) => const LandingPage(),
        SchoolSelectionPage.routeName: (_) => const SchoolSelectionPage(),
        SchoolDetailPage.routeName: (_) => const SchoolDetailPage(),
        IdeaPage.routeName: (_) => const IdeaPage(),
        IdeaInputPage.routeName: (_) => const IdeaInputPage(),
        IdeaReviewPage.routeName: (_) => const IdeaReviewPage(),
        AiRecommendationPage.routeName: (_) => const AiRecommendationPage(),
        ChecklistPage.routeName: (_) => const ChecklistPage(),
      },
    );
  }
}

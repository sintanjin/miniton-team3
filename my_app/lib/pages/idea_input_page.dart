import 'package:flutter/material.dart';

import '../data/ai_api.dart';
import '../data/school_data.dart';
import 'checklist_page.dart';
import 'landing_page.dart';

class IdeaInputPage extends StatefulWidget {
  const IdeaInputPage({super.key});

  static const routeName = '/idea-input';

  @override
  State<IdeaInputPage> createState() => _IdeaInputPageState();
}

class _IdeaInputPageState extends State<IdeaInputPage> {
  static const _primary = Color(0xFF5661E8);
  static const _bg = Color(0xFFF7F8FC);

  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _hasText {
    final length = _controller.text.trim().length;
    return length >= 10 && length <= 500;
  }

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)?.settings.arguments;
    final schoolId = argument is String ? argument : '';
    return Scaffold(
      backgroundColor: _bg,
      body: SingleChildScrollView(
        child: Stack(
          children: [
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 92,
            child: ColoredBox(color: Color(0xFFFCFDFF)),
          ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 34),
                  const _BrandHeader(),
                  const SizedBox(height: 84),
                  const _StepProgress(activeUntil: 1),
                  const SizedBox(height: 88),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${K.h('{ng,eo}{tt,eo,n} idea{r,eu,l} {g,a,j}{g,o} {g,ye}{s,i,n}{g,a}{ng,yo}?')}\n',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        TextSpan(
                          text: K.h('{h,a,n} {m,u,n}{j,a,ng}{ng,eu}{r,o} {g,a,n}{d,a,n}{h,i} {j,eo,g}{ng,eo}{j,u}{s,e}{ng,yo}.'),
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    style: const TextStyle(fontSize: 34, height: 1.35, color: Colors.black, letterSpacing: 0),
                  ),
                  const SizedBox(height: 188),
                  TextField(
                    controller: _controller,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    decoration: InputDecoration(
                      hintText: K.h('{ng,ye}: {ng,i} {p,ye}{g,yo}{r,eu,l} {ng,yu}{ng,a} {ch,e}{h,eo,m}{s,e,n}{t,eo}{r,o} {h,wa,l}{ng,yo,ng}{h,a}{g,o} {s,i,p}{ng,eo}{ng,yo}.'),
                      hintStyle: const TextStyle(fontSize: 18, color: Color(0xFFA0A1A7)),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF9C9EA6)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: _primary, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 270),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _NavButton(
                        label: K.h('{ng,i}{j,eo,n} {d,a,n}{g,ye}{r,o}'),
                        icon: Icons.arrow_back,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      _NavButton(
                        label: K.h('{d,a}{ng,eu,m} {d,a,n}{g,ye}{r,o}'),
                        icon: Icons.arrow_forward,
                        primary: _hasText,
                        onPressed: _hasText
                            ? () => Navigator.of(context).pushNamed(
                                  IdeaReviewPage.routeName,
                                  arguments: IdeaEvaluationArguments(
                                    schoolId: schoolId,
                                    idea: _controller.text.trim(),
                                  ),
                                )
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 260),
                  const Divider(color: Color(0xFFD6D8E0)),
                  const SizedBox(height: 50),
                  const _Footer(),
                  const SizedBox(height: 34),
                ],
                  ),
                ),
              ),
            ),
        ],
      ),
      ),
    );
  }
}

class IdeaReviewPage extends StatefulWidget {
  const IdeaReviewPage({super.key});

  static const routeName = '/idea-review';

  @override
  State<IdeaReviewPage> createState() => _IdeaReviewPageState();
}

class _IdeaReviewPageState extends State<IdeaReviewPage> {
  static const _bg = Color(0xFFF7F8FC);
  static const _primary = Color(0xFF5661E8);

  Future<IdeaEvaluationResponse>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _load();
  }

  Future<IdeaEvaluationResponse> _load() async {
    final argument = ModalRoute.of(context)?.settings.arguments;
    if (argument is! IdeaEvaluationArguments || argument.schoolId.isEmpty) {
      throw const AiApiException(
        code: 'SCHOOL_DATA_MISSING',
        message: '학교 또는 아이디어 정보를 찾을 수 없습니다.',
      );
    }
    final school = await SchoolRepository.loadSchool(argument.schoolId);
    return AiApiService.instance.evaluateIdea(school: school, idea: argument.idea);
  }

  void _retry() => setState(() => _future = _load());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SingleChildScrollView(
        child: Stack(
          children: [
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 92,
            child: ColoredBox(color: Color(0xFFFCFDFF)),
          ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 34),
                  const _BrandHeader(),
                  const SizedBox(height: 84),
                  const _StepProgress(activeUntil: 2),
                  const SizedBox(height: 88),
                  FutureBuilder<IdeaEvaluationResponse>(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const _IdeaApiStatus.loading();
                      }
                      if (snapshot.hasError || !snapshot.hasData) {
                        return _IdeaApiStatus.error(
                          message: snapshot.error is AiApiException
                              ? (snapshot.error! as AiApiException).message
                              : '아이디어 진단 결과를 불러오지 못했습니다.',
                          onRetry: _retry,
                        );
                      }
                      return _EvaluationResult(response: snapshot.data!);
                    },
                  ),
                  const SizedBox(height: 170),
                  const Divider(color: Color(0xFFD6D8E0)),
                  const SizedBox(height: 50),
                  const _Footer(),
                  const SizedBox(height: 34),
                ],
                  ),
                ),
              ),
            ),
        ],
      ),
      ),
    );
  }
}

class _EvaluationResult extends StatelessWidget {
  const _EvaluationResult({required this.response});

  final IdeaEvaluationResponse response;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _ReviewInfoCard(
        icon: Icons.check_circle_outline,
        iconColor: const Color(0xFF4CAF78),
        title: '장점',
        titleColor: const Color(0xFF4CAF78),
        items: response.strengths,
        bulletIcon: Icons.check,
        bulletColor: const Color(0xFF4CAF78),
      ),
      _ReviewInfoCard(
        icon: Icons.warning_amber_rounded,
        iconColor: const Color(0xFFFF4E4E),
        title: '단점',
        titleColor: const Color(0xFFFF4E4E),
        items: response.weaknesses,
        bulletIcon: Icons.circle,
        bulletColor: const Color(0xFFFF4E4E),
      ),
      _ReviewInfoCard(
        icon: Icons.auto_awesome,
        iconColor: const Color(0xFF5661E8),
        title: '대안 활용모델',
        titleColor: const Color(0xFF5661E8),
        items: response.alternativeModels,
        bulletIcon: null,
        bulletColor: const Color(0xFF5661E8),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AI 진단 결과',
          style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Colors.black),
        ),
        const SizedBox(height: 42),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
          decoration: BoxDecoration(
            color: const Color(0xFFEDEDED),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            response.idea,
            style: const TextStyle(fontSize: 18, color: Color(0xFF66676D), height: 1.45, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(32, 26, 32, 26),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(9)),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 14,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 830),
                child: Text(
                  response.summary,
                  style: const TextStyle(fontSize: 18, height: 1.5, fontWeight: FontWeight.w600, color: Colors.black),
                ),
              ),
              _GradeBadge(prefix: '적합도: ', grade: response.overallGrade),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _ReviewMetricStrip(metrics: response.metrics),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 850) {
              return Column(
                children: [
                  cards[0],
                  const SizedBox(height: 18),
                  cards[1],
                  const SizedBox(height: 18),
                  cards[2],
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: cards[0]),
                const SizedBox(width: 30),
                Expanded(child: cards[1]),
                const SizedBox(width: 30),
                Expanded(child: cards[2]),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 22),
          decoration: BoxDecoration(
            color: const Color(0xFFEDEBFF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '추천: ${response.recommendation}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF5661E8), height: 1.45),
          ),
        ),
        const SizedBox(height: 44),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavButton(
              label: K.h('{ng,i}{j,eo,n} {d,a,n}{g,ye}{r,o}'),
              icon: Icons.arrow_back,
              onPressed: () => Navigator.of(context).pop(),
            ),
            _NavButton(
              label: K.h('{d,a}{ng,eu,m} {d,a,n}{g,ye}{r,o}'),
              icon: Icons.arrow_forward,
              primary: true,
              onPressed: () => Navigator.of(context).pushNamed(
                ChecklistPage.routeName,
                arguments: FinalCheckpointArguments.ideaEvaluation(
                  schoolId: response.schoolId,
                  analysisId: response.analysisId,
                  evaluation: response,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _IdeaApiStatus extends StatelessWidget {
  const _IdeaApiStatus.loading()
      : message = 'AI가 아이디어를 진단하고 있습니다.',
        onRetry = null;

  const _IdeaApiStatus.error({required this.message, required this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onRetry == null)
              const CircularProgressIndicator(color: Color(0xFF5661E8))
            else
              const Icon(Icons.error_outline, size: 42, color: Color(0xFFFF5A64)),
            const SizedBox(height: 20),
            Text(message, style: const TextStyle(fontSize: 18, color: Color(0xFF55575E))),
            if (onRetry != null) ...[
              const SizedBox(height: 22),
              FilledButton(onPressed: onRetry, child: const Text('다시 시도')),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReviewMetricStrip extends StatelessWidget {
  const _ReviewMetricStrip({required this.metrics});

  final EvaluationMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ReviewMetric(
          label: '공간 적합성',
          evaluation: metrics.spaceSuitability,
        ),
        const SizedBox(height: 6),
        _ReviewMetric(
          label: '접근성',
          evaluation: metrics.accessibility,
        ),
        const SizedBox(height: 6),
        _ReviewMetric(
          label: '지역 수요',
          evaluation: metrics.regionalDemand,
        ),
        const SizedBox(height: 6),
        _ReviewMetric(
          label: '유사사례 적합성',
          evaluation: metrics.similarCaseSuitability,
        ),
        const SizedBox(height: 6),
        _ReviewMetric(
          label: '실행 리스크',
          evaluation: metrics.executionFeasibility,
        ),
      ],
    );
  }
}

class _ReviewMetric extends StatelessWidget {
  const _ReviewMetric({
    required this.label,
    required this.evaluation,
  });

  final String label;
  final MetricEvaluation evaluation;

  @override
  Widget build(BuildContext context) {
    final reasons = evaluation.reasons.isEmpty
        ? const ['평가 이유가 제공되지 않았습니다.']
        : evaluation.reasons;
    final reasonText = reasons.join(' ');

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 76),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final labelWidget = Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF303137),
            ),
          );
          final reasonWidget = Text(
            reasonText,
            style: const TextStyle(
              fontSize: 15,
              height: 1.42,
              color: Color(0xFF5B5D65),
              fontWeight: FontWeight.w500,
            ),
          );

          if (constraints.maxWidth < 720) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: labelWidget),
                    _GradeBadge(grade: evaluation.grade),
                  ],
                ),
                const SizedBox(height: 12),
                reasonWidget,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 165, child: labelWidget),
              SizedBox(
                width: 100,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _GradeBadge(grade: evaluation.grade),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(child: reasonWidget),
            ],
          );
        },
      ),
    );
  }
}

class _GradeBadge extends StatelessWidget {
  const _GradeBadge({required this.grade, this.prefix = ''});

  final Grade grade;
  final String prefix;

  @override
  Widget build(BuildContext context) {
    final low = grade == Grade.veryLow || grade == Grade.low;
    final high = grade == Grade.high || grade == Grade.veryHigh;
    final background = low
        ? const Color(0xFFFFE3E5)
        : high
            ? const Color(0xFFE2F8EF)
            : const Color(0xFFFFF0BE);
    final foreground = low
        ? const Color(0xFFFF4E5B)
        : high
            ? const Color(0xFF00A873)
            : const Color(0xFFC06300);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(99)),
      child: Text(
        '$prefix${grade.label}',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: foreground),
      ),
    );
  }
}

class _ReviewInfoCard extends StatelessWidget {
  const _ReviewInfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.titleColor,
    required this.items,
    required this.bulletIcon,
    required this.bulletColor,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final Color titleColor;
  final List<String> items;
  final IconData? bulletIcon;
  final Color bulletColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 185),
      padding: const EdgeInsets.fromLTRB(26, 28, 26, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 21),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: titleColor),
              ),
            ],
          ),
          const SizedBox(height: 22),
          for (final item in items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (bulletIcon != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Icon(bulletIcon, color: bulletColor, size: bulletIcon == Icons.circle ? 8 : 16),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 17, height: 1.4, color: Color(0xFF222329), fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.primary = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final forward = icon == Icons.arrow_forward;

    return FilledButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!forward) Icon(icon, size: 26),
          if (!forward) const SizedBox(width: 22),
          Text(label),
          if (forward) const SizedBox(width: 32),
          if (forward) Icon(icon, size: 26),
        ],
      ),
      style: FilledButton.styleFrom(
        backgroundColor: primary ? _IdeaInputPageState._primary : Colors.white,
        foregroundColor: primary ? Colors.white : const Color(0xFF2E2F34),
        disabledBackgroundColor: Colors.white,
        disabledForegroundColor: const Color(0xFFB7B8C0),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 24,
          height: 24,
          child: Stack(
            children: [
              Positioned(left: 0, top: 0, child: ColoredBox(color: Colors.black, child: SizedBox.square(dimension: 14))),
              Positioned(right: 0, bottom: 0, child: ColoredBox(color: _IdeaInputPageState._primary, child: SizedBox.square(dimension: 14))),
            ],
          ),
        ),
        const SizedBox(width: 9),
        Text(
          K.h('{d,a}{s,i}, {h,a,g}{g,yo}'),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF11131A)),
        ),
      ],
    );
  }
}

class _StepProgress extends StatelessWidget {
  const _StepProgress({required this.activeUntil});

  final int activeUntil;

  static const steps = [
    '{p,ye}{g,yo} {s,eo,n}{t,ae,g}',
    'idea {ng,i,b}{r,yeo,g}',
    'AI {j,i,n}{d,a,n}',
    '{g,yeo,l}{g,wa}',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(steps.length, (index) {
        final active = index <= activeUntil;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == steps.length - 1 ? 0 : 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: active ? _IdeaInputPageState._primary : const Color(0xFFE3E3E5),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  K.h(steps[index]),
                  style: TextStyle(fontSize: 16, color: active ? const Color(0xFF8C8D93) : const Color(0xFFA8A9AE)),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      runSpacing: 16,
      spacing: 50,
      children: [
        Text(K.h('AI {g,i}{b,a,n} {p,ye}{g,yo} {h,wa,l}{ng,yo,ng}{g,a}{n,eu,ng}{s,eo,ng} {j,i,n}{d,a,n} service'), style: _style),
        Text(K.h('2026 {h,a,n}{d,o,ng}{d,ae} AI x {g,yeo,ng}{b,u,g} hackathon'), style: _style),
        Text(K.h('TEAM {ng,o}{h,a,b}{j,i}{j,o,l}'), style: _style),
        Text(K.h('{d,a}{s,i}, {h,a,g}{g,yo}'), style: _style),
      ],
    );
  }

  static const _style = TextStyle(fontSize: 13, color: Color(0xFF777980), fontWeight: FontWeight.w500);
}

import 'package:flutter/material.dart';

import '../data/ai_api.dart';
import '../data/school_data.dart';
import 'checklist_page.dart';
import 'landing_page.dart';

class AiRecommendationPage extends StatefulWidget {
  const AiRecommendationPage({super.key});

  static const routeName = '/ai-recommendation';

  @override
  State<AiRecommendationPage> createState() => _AiRecommendationPageState();
}

class _AiRecommendationPageState extends State<AiRecommendationPage> {
  static const _primary = Color(0xFF5661E8);
  static const _bg = Color(0xFFF7F8FC);

  int? _selected;
  Future<_RecommendationPageData>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _load();
  }

  Future<_RecommendationPageData> _load() async {
    final argument = ModalRoute.of(context)?.settings.arguments;
    if (argument is! String || argument.isEmpty) {
      throw const AiApiException(
        code: 'SCHOOL_DATA_MISSING',
        message: '선택한 학교 정보를 찾을 수 없습니다.',
      );
    }
    final school = await SchoolRepository.loadSchool(argument);
    final response = await AiApiService.instance.getRecommendations(school);
    return _RecommendationPageData(school: school, response: response);
  }

  void _retry() {
    setState(() {
      _selected = null;
      _future = _load();
    });
  }

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
                  const _StepProgress(),
                  const SizedBox(height: 88),
                  FutureBuilder<_RecommendationPageData>(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const _ApiStatusPanel.loading();
                      }
                      if (snapshot.hasError || !snapshot.hasData) {
                        return _ApiStatusPanel.error(
                          message: snapshot.error is AiApiException
                              ? (snapshot.error! as AiApiException).message
                              : '추천 결과를 불러오지 못했습니다.',
                          onRetry: _retry,
                        );
                      }
                      final data = snapshot.data!;
                      final models = data.response.recommendations;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${data.school.name}에 어울리는 활용모델 TOP 3',
                            style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Colors.black, letterSpacing: 0),
                          ),
                          const SizedBox(height: 42),
                          ...List.generate(
                            models.length,
                            (index) => Padding(
                              padding: EdgeInsets.only(bottom: index == models.length - 1 ? 0 : 22),
                              child: _RecommendationCard(
                                model: models[index],
                                selected: _selected == index,
                                onTap: () => setState(() => _selected = index),
                              ),
                            ),
                          ),
                          const SizedBox(height: 88),
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
                                primary: _selected != null,
                                onPressed: _selected == null
                                    ? null
                                    : () => Navigator.of(context).pushNamed(
                                          ChecklistPage.routeName,
                                          arguments: FinalCheckpointArguments.recommendation(
                                            schoolId: data.school.id,
                                            analysisId: data.response.analysisId,
                                            recommendation: models[_selected!],
                                          ),
                                        ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 110),
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

class _RecommendationCard extends StatefulWidget {
  const _RecommendationCard({
    required this.model,
    required this.selected,
    required this.onTap,
  });

  final RecommendationItem model;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_RecommendationCard> createState() => _RecommendationCardState();
}

class _RecommendationCardState extends State<_RecommendationCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.012 : 1,
        duration: const Duration(milliseconds: 170),
        curve: Curves.easeOutCubic,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 170),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.fromLTRB(46, 44, 46, 44),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: widget.selected ? _AiRecommendationPageState._primary : const Color(0xFFE5E6EB),
                width: widget.selected ? 2.2 : 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_hovered ? .08 : .025),
                  blurRadius: _hovered ? 26 : 12,
                  offset: Offset(0, _hovered ? 12 : 5),
                ),
              ],
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 270),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 760;
                  return compact
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _RecommendationText(model: widget.model),
                            const SizedBox(height: 24),
                            _TagColumn(model: widget.model),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(flex: 3, child: _RecommendationText(model: widget.model)),
                            const SizedBox(width: 44),
                            Expanded(flex: 2, child: _TagColumn(model: widget.model)),
                          ],
                        );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RecommendationText extends StatelessWidget {
  const _RecommendationText({required this.model});

  final RecommendationItem model;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SoftTag(text: 'Best ${model.rank}', positive: true),
        const SizedBox(height: 58),
        Text(
          model.title,
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: Colors.black),
        ),
        const SizedBox(height: 12),
        Text(
          model.description,
          style: const TextStyle(fontSize: 18, height: 1.45, color: Colors.black),
        ),
      ],
    );
  }
}

class _TagColumn extends StatelessWidget {
  const _TagColumn({required this.model});

  final RecommendationItem model;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final strength in model.strengths) ...[
          _SoftTag(text: strength, positive: true),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 14),
        for (final risk in model.risks) ...[
          _SoftTag(text: risk, positive: false),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _SoftTag extends StatelessWidget {
  const _SoftTag({required this.text, required this.positive});

  final String text;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
      decoration: BoxDecoration(
        color: positive ? const Color(0xFFF0F0FF) : const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: positive ? _AiRecommendationPageState._primary : const Color(0xFF45464B),
        ),
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
        backgroundColor: primary ? _AiRecommendationPageState._primary : Colors.white,
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
              Positioned(right: 0, bottom: 0, child: ColoredBox(color: _AiRecommendationPageState._primary, child: SizedBox.square(dimension: 14))),
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
  const _StepProgress();

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
        final active = index <= 2;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == steps.length - 1 ? 0 : 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: active ? _AiRecommendationPageState._primary : const Color(0xFFE3E3E5),
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

class _RecommendationPageData {
  const _RecommendationPageData({required this.school, required this.response});

  final SchoolData school;
  final RecommendationResponse response;
}

class _ApiStatusPanel extends StatelessWidget {
  const _ApiStatusPanel.loading()
      : message = 'AI가 활용모델을 분석하고 있습니다.',
        onRetry = null;

  const _ApiStatusPanel.error({required this.message, required this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 430,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onRetry == null)
              const CircularProgressIndicator(color: _AiRecommendationPageState._primary)
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

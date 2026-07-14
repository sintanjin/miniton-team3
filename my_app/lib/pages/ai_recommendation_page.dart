import 'package:flutter/material.dart';

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
  static const _schoolNames = [
    '{g,yeo,ng}{b,u,g} {ng,yeo,ng}{ng,ya,ng} OO{b,u,n}{g,yo}',
    '{g,yeo,ng}{b,u,g} {b,o,ng}{h,wa} OO{ch,o}{g,yo}',
    '{g,yeo,ng}{b,u,g} {ng,ui}{s,eo,ng} OO{h,a,g}{g,yo}',
  ];

  static const _models = [
    _RecommendationModel(
      rank: 'Best 1',
      title: '{j,a}{ng,yeo,n} {ch,e}{h,eo,m} · camping {g,o,ng}{g,a,n}',
      description: '{g,ye}{g,o,g}{ng,wa} {d,eu,ng}{s,a,n}{r,o}{g,a} {g,a}{kk,a}{ng,wo} {j,a}{ng,yeo,n} {ch,e}{h,eo,m} program{ng,wa} {ng,yeo,n}{g,ye}{h,a}{g,i} {j,o}{s,eu,b}{n,i}{d,a}.',
      goodOne: '{ng,u,n}{d,o,ng}{j,a,ng}{ng,eu,l} camping {g,o,ng}{g,a,n}{ng,eu}{r,o} {h,wa,l}{ng,yo,ng} {g,a}{n,eu,ng}',
      goodTwo: '{g,ye}{g,o,g} {g,wa,n}{g,wa,ng}{g,a}{ng,wa} {ng,yeo,n}{g,ye} {g,a}{n,eu,ng}',
      riskOne: '{d,ae}{j,u,ng}{g,yo}{t,o,ng} {j,eo,b}{g,eu,n}{s,eo,ng}{ng,i} {n,a,j}{ng,eu,m}',
      riskTwo: '{g,yeo}{ng,u,l}{ch,eo,l} {ng,u,n}{ng,yeo,ng} {j,e}{ng,ya,g}',
    ),
    _RecommendationModel(
      rank: 'Best 2',
      title: '{ng,yu}{ng,a} · family {ch,e}{h,eo,m}{s,e,n}{t,eo}',
      description: '{j,u}{b,yeo,n} {ng,yu}{ng,a} {ng,i,n}{g,u}{g,a} {m,a,n}{ng,a} {g,a}{j,o,g} {d,a,n}{ng,wi} {ch,e}{h,eo,m} {s,u}{ng,yo}{g,a} {ng,i,ss}{s,eu,b}{n,i}{d,a}.',
      goodOne: '{g,yo}{s,i,l}{ng,eu,l} class room{ng,eu}{r,o} {j,ae}{g,u}{s,eo,ng} {s,u}{ng,wo,l}',
      goodTwo: '{j,u}{b,yeo,n} {ng,a}{p,a}{t,eu} {d,a,n}{j,i}{ng,wa} {ng,yeo,n}{g,ye} {g,a}{n,eu,ng}',
      riskOne: '{ng,a,n}{j,eo,n} {g,wa,n}{r,i} {ng,i,n}{r,yeo,g} {p,i,l}{ng,yo}',
      riskTwo: '{s,i}{s,eo,l} {ng,i,l}{b,u} {b,o}{s,u} {p,i,l}{ng,yo}',
    ),
    _RecommendationModel(
      rank: 'Best 3',
      title: '{m,a}{ng,eu,l} creator studio',
      description: '{d,o}{s,eo}{g,wa,n}{ng,wa} {g,yo}{s,i,l}{ng,eu,l} {h,wa,l}{ng,yo,ng}{h,ae} {j,i}{ng,yeo,g} {ch,ae}{ng,yeo,n}{ng,wa} {s,o}{g,yu}{g,yu} program{ng,eu,l} {ng,u,n}{ng,yeo,ng}{h,a,l} {s,u} {ng,i,ss}{s,eu,b}{n,i}{d,a}.',
      goodOne: '{g,yo}{s,i,l} {g,o,ng}{g,a,n} {j,ae}{h,wa,l}{ng,yo,ng} {s,u}{ng,wo,l}',
      goodTwo: '{ch,eo}{ng,yeo,n} · {m,a}{ng,eu,l} {g,i}{ng,eo,b} {h,yeo,b}{ng,eo,b} {g,a}{n,eu,ng}',
      riskOne: '{ch,o}{g,i} {h,o}{b,o} {b,i}{ng,yo,ng} {p,i,l}{ng,yo}',
      riskTwo: '{j,i}{s,o,g} {ng,u,n}{ng,yeo,ng} {s,u}{ng,i,g} {g,u}{j,o} {p,i,l}{ng,yo}',
    ),
  ];

  int? _selected;

  @override
  Widget build(BuildContext context) {
    final schoolIndex = ((ModalRoute.of(context)?.settings.arguments as int?) ?? 0)
        .clamp(0, _schoolNames.length - 1)
        .toInt();

    return Scaffold(
      backgroundColor: _bg,
      body: SingleChildScrollView(
        child: Center(
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
                  Text(
                    '${K.h(_schoolNames[schoolIndex])}${K.h('{ng,e} {ng,eo}{ng,u,l}{r,i}{n,eu,n} {h,wa,l}{ng,yo,ng}{m,o}{d,e,l} TOP 3')}',
                    style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Colors.black, letterSpacing: 0),
                  ),
                  const SizedBox(height: 42),
                  ...List.generate(
                    _models.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(bottom: index == _models.length - 1 ? 0 : 22),
                      child: _RecommendationCard(
                        model: _models[index],
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
                            : () => Navigator.of(context).pushNamed(ChecklistPage.routeName),
                      ),
                    ],
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

  final _RecommendationModel model;
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
            constraints: const BoxConstraints(minHeight: 270),
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
    );
  }
}

class _RecommendationText extends StatelessWidget {
  const _RecommendationText({required this.model});

  final _RecommendationModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SoftTag(text: model.rank, positive: true),
        const SizedBox(height: 58),
        Text(
          K.h(model.title),
          style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: Colors.black),
        ),
        const SizedBox(height: 12),
        Text(
          K.h(model.description),
          style: const TextStyle(fontSize: 18, height: 1.45, color: Colors.black),
        ),
      ],
    );
  }
}

class _TagColumn extends StatelessWidget {
  const _TagColumn({required this.model});

  final _RecommendationModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SoftTag(text: K.h(model.goodOne), positive: true),
        const SizedBox(height: 10),
        _SoftTag(text: K.h(model.goodTwo), positive: true),
        const SizedBox(height: 24),
        _SoftTag(text: K.h(model.riskOne), positive: false),
        const SizedBox(height: 10),
        _SoftTag(text: K.h(model.riskTwo), positive: false),
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

class _RecommendationModel {
  const _RecommendationModel({
    required this.rank,
    required this.title,
    required this.description,
    required this.goodOne,
    required this.goodTwo,
    required this.riskOne,
    required this.riskTwo,
  });

  final String rank;
  final String title;
  final String description;
  final String goodOne;
  final String goodTwo;
  final String riskOne;
  final String riskTwo;
}

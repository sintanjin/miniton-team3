import 'package:flutter/material.dart';

import 'ai_recommendation_page.dart';
import 'idea_input_page.dart';
import 'landing_page.dart';

class IdeaPage extends StatefulWidget {
  const IdeaPage({super.key});

  static const routeName = '/idea';

  @override
  State<IdeaPage> createState() => _IdeaPageState();
}

class _IdeaPageState extends State<IdeaPage> {
  static const _primary = Color(0xFF5661E8);
  static const _bg = Color(0xFFF7F8FC);
  static const _schoolNames = [
    '{g,yeo,ng}{b,u,g} {ng,yeo,ng}{ng,ya,ng} OO{b,u,n}{g,yo}',
    '{g,yeo,ng}{b,u,g} {b,o,ng}{h,wa} OO{ch,o}{g,yo}',
    '{g,yeo,ng}{b,u,g} {ng,ui}{s,eo,ng} OO{h,a,g}{g,yo}',
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
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${K.h(_schoolNames[schoolIndex])}\n',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        TextSpan(
                          text: K.h('{h,wa,l}{ng,yo,ng}{h,a}{g,o}{j,a} {h,a}{n,eu,n} idea{g,a} {ng,i,ss}{ng,eu}{s,i,n}{g,a}{ng,yo}?'),
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    style: const TextStyle(fontSize: 34, height: 1.35, color: Colors.black, letterSpacing: 0),
                  ),
                  const SizedBox(height: 148),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final compact = constraints.maxWidth < 820;
                      final cards = [
                        _IdeaChoiceCard(
                          selected: _selected == 0,
                          badge: K.h('AI{ng,e}{g,e} {ch,u}{ch,eo,n}{b,a,d}{g,i}'),
                          title: K.h('idea{g,a} {ng,eo,bs}{ng,eo}{ng,yo}'),
                          description: K.h('{ng,i} {p,ye}{g,yo}{ng,e} {ng,eo}{ng,u,l}{r,i}{n,eu,n} {h,wa,l}{ng,yo,ng}{m,o}{d,e,l}{ng,eu,l} {ch,u}{ch,eo,n}{b,a,d}{ng,a} {b,o}{s,e}{ng,yo}.'),
                          onTap: () => setState(() => _selected = 0),
                        ),
                        _IdeaChoiceCard(
                          selected: _selected == 1,
                          badge: K.h('{n,ae}{g,a} {j,i,g}{j,eo,b} {ss,eu}{g,i}'),
                          title: K.h('idea{g,a} {ng,i,ss}{ng,eo}{ng,yo}'),
                          description: K.h('{n,ae} idea{g,a} {ng,i} {p,ye}{g,yo}{ng,e} {j,eo,g}{h,a,b}{h,a,n}{j,i} {h,wa,g}{ng,i,n}{h,ae} {b,o}{s,e}{ng,yo}.'),
                          onTap: () => setState(() => _selected = 1),
                        ),
                      ];

                      return compact
                          ? Column(
                              children: [
                                cards[0],
                                const SizedBox(height: 24),
                                cards[1],
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(child: cards[0]),
                                const SizedBox(width: 32),
                                Expanded(child: cards[1]),
                              ],
                            );
                    },
                  ),
                  const SizedBox(height: 158),
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
                            : () {
                                Navigator.of(context).pushNamed(
                                  _selected == 0
                                      ? AiRecommendationPage.routeName
                                      : IdeaInputPage.routeName,
                                  arguments: schoolIndex,
                                );
                              },
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
      ),
    );
  }
}

class _IdeaChoiceCard extends StatefulWidget {
  const _IdeaChoiceCard({
    required this.selected,
    required this.badge,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final bool selected;
  final String badge;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  State<_IdeaChoiceCard> createState() => _IdeaChoiceCardState();
}

class _IdeaChoiceCardState extends State<_IdeaChoiceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.025 : 1,
        duration: const Duration(milliseconds: 170),
        curve: Curves.easeOutCubic,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 170),
            curve: Curves.easeOutCubic,
            height: 220,
            padding: const EdgeInsets.fromLTRB(36, 26, 36, 28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: widget.selected ? _IdeaPageState._primary : const Color(0xFFE4E5EA),
                width: widget.selected ? 3 : 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_hovered ? .10 : .03),
                  blurRadius: _hovered ? 24 : 12,
                  offset: Offset(0, _hovered ? 12 : 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0FF),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    widget.badge,
                    style: const TextStyle(color: _IdeaPageState._primary, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  widget.title,
                  style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: Colors.black),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.description,
                  style: const TextStyle(fontSize: 17, height: 1.45, color: Colors.black),
                ),
              ],
            ),
          ),
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
        backgroundColor: primary ? _IdeaPageState._primary : Colors.white,
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
              Positioned(right: 0, bottom: 0, child: ColoredBox(color: _IdeaPageState._primary, child: SizedBox.square(dimension: 14))),
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
        final active = index <= 1;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == steps.length - 1 ? 0 : 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: active ? _IdeaPageState._primary : const Color(0xFFE3E3E5),
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

import 'package:flutter/material.dart';

import 'landing_page.dart';
import 'school_detail_page.dart';

class SchoolSelectionPage extends StatelessWidget {
  const SchoolSelectionPage({super.key});

  static const routeName = '/school-selection';
  static const _primary = Color(0xFF5661E8);
  static const _ink = Color(0xFF11131A);
  static const _bg = Color(0xFFF7F8FC);

  static const _schools = [
    _SchoolCandidate(
      image: 'assets/images/candidate_01.jpg',
      name: '{g,yeo,ng}{b,u,g} {ng,yeo,ng}{ng,ya,ng} OO{b,u,n}{g,yo}',
      chipOne: '{s,a,n}{g,a,n}, {g,ye}{g,o,g} {j,i}{ng,yeo,g}',
      chipTwo: '{d,ae}{j,i} 3,200m²',
      note: '{g,u}{j,o} {ng,ya,ng}{h,o}, {ng,o,g}{s,a,ng} {ng,i,l}{b,u} {s,u}{r,i} {p,i,l}{ng,yo}',
    ),
    _SchoolCandidate(
      image: 'assets/images/candidate_02.png',
      name: '{g,yeo,ng}{b,u,g} {b,o,ng}{h,wa} OO{ch,o}{g,yo}',
      chipOne: '{s,a,n}{r,i,m} {ng,i,n}{j,eo,b}',
      chipTwo: '{g,yo}{s,i,l} 8{g,ae}',
      note: '{ng,u,n}{d,o,ng}{j,a,ng} {h,wa,l}{ng,yo,ng}{s,eo,ng} {n,o,b}{ng,eu,m}',
    ),
    _SchoolCandidate(
      image: 'assets/images/candidate_03.png',
      name: '{g,yeo,ng}{b,u,g} {ng,ui}{s,eo,ng} OO{h,a,g}{g,yo}',
      chipOne: '{m,a}{ng,eu,l} {j,u,ng}{s,i,m}{j,i}',
      chipTwo: '{d,ae}{j,i} 2,650m²',
      note: '{j,eo,b}{g,eu,n}{s,eo,ng} {ng,ya,ng}{h,o}, {ng,o,g}{ng,oe} {s,u}{r,i} {g,wo,n}{j,a,ng}',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SelectionArea(
        child: SingleChildScrollView(
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
                    const _IntroText(),
                    const SizedBox(height: 92),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final compact = constraints.maxWidth < 900;
                        return compact
                            ? Column(
                                children: [
                                  _CandidateCard(index: 0, candidate: _schools[0]),
                                  const SizedBox(height: 28),
                                  _CandidateCard(index: 1, candidate: _schools[1]),
                                  const SizedBox(height: 28),
                                  _CandidateCard(index: 2, candidate: _schools[2]),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(child: _CandidateCard(index: 0, candidate: _schools[0])),
                                  const SizedBox(width: 48),
                                  Expanded(child: _CandidateCard(index: 1, candidate: _schools[1])),
                                  const SizedBox(width: 48),
                                  Expanded(child: _CandidateCard(index: 2, candidate: _schools[2])),
                                ],
                              );
                      },
                    ),
                    const SizedBox(height: 210),
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
              Positioned(right: 0, bottom: 0, child: ColoredBox(color: SchoolSelectionPage._primary, child: SizedBox.square(dimension: 14))),
            ],
          ),
        ),
        const SizedBox(width: 9),
        Text(
          K.h('{d,a}{s,i}, {h,a,g}{g,yo}'),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: SchoolSelectionPage._ink),
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
        final active = index == 0;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == steps.length - 1 ? 0 : 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: active ? SchoolSelectionPage._primary : const Color(0xFFE3E3E5),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  K.h(steps[index]),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: active ? const Color(0xFF8C8D93) : const Color(0xFFA8A9AE),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _IntroText extends StatelessWidget {
  const _IntroText();

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '${K.h('{h,wa,n}{ng,yeo,ng}{h,a,b}{n,i}{d,a}!')}\n',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          TextSpan(
            text: K.h('{h,wa,l}{ng,yo,ng}{h,a}{g,o}{j,a} {h,a}{n,eu,n} {p,ye}{g,yo}{r,eu,l} {s,eo,n}{t,ae,g}{h,ae} {j,u}{s,e}{ng,yo}.'),
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ],
      ),
      style: const TextStyle(fontSize: 34, height: 1.35, color: Colors.black, letterSpacing: 0),
    );
  }
}

class _CandidateCard extends StatefulWidget {
  const _CandidateCard({required this.index, required this.candidate});

  final int index;
  final _SchoolCandidate candidate;

  @override
  State<_CandidateCard> createState() => _CandidateCardState();
}

class _CandidateCardState extends State<_CandidateCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.035 : 1,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
            SchoolDetailPage.routeName,
            arguments: widget.index,
          ),
          child: AspectRatio(
            aspectRatio: 1.02,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(_hovered ? .22 : .15),
                    blurRadius: _hovered ? 30 : 22,
                    offset: Offset(0, _hovered ? 18 : 12),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(widget.candidate.image, fit: BoxFit.cover),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0x11000000), Color(0xAA000000)],
                          stops: [.35, .58, 1],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25, 0, 25, 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            K.h(widget.candidate.name),
                            style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 17),
                          Wrap(
                            spacing: 12,
                            runSpacing: 9,
                            children: [
                              _ChipLabel(text: K.h(widget.candidate.chipOne)),
                              _ChipLabel(text: K.h(widget.candidate.chipTwo)),
                            ],
                          ),
                          const SizedBox(height: 19),
                          Text(
                            K.h(widget.candidate.note),
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChipLabel extends StatelessWidget {
  const _ChipLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.92),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(color: SchoolSelectionPage._primary, fontSize: 14, fontWeight: FontWeight.w600),
      ),
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

class _SchoolCandidate {
  const _SchoolCandidate({
    required this.image,
    required this.name,
    required this.chipOne,
    required this.chipTwo,
    required this.note,
  });

  final String image;
  final String name;
  final String chipOne;
  final String chipTwo;
  final String note;
}

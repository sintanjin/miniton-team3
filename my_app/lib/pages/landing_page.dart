import 'dart:ui';

import 'package:flutter/material.dart';

import 'school_selection_page.dart';

class K {
  const K._();

  static const _leading = {
    'g': 0,
    'kk': 1,
    'n': 2,
    'd': 3,
    'tt': 4,
    'r': 5,
    'm': 6,
    'b': 7,
    'pp': 8,
    's': 9,
    'ss': 10,
    'ng': 11,
    'j': 12,
    'jj': 13,
    'ch': 14,
    'k': 15,
    't': 16,
    'p': 17,
    'h': 18,
  };

  static const _vowel = {
    'a': 0,
    'ae': 1,
    'ya': 2,
    'yae': 3,
    'eo': 4,
    'e': 5,
    'yeo': 6,
    'ye': 7,
    'o': 8,
    'wa': 9,
    'wae': 10,
    'oe': 11,
    'yo': 12,
    'u': 13,
    'wo': 14,
    'we': 15,
    'wi': 16,
    'yu': 17,
    'eu': 18,
    'ui': 19,
    'i': 20,
  };

  static const _trail = {
    '': 0,
    'g': 1,
    'kk': 2,
    'gs': 3,
    'n': 4,
    'nj': 5,
    'nh': 6,
    'd': 7,
    'l': 8,
    'lg': 9,
    'lm': 10,
    'lb': 11,
    'ls': 12,
    'lt': 13,
    'lp': 14,
    'lh': 15,
    'm': 16,
    'b': 17,
    'bs': 18,
    's': 19,
    'ss': 20,
    'ng': 21,
    'j': 22,
    'ch': 23,
    'k': 24,
    't': 25,
    'p': 26,
    'h': 27,
  };

  static String h(String source) {
    return source.replaceAllMapped(RegExp(r'\{([^}]+)\}'), (match) {
      final parts = match.group(1)!.split(',');
      final leading = _leading[parts[0]]!;
      final vowel = _vowel[parts[1]]!;
      final trail = _trail[parts.length > 2 ? parts[2] : '']!;
      return String.fromCharCode(0xAC00 + ((leading * 21) + vowel) * 28 + trail);
    });
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  static const routeName = '/landing';
  static const _primary = Color(0xFF5661E8);
  static const _ink = Color(0xFF171927);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SelectionArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _HeroSection(),
              _HelpSection(),
              _ProcessSection(),
              _Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageWidth extends StatelessWidget {
  const _PageWidth({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1120),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: child,
        ),
      ),
    );
  }
}

class _DotPattern extends StatelessWidget {
  const _DotPattern({this.opacity = .15});

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _DotPainter(opacity),
        size: Size.infinite,
      ),
    );
  }
}

class _DotPainter extends CustomPainter {
  const _DotPainter(this.opacity);

  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = LandingPage._primary.withOpacity(opacity);
    for (double y = 10; y < size.height; y += 18) {
      for (double x = 10; x < size.width; x += 18) {
        canvas.drawCircle(Offset(x, y), 1.1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotPainter oldDelegate) {
    return oldDelegate.opacity != opacity;
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _SquareMark(size: 23, block: 14),
        const SizedBox(width: 9),
        Text(
          K.h('{d,a}{s,i}, {h,a,g}{g,yo}'),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: LandingPage._ink,
          ),
        ),
      ],
    );
  }
}

class _SquareMark extends StatelessWidget {
  const _SquareMark({required this.size, required this.block});

  final double size;
  final double block;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: ColoredBox(
              color: Colors.black,
              child: SizedBox.square(dimension: block),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: ColoredBox(
              color: LandingPage._primary,
              child: SizedBox.square(dimension: block),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 820;

    return Stack(
      children: [
        Positioned.fill(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Image.asset(
              'assets/images/school_background.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned.fill(
          child: ColoredBox(
            color: const Color(0xFFF7F9FF).withOpacity(.84),
          ),
        ),
        const Positioned.fill(child: _DotPattern(opacity: .11)),
        _PageWidth(
          child: SizedBox(
            height: compact ? 900 : 690,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                const _Brand(),
                const Spacer(),
                if (compact)
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeroCopy(),
                      SizedBox(height: 44),
                      Center(child: _AnalysisCard()),
                    ],
                  )
                else
                  const Row(
                    children: [
                      Expanded(flex: 9, child: _HeroCopy()),
                      SizedBox(width: 54),
                      Expanded(flex: 11, child: _AnalysisCard()),
                    ],
                  ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SquareMark(size: 38, block: 25),
        const SizedBox(height: 28),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: K.h('{p,ye}{g,yo}{ng,e} ')),
              TextSpan(
                text: K.h('{s,ae}{r,o}{ng,u,n} {g,a}{n,eu,ng}{s,eo,ng}'),
                style: const TextStyle(color: LandingPage._primary),
              ),
              TextSpan(text: K.h('{ng,eu,l}')),
            ],
          ),
          style: const TextStyle(
            fontSize: 35,
            height: 1.25,
            fontWeight: FontWeight.w800,
            color: LandingPage._ink,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 21),
        Text(
          K.h(
            'AI{g,a} {g,o,ng}{g,a,n}, {j,i}{ng,yeo,g}, {ng,i,n}{g,u}, '
            '{s,i}{s,eo,l} data{r,eu,l} {b,u,n}{s,eo,g}{h,a}{ng,yeo}\n'
            '{ch,oe}{j,eo,g}{ng,ui} {h,wa,l}{ng,yo,ng}{m,o}{d,e,l}{ng,eu,l} '
            '{j,e}{ng,a,n}{h,a,b}{n,i}{d,a}.',
          ),
          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Color(0xFF3B3D49),
          ),
        ),
        const SizedBox(height: 38),
        const _PrimaryButton(),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton();

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () => Navigator.of(context).pushNamed(SchoolSelectionPage.routeName),
      style: FilledButton.styleFrom(
        backgroundColor: LandingPage._primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(K.h('AI {j,i,n}{d,a,n} {s,i}{j,a,g}{h,a}{g,i}')),
          const SizedBox(width: 24),
          const Icon(Icons.arrow_forward, size: 20),
        ],
      ),
    );
  }
}

class _AnalysisCard extends StatelessWidget {
  const _AnalysisCard();

  static const rows = [
    ('{g,o,ng}{g,a,n} {b,u,n}{s,eo,g}', '{g,yo}{s,i,l}, {ng,u,n}{d,o,ng}{j,a,ng}, {b,u}{j,i} {h,wa,l}{ng,yo,ng}{d,o} {p,yeo,ng}{g,a}'),
    ('{j,i}{ng,yeo,g} {b,u,n}{s,eo,g}', '{ng,i,n}{g,u}, {j,eo,b}{g,eu,n}{s,eo,ng}, {j,u}{b,yeo,n} {j,a}{ng,wo,n} {b,u,n}{s,eo,g}'),
    ('{s,u}{ng,yo} {b,u,n}{s,eo,g}', '{j,i}{ng,yeo,g} {s,u}{ng,yo}{ng,wa} {ng,yu}{s,a} {s,a}{r,ye} {b,u,n}{s,eo,g}'),
    ('{s,i}{s,eo,l} {b,u,n}{s,eo,g}', '{g,eo,n}{m,u,l} {s,a,ng}{t,ae}, remodeling {p,i,l}{ng,yo}{d,o} {p,yeo,ng}{g,a}'),
    ('{j,o,ng}{h,a,b} {j,i,n}{d,a,n}', '{h,wa,l}{ng,yo,ng}{m,o}{d,e,l} {ch,u}{ch,eo,n} {m,i,ch} {s,i,l}{h,ae,ng} checklist'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 510),
      padding: const EdgeInsets.fromLTRB(26, 27, 26, 22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5C6380).withOpacity(.12),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const _IconTile(icon: Icons.auto_awesome, size: 34, iconSize: 18),
              const SizedBox(width: 12),
              Text(
                K.h('AI {b,u,n}{s,eo,g} {h,a,n}{n,u,n}{ng,e} {b,o}{g,i}'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...List.generate(
            rows.length,
            (index) => Container(
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFE8E9EF))),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 36,
                    child: Text(
                      '${index + 1}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: LandingPage._primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          K.h(rows[index].$1),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          K.h(rows[index].$2),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF5B5D67),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F0FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          K.h('{b,u,n}{s,eo,g} {ng,wa,n}{r,yo}'),
                          style: const TextStyle(fontSize: 11, color: LandingPage._primary),
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.check, size: 13, color: LandingPage._primary),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.auto_awesome, size: 18, color: LandingPage._primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  K.h('1{b,u,n}{ng,i}{m,yeo,n} {j,eo,g}{h,a,b}{h,a,n} {p,ye}{g,yo} {h,wa,l}{ng,yo,ng} {b,a,ng}{ng,a,n}{ng,eu,l} {h,wa,g}{ng,i,n}{h,a,l} {s,u} {ng,i,ss}{ng,eo}{ng,yo}!'),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HelpSection extends StatelessWidget {
  const _HelpSection();

  static const features = [
    _Feature(
      icon: Icons.auto_awesome,
      tint: Color(0xFFEEF0FF),
      color: LandingPage._primary,
      title: 'AI {h,wa,l}{ng,yo,ng}{m,o}{d,e,l} {ch,u}{ch,eo,n}',
      body: '{j,i}{ng,yeo,g} {t,eu,g}{s,eo,ng}{ng,e} {m,a,j}{n,eu,n}\n{ch,oe}{j,eo,g}{ng,ui} {h,wa,l}{ng,yo,ng}{m,o}{d,e,l}{ng,eu,l} {ch,u}{ch,eo,n}{h,a,b}{n,i}{d,a}.',
    ),
    _Feature(
      icon: Icons.bar_chart,
      tint: Color(0xFFE5F6FF),
      color: Color(0xFF2A9ADB),
      title: '{s,i,l}{h,ae,ng} {g,a}{n,eu,ng}{s,eo,ng} {b,u,n}{s,eo,g}',
      body: '{g,o,ng}{g,a,n}, {s,u}{ng,yo}, {s,i}{s,eo,l}, {j,a}{ng,wo,n} data{r,o}\n{s,i,l}{h,ae,ng} {g,a}{n,eu,ng}{s,eo,ng}{ng,eu,l} {b,u,n}{s,eo,g}{h,a,b}{n,i}{d,a}.',
    ),
    _Feature(
      icon: Icons.checklist,
      tint: Color(0xFFEAF8F7),
      color: Color(0xFF3C9995),
      title: 'checklist {j,e}{g,o,ng}',
      body: '{h,ae,ng}{j,eo,ng}, {s,i}{s,eo,l}, {ng,ye}{s,a,n}, {s,u}{ng,yo}, {ng,u,n}{ng,yeo,ng} {d,eu,ng}\n{s,i,l}{h,ae,ng} {j,eo,n} {h,wa,g}{ng,i,n} {s,a}{h,a,ng}{ng,eu,l} {j,e}{g,o,ng}{h,a,b}{n,i}{d,a}.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F9FF),
      padding: const EdgeInsets.symmetric(vertical: 105),
      child: _PageWidth(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.auto_awesome, size: 15, color: LandingPage._primary),
                  const SizedBox(width: 8),
                  Text(
                    K.h('AI {g,i}{b,a,n} {p,ye}{g,yo} {h,wa,l}{ng,yo,ng}{g,a}{n,eu,ng}{s,eo,ng} {j,i,n}{d,a,n} service'),
                    style: const TextStyle(fontSize: 12, color: LandingPage._primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 23),
            Text(
              K.h('{ng,i}{r,eo,h}{g,e} {d,o}{ng,wa}{d,eu}{r,yeo}{ng,yo}'),
              style: const TextStyle(
                fontSize: 33,
                fontWeight: FontWeight.w800,
                color: LandingPage._ink,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 17),
            Text(
              K.h('{h,wa,l}{ng,yo,ng} {g,a}{n,eu,ng}{h,a,n} idea{b,u}{t,eo} {s,i,l}{h,ae,ng} {j,eo,n} checklist{kk,a}{j,i}, {p,a,n}{d,a,n}{ng,e} {p,i,l}{ng,yo}{h,a,n} {g,eo,s}{m,a,n} {d,a,m}{ng,a,ss}{s,eu,b}{n,i}{d,a}.'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: LandingPage._primary),
            ),
            const SizedBox(height: 64),
            LayoutBuilder(
              builder: (context, constraints) {
                final vertical = constraints.maxWidth < 760;
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(.05),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: vertical
                      ? Column(
                          children: [
                            features[0],
                            const Divider(height: 35),
                            features[1],
                            const Divider(height: 35),
                            features[2],
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(child: features[0]),
                            const VerticalDivider(),
                            Expanded(child: features[1]),
                            const VerticalDivider(),
                            Expanded(child: features[2]),
                          ],
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({
    required this.icon,
    this.size = 50,
    this.iconSize = 27,
    this.tint = const Color(0xFFEEF0FF),
    this.color = LandingPage._primary,
  });

  final IconData icon;
  final double size;
  final double iconSize;
  final Color tint;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: tint, borderRadius: BorderRadius.circular(9)),
      child: Icon(icon, size: iconSize, color: color),
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature({
    required this.icon,
    required this.tint,
    required this.color,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color tint;
  final Color color;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _IconTile(icon: icon, tint: tint, color: color),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(K.h(title), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 7),
                Text(
                  K.h(body),
                  style: const TextStyle(fontSize: 12, height: 1.5, color: Color(0xFF676A75)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcessSection extends StatelessWidget {
  const _ProcessSection();

  static const steps = [
    ('{p,ye}{g,yo} {s,eo,n}{t,ae,g}', '{h,a,g}{g,yo}{r,eu,l} {s,eo,n}{t,ae,g}{h,a,b}{n,i}{d,a}. {ng,wi}{ch,i} {m,yeo,n}{j,eo,g}{ng,eu,l} {j,i,g}{j,eo,b} {ng,i,b}{r,yeo,g}{h,a,l} {p,i,l}{ng,yo}{g,a} {ng,eo,bs}{s,eu,b}{n,i}{d,a}.'),
    ('idea {ng,i,b}{r,yeo,g}', '{ng,i}{m,i} {g,u}{s,a,ng} {j,u,ng}{ng,i,n} idea{g,a} {ng,i,ss}{ng,eu}{m,yeo,n} {h,a,n} {m,u,n}{j,a,ng}{ng,eu}{r,o} {ng,i,b}{r,yeo,g}{h,a}{g,o}, {ng,eo,bs}{ng,eu}{m,yeo,n} {ch,u}{ch,eo,n}{ng,eu,l} {b,a,d}{s,eu,b}{n,i}{d,a}.'),
    ('AI data {b,u,n}{s,eo,g} {m,i,ch} {j,i,n}{d,a,n}', '{g,o,ng}{g,a,n} {j,o}{g,eo,n}, {j,eo,b}{g,eu,n}{s,eo,ng}, {j,u}{b,yeo,n} {j,a}{ng,wo,n}, {ng,ye}{s,a,ng} {s,u}{ng,yo}{r,eu,l} {j,o,ng}{h,a,b}{h,ae} {h,wa,l}{ng,yo,ng}{m,o}{d,e,l} {tt,o}{n,eu,n} idea {j,eo,g}{h,a,b}{s,eo,ng}{ng,eu,l} {j,i,n}{d,a,n}{h,a,b}{n,i}{d,a}.'),
    ('{g,yeo,l}{g,wa} {m,i,ch} checklist {j,e}{g,o,ng}', '{s,i,l}{h,ae,ng} {j,eo,n} {h,wa,g}{ng,i,n}{h,ae}{ng,ya} {h,a,l} {s,a}{h,a,ng}{ng,eu,l} checklist{r,o} {j,e}{g,o,ng}{h,a,b}{n,i}{d,a}.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9FAFE),
      padding: const EdgeInsets.fromLTRB(0, 125, 0, 115),
      child: _PageWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              K.h('AI {j,i,n}{d,a,n} process'),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: LandingPage._ink,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 58),
            Stack(
              children: [
                const Positioned.fill(child: _DotPattern(opacity: .1)),
                Column(
                  children: List.generate(
                    steps.length,
                    (index) => Container(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black.withOpacity(.09)),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F0FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                                color: LandingPage._primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 42),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  K.h(steps[index].$1),
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  K.h(steps[index].$2),
                                  style: const TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF555762)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 66),
            const Center(child: _PrimaryButton()),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 34),
      child: _PageWidth(
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          runSpacing: 14,
          spacing: 34,
          children: [
            Text(K.h('AI {g,i}{b,a,n} {p,ye}{g,yo} {h,wa,l}{ng,yo,ng}{g,a}{n,eu,ng}{s,eo,ng} {j,i,n}{d,a,n} service'), style: _footerStyle),
            Text(K.h('2026 {h,a,n}{d,o,ng}{d,ae} AI x {j,eo,ng}{ch,ae,g} hackathon'), style: _footerStyle),
            Text(K.h('TEAM {ng,o}{h,a,b}{j,i}{j,o,l}'), style: _footerStyle),
            Text(K.h('{d,a}{s,i}, {h,a,g}{g,yo}'), style: _footerStyle),
          ],
        ),
      ),
    );
  }

  static const _footerStyle = TextStyle(fontSize: 11, color: Color(0xFF888B95));
}

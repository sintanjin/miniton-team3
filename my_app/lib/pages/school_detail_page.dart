import 'package:flutter/material.dart';

import 'idea_page.dart';
import 'landing_page.dart';

class SchoolDetailPage extends StatelessWidget {
  const SchoolDetailPage({super.key});

  static const routeName = '/school-detail';
  static const _primary = Color(0xFF5661E8);
  static const _bg = Color(0xFFF7F8FC);

  static const _details = [
    _SchoolDetail(
      image: 'assets/images/candidate_01.jpg',
      name: '{g,yeo,ng}{b,u,g} {ng,yeo,ng}{ng,ya,ng} OO{b,u,n}{g,yo}',
      size: '{d,ae}{j,i} 4,500m2 - {g,yo}{s,i,l} 8{s,i,l} - {g,a,ng}{d,a,ng} {b,o}{ng,yu}',
      condition: '{b,i}{g,yo}{j,eo,g} {s,i,n}{ch,u,g} - {ng,yu}{j,i}{g,wa,n}{r,i} {ng,ya,ng}{h,o}',
      facility: '{j,eo,n}{g,i} - {h,wa}{j,a,ng}{s,i,l} {ng,ya,ng}{h,o} - {n,ae,ng}{n,a,n}{b,a,ng} {s,eo,l}{b,i} {b,o}{ng,yu}',
      access: '{g,u,g}{d,o} {ng,i,n}{j,eo,b} - {d,ae}{j,u,ng}{g,yo}{t,o,ng} {h,a}{r,u} 8{h,oe}',
      resource: '{h,ae}{s,u}{ng,yo,g}{j,a,ng}, {g,wa,n}{g,wa,ng}{d,a,n}{j,i}, {h,a,g}{ng,wo,n}{g,a} {ng,i,n}{j,eo,b}',
      demand: '{j,u}{b,yeo,n} {ng,a}{p,a}{t,eu} {d,a,n}{j,i} - {ng,yu}{ng,a} {ng,i,n}{g,u} {d,a}{s,u}',
    ),
    _SchoolDetail(
      image: 'assets/images/candidate_02.png',
      name: '{g,yeo,ng}{b,u,g} {b,o,ng}{h,wa} OO{ch,o}{g,yo}',
      size: '{d,ae}{j,i} 3,100m2 - {g,yo}{s,i,l} 6{s,i,l} - {ng,u,n}{d,o,ng}{j,a,ng} {b,o}{ng,yu}',
      condition: '{ng,oe}{g,wa,n} {n,o}{h,u} - {ng,o,g}{s,a,ng} {m,i,ch} {ch,a,ng}{h,o} {s,u}{r,i} {p,i,l}{ng,yo}',
      facility: '{j,eo,n}{g,i} {ng,ya,ng}{h,o} - {h,wa}{j,a,ng}{s,i,l} {ng,i,l}{b,u} {g,ae}{s,eo,n} {p,i,l}{ng,yo}',
      access: '{m,a}{ng,eu,l}{b,eo}{s,eu} {j,eo,ng}{r,yu}{j,a,ng} {ng,i,n}{j,eo,b} - {s,a,n}{r,i,m} {j,i,n}{ng,i,b} {s,u}{ng,wo,l}',
      resource: '{s,a,n}{ch,ae,g}{r,o}, {g,u,n}{m,i,n} {ch,ae}{ng,yu,g}{s,i}{s,eo,l}, {j,i}{ng,yeo,g} {n,o,ng}{s,a,n}{m,u,l}',
      demand: '{ch,e}{h,eo,m} {g,yo}{ng,yu,g} - {j,u}{m,a,l} {g,a}{j,o,g} program {s,u}{ng,yo}',
    ),
    _SchoolDetail(
      image: 'assets/images/candidate_03.png',
      name: '{g,yeo,ng}{b,u,g} {ng,ui}{s,eo,ng} OO{h,a,g}{g,yo}',
      size: '{d,ae}{j,i} 2,650m2 - {g,yo}{s,i,l} 5{s,i,l} - {d,o}{s,eo}{g,wa,n} {b,o}{ng,yu}',
      condition: '{g,u}{j,o} {ng,ya,ng}{h,o} - {ng,oe}{b,u} {d,e}{k,eu} {j,ae}{j,eo,ng}{b,i} {p,i,l}{ng,yo}',
      facility: '{j,eo,n}{g,i} {b,o}{t,o,ng} - {h,wa}{j,a,ng}{s,i,l} {ng,ya,ng}{h,o} - {ch,wi}{s,a}{s,i}{s,eo,l} {b,o}{ng,yu}',
      access: '{m,a}{ng,eu,l} {j,u,ng}{s,i,m}{j,i} - {g,u,n}{ch,eo,ng} {ch,a}{r,ya,ng} 10{b,u,n}',
      resource: '{m,a}{ng,eu,l}{h,oe}{g,wa,n}, {j,e}{b,a,ng}{j,a}{ch,i}{d,a,n}{ch,e}, {j,ae}{r,ae}{s,i}{j,a,ng}',
      demand: '{ng,o}{r,eu}{s,i,n} {d,o,l}{b,o,m} - {m,a}{ng,eu,l} {g,o,ng}{d,o,ng}{ch,e} {g,o,ng}{g,a,n} {s,u}{ng,yo}',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final index = (ModalRoute.of(context)?.settings.arguments as int?) ?? 0;
    final safeIndex = index.clamp(0, _details.length - 1).toInt();
    final detail = _details[safeIndex];

    return Scaffold(
      backgroundColor: _bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _Header(detail: detail),
            _ImageStage(schoolIndex: safeIndex, detail: detail),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 58, 28, 34),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Column(
                  children: const [
                    Divider(color: Color(0xFFD6D8E0)),
                    SizedBox(height: 50),
                    _Footer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.detail});

  final _SchoolDetail detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SchoolDetailPage._bg,
      padding: const EdgeInsets.fromLTRB(28, 34, 28, 42),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _BrandHeader(),
              const SizedBox(height: 84),
              const _StepProgress(),
              const SizedBox(height: 88),
              Text(
                K.h(detail.name),
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800, letterSpacing: 0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageStage extends StatelessWidget {
  const _ImageStage({required this.schoolIndex, required this.detail});

  final int schoolIndex;
  final _SchoolDetail detail;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 720,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(detail.image, fit: BoxFit.cover),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 245,
              color: Colors.black.withOpacity(.56),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: _InfoGrid(detail: detail),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 310,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Row(
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
                          IdeaPage.routeName,
                          arguments: schoolIndex,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.detail});

  final _SchoolDetail detail;

  @override
  Widget build(BuildContext context) {
    final items = [
      (K.h('{g,yu}{m,o}'), K.h(detail.size)),
      (K.h('{s,i}{s,eo,l} {s,a,ng}{t,ae}'), K.h(detail.condition)),
      (K.h('{s,i}{s,eo,l} {s,e}{b,u}'), K.h(detail.facility)),
      (K.h('{j,eo,b}{g,eu,n}{s,eo,ng}'), K.h(detail.access)),
      (K.h('{j,u}{b,yeo,n} {j,a}{ng,wo,n}'), K.h(detail.resource)),
      (K.h('{j,i}{ng,yeo,g} {s,u}{ng,yo}'), K.h(detail.demand)),
    ];

    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 82,
        crossAxisSpacing: 44,
        mainAxisSpacing: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              items[index].$1,
              style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Text(
              items[index].$2,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 18, height: 1.35),
            ),
          ],
        );
      },
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
  final VoidCallback onPressed;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final forward = icon == Icons.arrow_forward;

    return FilledButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!forward) Icon(icon, size: 28),
          if (!forward) const SizedBox(width: 22),
          Text(label),
          if (forward) const SizedBox(width: 34),
          if (forward) Icon(icon, size: 28),
        ],
      ),
      style: FilledButton.styleFrom(
        backgroundColor: primary ? SchoolDetailPage._primary : Colors.white,
        foregroundColor: primary ? Colors.white : const Color(0xFF2E2F34),
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
              Positioned(right: 0, bottom: 0, child: ColoredBox(color: SchoolDetailPage._primary, child: SizedBox.square(dimension: 14))),
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
                    color: active ? SchoolDetailPage._primary : const Color(0xFFE3E3E5),
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

class _SchoolDetail {
  const _SchoolDetail({
    required this.image,
    required this.name,
    required this.size,
    required this.condition,
    required this.facility,
    required this.access,
    required this.resource,
    required this.demand,
  });

  final String image;
  final String name;
  final String size;
  final String condition;
  final String facility;
  final String access;
  final String resource;
  final String demand;
}

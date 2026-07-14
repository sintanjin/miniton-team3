import 'package:flutter/material.dart';

import 'landing_page.dart';

class ChecklistPage extends StatelessWidget {
  const ChecklistPage({super.key});

  static const routeName = '/checklist';
  static const _primary = Color(0xFF5661E8);
  static const _bg = Color(0xFFF7F8FC);

  static const _items = [
    _ChecklistItem(
      category: '{h,ae,ng}{j,eo,ng}',
      body: '{ng,i} {p,ye}{g,yo}{ng,e} {ng,eo}{ng,u,l}{r,i}{n,eu,n} {h,wa,l}{ng,yo,ng}{m,o}{d,e,l}{ng,eu,l} {ch,u}{ch,eo,n}{b,a,d}{ng,a} {b,o}{s,e}{ng,yo}.',
      title: '{g,yo}{ng,yu,g}{ch,eo,ng} {g,o,ng}{g,a,n}{d,ae}{ng,yeo} {m,i,ch} {g,wa,n}{g,wa,ng}{s,a}{ng,eo,b} {ng,i,n}{h,eo}{g,a} {h,wa,g}{ng,i,n}',
    ),
    _ChecklistItem(
      category: '{s,i}{s,eo,l}',
      body: '{j,o}{m,yeo,ng}, {h,wa}{j,a,ng}{s,i,l}, {n,ae,ng}{n,a,n}{b,a,ng} {s,eo,l}{b,i}{r,eu,l} {ng,u}{s,eo,n} {j,eo,m}{g,eo,m}{h,ae} {b,o}{s,e}{ng,yo}.',
      title: '{j,o}{m,yeo,ng} · {j,eo,n}{g,i} · {h,wa}{j,a,ng}{s,i,l} {s,a}{j,eo,n} {j,eo,m}{g,eo,m}',
    ),
    _ChecklistItem(
      category: '{ng,ye}{s,a,n}',
      body: '{ch,o}{g,i} remodeling{g,wa} {ng,u,n}{ng,yeo,ng} {j,u,n}{b,i} {b,i}{ng,yo,ng}{ng,eu,l} {g,u}{b,u,n}{h,ae} {b,o}{s,e}{ng,yo}.',
      title: '{ch,o}{g,i} {g,o,ng}{s,a} {b,i} · {ng,u,n}{ng,yeo,ng}{b,i} · {h,o}{b,o}{b,i} {s,a,n}{ch,u,l}',
    ),
    _ChecklistItem(
      category: '{ng,u,n}{ng,yeo,ng}',
      body: '{j,u}{b,yeo,n} {j,a}{ng,wo,n}{ng,wa} {h,yeo,b}{ng,eo,b}{h,a}{g,o} {j,i}{s,o,g} {ng,u,n}{ng,yeo,ng} {g,u}{j,o}{r,eu,l} {m,a,n}{d,eu}{s,e}{ng,yo}.',
      title: '{ng,u,n}{ng,yeo,ng} {j,u}{ch,e} · {h,yeo,b}{ng,eo,b} {g,i}{g,wa,n} · {ng,i,n}{r,yeo,g} {h,wa,g}{b,o}',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                    K.h('{s,i,l}{h,ae,ng}{ng,eu,l} {ng,wi}{h,a,n} checklist{r,eu,l} {h,wa,g}{ng,i,n}{h,a}{s,e}{ng,yo}!'),
                    style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Colors.black, letterSpacing: 0),
                  ),
                  const SizedBox(height: 62),
                  ...List.generate(
                    _items.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(bottom: index == _items.length - 1 ? 0 : 22),
                      child: _ChecklistCard(number: index + 1, item: _items[index]),
                    ),
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
    );
  }
}

class _ChecklistCard extends StatelessWidget {
  const _ChecklistCard({required this.number, required this.item});

  final int number;
  final _ChecklistItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(34, 26, 40, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE7E8EC)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$number',
              style: const TextStyle(fontSize: 27, color: ChecklistPage._primary, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 22),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  K.h(item.category),
                  style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 22),
                Text(
                  K.h(item.body),
                  style: const TextStyle(fontSize: 18, height: 1.45, color: Colors.black),
                ),
                const SizedBox(height: 12),
                Text(
                  K.h(item.title),
                  style: const TextStyle(fontSize: 25, height: 1.35, color: Colors.black, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ],
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
              Positioned(right: 0, bottom: 0, child: ColoredBox(color: ChecklistPage._primary, child: SizedBox.square(dimension: 14))),
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
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == steps.length - 1 ? 0 : 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: ChecklistPage._primary,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  K.h(steps[index]),
                  style: const TextStyle(fontSize: 16, color: Color(0xFF8C8D93)),
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

class _ChecklistItem {
  const _ChecklistItem({
    required this.category,
    required this.body,
    required this.title,
  });

  final String category;
  final String body;
  final String title;
}

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/school_data.dart';
import 'landing_page.dart';
import 'school_detail_page.dart';

class SchoolSelectionPage extends StatefulWidget {
  const SchoolSelectionPage({super.key});

  static const routeName = '/school-selection';
  static const _primary = Color(0xFF5661E8);
  static const _ink = Color(0xFF11131A);
  static const _bg = Color(0xFFF7F8FC);
  static const _headerBg = Color(0xFFFCFDFF);

  @override
  State<SchoolSelectionPage> createState() => _SchoolSelectionPageState();
}

class _SchoolSelectionPageState extends State<SchoolSelectionPage> {
  static const _pageSize = 6;
  static const _firstPageIds = [
    'school_020_635ebe81',
    'school_013_ebd790b9',
    'school_006_399695cc',
    'school_025_6988acc6',
    'school_010_33ea8204',
    'school_038_3e2104df',
  ];

  late final Future<List<SchoolData>> _schoolsFuture = SchoolRepository.loadSchools();
  int _currentPage = 1;

  List<SchoolData> _orderedSchools(List<SchoolData> schools) {
    final firstPage = <SchoolData>[];
    for (final id in _firstPageIds) {
      final matches = schools.where((school) => school.id == id);
      if (matches.isNotEmpty) firstPage.add(matches.first);
    }

    final pinnedIds = firstPage.map((school) => school.id).toSet();
    final others = schools.where((school) => !pinnedIds.contains(school.id)).toList();
    return [...firstPage, ...others];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SchoolSelectionPage._bg,
      body: SelectionArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              const Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: 92,
                child: ColoredBox(color: SchoolSelectionPage._headerBg),
              ),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: FutureBuilder<List<SchoolData>>(
                      future: _schoolsFuture,
                      builder: (context, snapshot) {
                        final schools = snapshot.hasData ? _orderedSchools(snapshot.data!) : const <SchoolData>[];
                        final totalPages = math.max(1, (schools.length / _pageSize).ceil());
                        final safePage = _currentPage.clamp(1, totalPages).toInt();
                        final start = (safePage - 1) * _pageSize;
                        final pageSchools = schools.skip(start).take(_pageSize).toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 34),
                            const _BrandHeader(),
                            const SizedBox(height: 84),
                            const _StepProgress(),
                            const SizedBox(height: 88),
                            const _IntroText(),
                            const SizedBox(height: 92),
                            if (snapshot.connectionState == ConnectionState.waiting)
                              const _LoadingCards()
                            else if (snapshot.hasError)
                              const _LoadFailed()
                            else
                              _CandidateGrid(schools: pageSchools),
                            const SizedBox(height: 34),
                            _Pagination(
                              currentPage: safePage,
                              totalPages: totalPages,
                              onChanged: (page) => setState(() => _currentPage = page),
                            ),
                            const SizedBox(height: 110),
                            const Divider(color: Color(0xFFD6D8E0)),
                            const SizedBox(height: 50),
                            const _Footer(),
                            const SizedBox(height: 34),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
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

class _CandidateGrid extends StatelessWidget {
  const _CandidateGrid({required this.schools});

  final List<SchoolData> schools;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 760 ? 1 : (constraints.maxWidth < 1040 ? 2 : 3);
        const gap = 30.0;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: 30,
          children: [
            for (final school in schools)
              SizedBox(
                width: width,
                child: _CandidateCard(school: school),
              ),
          ],
        );
      },
    );
  }
}

class _CandidateCard extends StatefulWidget {
  const _CandidateCard({required this.school});

  final SchoolData school;

  @override
  State<_CandidateCard> createState() => _CandidateCardState();
}

class _CandidateCardState extends State<_CandidateCard> {
  bool _hovered = false;

  String get _landText {
    final area = widget.school.landAreaSqm;
    if (area != null) return '${_formatNumber(area)}m²';
    final text = widget.school.landAreaText.trim();
    if (text.isNotEmpty && text != '-') return '${text.replaceAll('m²', '').trim()}m²';
    return K.h('{d,ae}{j,i} {j,eo,ng}{b,o} {h,wa,g}{ng,i,n} {p,i,l}{ng,yo}');
  }

  String get _regionText {
    final parts = widget.school.address.split(RegExp(r'\s+')).where((part) => part.trim().isNotEmpty).toList();
    if (parts.length >= 2) return '${parts[0]} ${parts[1]}';
    if (parts.isNotEmpty) return parts.first;
    return widget.school.region;
  }

  String get _note {
    final plan = widget.school.plan.trim();
    if (plan.isNotEmpty && plan != '-') return plan;
    return K.h('{g,u}{j,o} {ng,ya,ng}{h,o}, {s,i}{s,eo,l} {j,eo,m}{g,eo,m} {p,i,l}{ng,yo}');
  }

  @override
  Widget build(BuildContext context) {
    final image = widget.school.image;

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
            arguments: widget.school.id,
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
                    if (image == null || image.isEmpty)
                      const _DefaultSchoolImage()
                    else
                      Image.asset(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const _DefaultSchoolImage(),
                      ),
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
                            widget.school.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 17),
                          Wrap(
                            spacing: 12,
                            runSpacing: 9,
                            children: [
                              _ChipLabel(text: _regionText),
                              _ChipLabel(text: _landText),
                            ],
                          ),
                          const SizedBox(height: 19),
                          Text(
                            _note,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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

class _DefaultSchoolImage extends StatelessWidget {
  const _DefaultSchoolImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/default_school.png',
      fit: BoxFit.cover,
      alignment: Alignment.center,
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
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: SchoolSelectionPage._primary, fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _Pagination extends StatelessWidget {
  const _Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.onChanged,
  });

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final visiblePages = math.min(10, totalPages);

    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 10,
        children: [
          _PageButton(
            label: '<',
            enabled: currentPage > 1,
            onTap: () => onChanged(currentPage - 1),
          ),
          for (var page = 1; page <= visiblePages; page++)
            _PageButton(
              label: '$page',
              selected: page == currentPage,
              onTap: () => onChanged(page),
            ),
          _PageButton(
            label: '>',
            enabled: currentPage < totalPages,
            onTap: () => onChanged(currentPage + 1),
          ),
        ],
      ),
    );
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({
    required this.label,
    required this.onTap,
    this.selected = false,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onTap;
  final bool selected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(99),
      onTap: enabled ? onTap : null,
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? SchoolSelectionPage._primary : Colors.transparent,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? Colors.white
                : enabled
                    ? const Color(0xFF777980)
                    : const Color(0xFFC5C6CB),
            fontSize: 14,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _LoadingCards extends StatelessWidget {
  const _LoadingCards();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 410,
      child: Center(
        child: CircularProgressIndicator(color: SchoolSelectionPage._primary),
      ),
    );
  }
}

class _LoadFailed extends StatelessWidget {
  const _LoadFailed();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E3EA)),
      ),
      child: const Text(
        'Data load failed',
        style: TextStyle(fontSize: 18, color: Color(0xFF777980)),
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

String _formatNumber(num value) {
  final text = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) buffer.write(',');
    buffer.write(text[i]);
  }
  return buffer.toString();
}

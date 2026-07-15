import 'package:flutter/material.dart';

import '../data/school_data.dart';
import 'idea_page.dart';
import 'landing_page.dart';

class SchoolDetailPage extends StatelessWidget {
  const SchoolDetailPage({super.key});

  static const routeName = '/school-detail';
  static const _primary = Color(0xFF5661E8);
  static const _bg = Color(0xFFF7F8FC);
  static const _headerBg = Color(0xFFFCFDFF);

  static const _firstPageIds = [
    'school_020_635ebe81',
    'school_013_ebd790b9',
    'school_006_399695cc',
    'school_025_6988acc6',
    'school_010_33ea8204',
    'school_038_3e2104df',
  ];

  static List<SchoolData> _orderedSchools(List<SchoolData> schools) {
    final firstPage = <SchoolData>[];
    for (final id in _firstPageIds) {
      final matches = schools.where((school) => school.id == id);
      if (matches.isNotEmpty) firstPage.add(matches.first);
    }

    final pinnedIds = firstPage.map((school) => school.id).toSet();
    final others = schools.where((school) => !pinnedIds.contains(school.id)).toList();
    return [...firstPage, ...others];
  }

  static _SelectedSchool _selectSchool(List<SchoolData> schools, Object? argument) {
    final ordered = _orderedSchools(schools);
    if (argument is String) {
      final index = ordered.indexWhere((school) => school.id == argument);
      if (index >= 0) return _SelectedSchool(ordered[index], index);
    }
    if (argument is int) {
      final safeIndex = argument.clamp(0, ordered.length - 1).toInt();
      return _SelectedSchool(ordered[safeIndex], safeIndex);
    }
    return _SelectedSchool(ordered.first, 0);
  }

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)?.settings.arguments;

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
              child: ColoredBox(color: _headerBg),
            ),
            FutureBuilder<List<SchoolData>>(
              future: SchoolRepository.loadSchools(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 720,
                    child: Center(child: CircularProgressIndicator(color: _primary)),
                  );
                }
                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SizedBox(
                    height: 720,
                    child: Center(child: Text('Data load failed')),
                  );
                }

                final selected = _selectSchool(snapshot.data!, argument);

                return Column(
                  children: [
                    _Header(school: selected.school),
                    _ImageStage(selected: selected),
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.school});

  final SchoolData school;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                school.name,
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
  const _ImageStage({required this.selected});

  final _SelectedSchool selected;

  @override
  Widget build(BuildContext context) {
    final image = selected.school.image;
    final hasImage = image != null && image.isNotEmpty;

    return SizedBox(
      height: hasImage ? 720 : 430,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hasImage)
            Image.asset(
              image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const ColoredBox(color: SchoolDetailPage._bg),
            )
          else
            const ColoredBox(color: SchoolDetailPage._bg),
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
                    child: _InfoGrid(school: selected.school),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: hasImage ? 310 : 46,
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
                          arguments: selected.school.id,
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
  const _InfoGrid({required this.school});

  final SchoolData school;

  String get _size {
    final land = school.landAreaSqm == null ? '-' : '${_formatNumber(school.landAreaSqm!)}m²';
    final building = school.buildingAreaSqm == null ? '-' : '${_formatNumber(school.buildingAreaSqm!)}m²';
    return '${K.h('{d,ae}{j,i}')} $land · ${K.h('{g,eo,n}{m,u,l}')} $building';
  }

  String get _closedDate {
    final closed = school.closedDate.trim();
    return closed.isEmpty ? '-' : closed;
  }

  String get _plan {
    final plan = school.plan.trim();
    return plan.isEmpty || plan == '-' ? '-' : plan;
  }

  String get _access {
    final parts = school.address.split(RegExp(r'\s+')).where((part) => part.trim().isNotEmpty).toList();
    if (parts.length >= 2) return '${parts[0]} ${parts[1]} ${K.h('{ng,i,n}{g,eu,n}')}';
    return school.address;
  }

  String get _nearbyResources {
    final resources = school.nearbyResources.trim();
    return resources.isEmpty || resources == '-' ? '-' : resources;
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      (K.h('{g,yu}{m,o}'), _size),
      (K.h('{p,ye}{g,yo}{ng,i,l}'), _closedDate),
      (K.h('{ch,u}{j,i,n} {g,ye}{h,oe,g}'), _plan),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 44.0;
        final columnWidth = (constraints.maxWidth - gap * 2) / 3;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                for (var index = 0; index < items.length; index++) ...[
                  if (index > 0) const SizedBox(width: gap),
                  SizedBox(
                    width: columnWidth,
                    child: _InfoItem(title: items[index].$1, value: items[index].$2),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                SizedBox(
                  width: columnWidth,
                  child: _InfoItem(
                    title: K.h('{j,eo,b}{g,eu,n}{s,eo,ng}'),
                    value: _access,
                  ),
                ),
                const SizedBox(width: gap),
                SizedBox(
                  width: columnWidth * 2 + gap,
                  child: _InfoItem(
                    title: K.h('{j,u}{b,yeo,n} {j,a}{ng,wo,n}'),
                    value: _nearbyResources,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.title,
    required this.value,
    this.maxLines = 2,
  });

  final String title;
  final String value;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 82,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 18, height: 1.35),
          ),
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
  final VoidCallback onPressed;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final forward = icon == Icons.arrow_forward;

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: primary ? SchoolDetailPage._primary : Colors.white,
        foregroundColor: primary ? Colors.white : const Color(0xFF2E2F34),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
      ),
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

class _SelectedSchool {
  const _SelectedSchool(this.school, this.index);

  final SchoolData school;
  final int index;
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

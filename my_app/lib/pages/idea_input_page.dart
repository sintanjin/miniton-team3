import 'package:flutter/material.dart';

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

  bool get _hasText => _controller.text.trim().isNotEmpty;

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
                                  arguments: _controller.text.trim(),
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
      ),
    );
  }
}

class IdeaReviewPage extends StatelessWidget {
  const IdeaReviewPage({super.key});

  static const routeName = '/idea-review';
  static const _bg = Color(0xFFF7F8FC);
  static const _primary = Color(0xFF5661E8);

  @override
  Widget build(BuildContext context) {
    final idea = (ModalRoute.of(context)?.settings.arguments as String?) ??
        K.h('{ng,i} {p,ye}{g,yo}{r,eu,l} {ng,yu}{ng,a} {ch,e}{h,eo,m}{s,e,n}{t,eo}{r,o} {h,wa,l}{ng,yo,ng}{h,a}{g,o} {s,i,p}{ng,eo}{ng,yo}.');

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
                  const _StepProgress(activeUntil: 2),
                  const SizedBox(height: 88),
                  Text(
                    K.h('idea{ng,ui} {j,eo,g}{h,a,b}{s,eo,ng}{ng,eu,l} {p,a,n}{d,a,n}{h,ae} {d,eu}{r,yeo}{ng,yo}.'),
                    style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Colors.black, letterSpacing: 0),
                  ),
                  const SizedBox(height: 42),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(32, 24, 32, 26),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          K.h('{ng,i,b}{r,yeo,g}{h,a,n} idea'),
                          style: const TextStyle(fontSize: 18, color: Color(0xFF868891)),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          idea,
                          style: const TextStyle(fontSize: 19, color: Colors.black, height: 1.45),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 360,
                    padding: const EdgeInsets.fromLTRB(32, 28, 32, 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              K.h('{ng,i,l}{b,u} {b,o}{ng,wa,n}{ng,i} {p,i,l}{ng,yo}{h,ae}{ng,yo}'),
                              style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w800, color: Colors.black),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F0FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                K.h('{ch,o}{g,i} remodeling {b,i}{ng,yo,ng} {b,a,l}{s,ae,ng}'),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _primary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 34),
                        Text(
                          K.h('{ng,a}{p,a}{t,eu} {d,a,n}{j,i}{g,a} {g,a}{kk,a,b}{g,o} {ng,yu}{ng,a} {ng,i,n}{g,u}{g,a} {m,a,n}{ng,eu}{m,yeo} {s,i}{s,eo,l}{d,o} {ng,ya,ng}{h,o}{h,a,b}{n,i}{d,a}. {g,o,ng}{g,a,n} {j,o}{g,eo,n}{ng,wa} {j,i}{ng,yeo,g} {s,u}{ng,yo}{r,eu,l} {g,o}{r,yeo}{h,ae,ss}{ng,eu,l} {tt,ae} {b,a,ng}{h,ya,ng}{s,eo,ng} {j,a}{ch,e}{n,eu,n} {t,a}{d,a,ng}{h,a,b}{n,i}{d,a}.'),
                          style: const TextStyle(fontSize: 19, height: 1.55, color: Colors.black),
                        ),
                      ],
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
                        onPressed: () => Navigator.of(context).pushNamed(ChecklistPage.routeName),
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

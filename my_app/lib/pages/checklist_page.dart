import 'package:flutter/material.dart';

import '../data/ai_api.dart';
import '../data/school_data.dart';
import '../services/report_pdf_service.dart';
import 'landing_page.dart';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});

  static const routeName = '/checklist';
  static const _bg = Color(0xFFF7F8FC);

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  Future<_ChecklistPageData>? _future;
  bool _savingPdf = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= _load();
  }

  Future<_ChecklistPageData> _load() async {
    final argument = ModalRoute.of(context)?.settings.arguments;
    if (argument is! FinalCheckpointArguments || argument.schoolId.isEmpty) {
      throw const AiApiException(
        code: 'SCHOOL_DATA_MISSING',
        message: '최종 체크포인트를 만들기 위한 분석 정보를 찾을 수 없습니다.',
      );
    }
    final school = await SchoolRepository.loadSchool(argument.schoolId);
    final response = await AiApiService.instance.getFinalCheckpoints(
      school: school,
      arguments: argument,
    );
    return _ChecklistPageData(
      school: school,
      arguments: argument,
      response: response,
    );
  }

  void _retry() => setState(() => _future = _load());

  Future<void> _savePdf(_ChecklistPageData data) async {
    if (_savingPdf) return;
    setState(() => _savingPdf = true);
    try {
      await ReportPdfService.save(
        school: data.school,
        arguments: data.arguments,
        checkpoints: data.response,
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF를 저장하지 못했습니다. 잠시 후 다시 시도해 주세요.')),
      );
    } finally {
      if (mounted) setState(() => _savingPdf = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChecklistPage._bg,
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
                  const Text(
                    '최종 체크포인트를 확인하세요!',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Colors.black, letterSpacing: 0),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '선택한 학교와 활용모델을 기준으로 놓치기 쉬운 내용을 정리했습니다.',
                    style: TextStyle(fontSize: 17, height: 1.45, color: Color(0xFF777980)),
                  ),
                  const SizedBox(height: 62),
                  FutureBuilder<_ChecklistPageData>(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const _ChecklistApiStatus.loading();
                      }
                      if (snapshot.hasError || !snapshot.hasData) {
                        return _ChecklistApiStatus.error(
                          message: snapshot.error is AiApiException
                              ? (snapshot.error! as AiApiException).message
                              : '최종 체크포인트를 불러오지 못했습니다.',
                          onRetry: _retry,
                        );
                      }
                      final data = snapshot.data!;
                      final items = data.response.items;
                      return Column(
                        children: [
                          ...List.generate(
                            items.length,
                            (index) => Padding(
                              padding: EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 22),
                              child: _ChecklistCard(item: items[index]),
                            ),
                          ),
                          const SizedBox(height: 68),
                          _BottomActions(
                            savingPdf: _savingPdf,
                            onBack: () => Navigator.of(context).pop(),
                            onSavePdf: () => _savePdf(data),
                            onHome: () => Navigator.of(context).pushNamedAndRemoveUntil(
                              LandingPage.routeName,
                              (route) => false,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 130),
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

class _ChecklistCard extends StatelessWidget {
  const _ChecklistCard({required this.item});

  final FinalCheckpointItem item;

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
            child: Icon(_iconFor(item.category), size: 27, color: const Color(0xFF5661E8)),
          ),
          const SizedBox(width: 22),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.category.label,
                      style: const TextStyle(fontSize: 21, color: Colors.black, fontWeight: FontWeight.w800),
                    ),
                    if (item.priority == CheckpointPriority.high) ...[
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE8E8),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: const Text(
                          '우선 확인',
                          style: TextStyle(fontSize: 13, color: Color(0xFFFF4E5B), fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 13),
                Text(
                  item.note,
                  style: const TextStyle(fontSize: 18, height: 1.5, color: Color(0xFF3C3D43), fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F4FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.lightbulb_outline_rounded, size: 19, color: Color(0xFF5661E8)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item.tip,
                          style: const TextStyle(fontSize: 15, height: 1.45, color: Color(0xFF5659A8), fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static IconData _iconFor(CheckpointCategory category) => switch (category) {
        CheckpointCategory.administration => Icons.account_balance_outlined,
        CheckpointCategory.facility => Icons.home_repair_service_outlined,
        CheckpointCategory.budget => Icons.payments_outlined,
        CheckpointCategory.demand => Icons.groups_outlined,
        CheckpointCategory.operatingSustainability => Icons.autorenew_rounded,
        CheckpointCategory.communityAcceptance => Icons.handshake_outlined,
      };
}

class _ChecklistApiStatus extends StatelessWidget {
  const _ChecklistApiStatus.loading()
      : message = 'AI가 학교별 최종 체크포인트를 정리하고 있습니다.',
        onRetry = null;

  const _ChecklistApiStatus.error({required this.message, required this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onRetry == null)
              const CircularProgressIndicator(color: Color(0xFF5661E8))
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

class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.savingPdf,
    required this.onBack,
    required this.onSavePdf,
    required this.onHome,
  });

  final bool savingPdf;
  final VoidCallback onBack;
  final VoidCallback onSavePdf;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final buttons = [
          _BottomActionButton(
            label: '이전 단계로',
            icon: Icons.arrow_back,
            onPressed: onBack,
          ),
          _BottomActionButton(
            label: savingPdf ? 'PDF 만드는 중' : 'PDF 저장하기',
            icon: Icons.picture_as_pdf_outlined,
            onPressed: savingPdf ? null : onSavePdf,
            outlined: true,
            loading: savingPdf,
          ),
          _BottomActionButton(
            label: '처음으로 가기',
            icon: Icons.replay_rounded,
            onPressed: onHome,
            primary: true,
            iconAfter: true,
          ),
        ];
        if (constraints.maxWidth < 720) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var index = 0; index < buttons.length; index++) ...[
                buttons[index],
                if (index != buttons.length - 1) const SizedBox(height: 14),
              ],
            ],
          );
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: buttons,
        );
      },
    );
  }
}

class _BottomActionButton extends StatelessWidget {
  const _BottomActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.primary = false,
    this.outlined = false,
    this.iconAfter = false,
    this.loading = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool primary;
  final bool outlined;
  final bool iconAfter;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final foreground = primary ? Colors.white : const Color(0xFF2E2F34);
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!iconAfter)
          loading
              ? const SizedBox(
                  width: 21,
                  height: 21,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF5661E8)),
                )
              : Icon(icon, size: 24),
        if (!iconAfter) const SizedBox(width: 16),
        Text(label),
        if (iconAfter) const SizedBox(width: 22),
        if (iconAfter) Icon(icon, size: 25),
      ],
    );
    final style = FilledButton.styleFrom(
      backgroundColor: primary ? const Color(0xFF5661E8) : Colors.white,
      foregroundColor: foreground,
      disabledBackgroundColor: Colors.white,
      disabledForegroundColor: const Color(0xFF8C8D93),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 21),
      shape: const StadiumBorder(),
      textStyle: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
      side: outlined ? const BorderSide(color: Color(0xFF5661E8), width: 1.5) : BorderSide.none,
    );
    return FilledButton(onPressed: onPressed, style: style, child: content);
  }
}

class _ChecklistPageData {
  const _ChecklistPageData({
    required this.school,
    required this.arguments,
    required this.response,
  });

  final SchoolData school;
  final FinalCheckpointArguments arguments;
  final FinalCheckpointResponse response;
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
              Positioned(right: 0, bottom: 0, child: ColoredBox(color: Color(0xFF5661E8), child: SizedBox.square(dimension: 14))),
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
                    color: const Color(0xFF5661E8),
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

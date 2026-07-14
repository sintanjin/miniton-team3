import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/main.dart';
import 'package:my_app/pages/landing_page.dart';

void main() {
  testWidgets('landing page renders core sections', (tester) async {
    tester.view.physicalSize = const Size(1440, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ReSchoolApp());
    await tester.pumpAndSettle();

    expect(find.text(K.h('{d,a}{s,i}, {h,a,g}{g,yo}')), findsNWidgets(2));
    expect(
      find.textContaining(K.h('{s,ae}{r,o}{ng,u,n} {g,a}{n,eu,ng}{s,eo,ng}')),
      findsOneWidget,
    );
    expect(
      find.text(K.h('{ng,i}{r,eo,h}{g,e} {d,o}{ng,wa}{d,eu}{r,yeo}{ng,yo}')),
      findsOneWidget,
    );
    expect(find.text(K.h('AI {j,i,n}{d,a,n} process')), findsOneWidget);
  });
}

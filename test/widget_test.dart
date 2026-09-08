import 'package:flutter_test/flutter_test.dart';

import 'package:breadcrumbs_official/main.dart';

void main() {
  testWidgets('shows onboarding on first launch', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(initialFirstLaunch: true));

    expect(find.text('Welcome to Breadcrumbs'), findsOneWidget);
  });

  testWidgets('shows home scaffold after first launch', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(initialFirstLaunch: false));

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Likes'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}

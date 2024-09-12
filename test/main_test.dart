import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/main.dart'; // Make sure to import your main file

void main() {
  const MethodChannel channel = MethodChannel('com.example.java_in_flutter/reverse_shell');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Set up the mock method channel to return a specific result when invoked
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'runJavaPayload') {
        return 'Java Payload executed successfully';
      }
      return null;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  testWidgets('Run Java Payload', (WidgetTester tester) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(MyApp());

    // Verify that the UI has loaded the text fields and button
    expect(find.text('Enter IP Address'), findsOneWidget);
    expect(find.text('Enter Port'), findsOneWidget);
    expect(find.text('Run Java Payload'), findsOneWidget);

    // Simulate entering IP and port and running the Java payload
    await tester.enterText(find.byType(TextField).at(0), '127.0.0.1');
    await tester.enterText(find.byType(TextField).at(1), '4444');
    await tester.tap(find.text('Run Java Payload'));

    // Let the UI update
    await tester.pump();

    // Verify that the result text appears as expected
    expect(find.text('Java Payload executed successfully'), findsOneWidget);
  });
}

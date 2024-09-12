import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:your_app/main.dart'; // Replace 'your_app' with your actual package name

void main() {
  // Define a mock MethodChannel to intercept and handle method calls
  const MethodChannel channel = MethodChannel('com.example.helloworld/reverse_shell');
  
  // Create a mock for the method call
  TestWidgetsFlutterBinding.ensureInitialized();
  channel.setMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'runJavaPayload') {
      return 'Java Payload executed successfully';
    }
    return null;
  });

  testWidgets('MyHomePage has a title and input fields', (WidgetTester tester) async {
    // Build the MyHomePage widget
    await tester.pumpWidget(MyApp());

    // Verify the title is present
    expect(find.text('Run Java Code in Flutter'), findsOneWidget);

    // Verify the presence of IP and Port text fields
    expect(find.byType(TextField), findsNWidgets(2));

    // Verify the presence of the button
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Enter IP and Port and press button', (WidgetTester tester) async {
    // Build the MyHomePage widget
    await tester.pumpWidget(MyApp());

    // Enter IP and Port
    await tester.enterText(find.byType(TextField).at(0), '127.0.0.1');
    await tester.enterText(find.byType(TextField).at(1), '4444');

    // Tap the button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // Rebuild the widget after the state has changed

    // Verify that the result text is displayed
    expect(find.text('Java Payload executed successfully'), findsOneWidget);
  });
}

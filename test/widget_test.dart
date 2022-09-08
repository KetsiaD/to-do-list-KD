// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:to_dont_list/main.dart';
import 'package:to_dont_list/to_do_items.dart';

class MockOnPressedFunction {
  int called = 0;

  void handler() {
    called++;
  }
}


void main() {
  late MockOnPressedFunction mockOnPressedFunction;
  const ColorScheme colorScheme = ColorScheme.light();
  final ThemeData theme = ThemeData.from(colorScheme: colorScheme);
  setUp(() {
    mockOnPressedFunction = MockOnPressedFunction();
  });
  test('Item abbreviation should be first two letters', () {
    const item = Item(name: "add more todos");
    expect(item.abbrev(), "a");
  });

  // Yes, you really need the MaterialApp and Scaffold
  testWidgets('ToDoListItem has a text', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ToDoListItem(
                item: const Item(name: "test"),
                completed: true,
                onListChanged: (Item item, bool completed) {},
                onDeleteItem: (Item item) {}))));
    final textFinder = find.text('test');

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(textFinder, findsOneWidget);
  });

  testWidgets('ToDoListItem has a Circle Avatar with abbreviation',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ToDoListItem(
                item: const Item(name: "test"),
                completed: true,
                onListChanged: (Item item, bool completed) {},
                onDeleteItem: (Item item) {}))));
    final abbvFinder = find.text('t');
    final avatarFinder = find.byType(CircleAvatar);

    CircleAvatar circ = tester.firstWidget(avatarFinder);
    Text ctext = circ.child as Text;

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(abbvFinder, findsOneWidget);
    expect(circ.backgroundColor, Colors.black);
    expect(ctext.data, "t");
  });

  testWidgets('Default ToDoList has one item', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    final listItemFinder = find.byType(ToDoListItem);

    expect(listItemFinder, findsOneWidget);
  });

  testWidgets('Clicking and Typing adds item to ToDoList', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    expect(find.byType(TextField), findsNothing);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump(); // Pump after every action to rebuild the widgets
    expect(find.text("hi"), findsNothing);

    await tester.enterText(find.byType(TextField), 'hi');
    await tester.pump();
    expect(find.text("hi"), findsOneWidget);

    await tester.tap(find.byKey(const Key("OKButton")));
    await tester.pump();
    expect(find.text("hi"), findsOneWidget);

    final listItemFinder = find.byType(ToDoListItem);

    expect(listItemFinder, findsNWidgets(2));
  });

  
 testWidgets('Search Icon Button can be tapped to view the search bar and other buttons', (WidgetTester tester)
 async{
  final addButton = find.byKey(const ValueKey("addButton"));
  final addButton2 = find.byKey(const ValueKey("addButton2"));
  final addText1 = find.byKey(ValueKey('addText1'));

  await tester.pumpWidget(MaterialApp(home:ToDoList()));
  await tester.tap(addButton);
  //await tester.tap(addButton2);
  //await tester.enterText(addText1, 'keke');
  //await tester.tap(addText1);
  await tester.pump();
  await tester.pump();
  final addButton3 = find.byKey(const Key("addButton3"));
  //expect(addButton, findsOneWidget);
  expect(addButton3, findsOneWidget);
  expect(addButton2, findsOneWidget);
  
 });



  
  
  // One to test the tap and press actions on the items?
}

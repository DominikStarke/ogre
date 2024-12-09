import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ogre/config.dart';
import 'package:ogre/controllers/window.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return WindowController(
      getTrayMenuConfiguration: getTrayMenuConfiguration,
      appIcon: trayIcon,
      windowOptions: windowOptions,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController searchInputController = TextEditingController();
  FocusNode? _searchInputFocusNode;
  FocusNode get searchInputFocusNode {
    _searchInputFocusNode = _searchInputFocusNode ?? FocusNode(onKeyEvent: handleKeyEvent);
    return _searchInputFocusNode!;
  }
  late final WindowControllerState window = WindowController.of(context);

  KeyEventResult handleKeyEvent (FocusNode node, KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.escape && event is KeyUpEvent) {
      window.hide();
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.escape) {
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: searchInputController,
          focusNode: searchInputFocusNode,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter a search term',
          ),
          onChanged: (String value) async {

          },
        ),
      ),
    );
  }
}

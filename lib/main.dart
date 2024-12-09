import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ogre/api/openwebui.dart';
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
    } else if (event.logicalKey == LogicalKeyboardKey.enter && event is KeyUpEvent) {
      submit();
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.enter) {
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  Future<void> submit () async {
    final chat = OWChat(
      defaultModel: "llama3.2:latest",
      apiKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjA4MDJhNTc5LWZlZGQtNGViZC05NDE1LTkwZjI4MzJmYmM4MyJ9.U-QNDQKKXi2n7Skm0p3dOHNBMj1F_2AkmAu-DnTa1Ik'
    );

    await for (final message in chat.chat(searchInputController.text)) {
      stdout.write(message);
    }
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

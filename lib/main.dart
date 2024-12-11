import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ogre/api/openwebui.dart';
import 'package:ogre/config.dart';
import 'package:ogre/controllers/window.dart';

void main() {
  runApp(const OgreApp());
}

class OgreApp extends StatelessWidget {
  const OgreApp({super.key});
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
        home: const OgreHome(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class OgreHome extends StatefulWidget {
  const OgreHome({super.key, required this.title});
  final String title;

  @override
  State<OgreHome> createState() => _OgreHomeState();
}

class _OgreHomeState extends State<OgreHome> {
  final TextEditingController searchInputController = TextEditingController();
  FocusNode? _searchInputFocusNode;
  FocusNode get searchInputFocusNode {
    _searchInputFocusNode = _searchInputFocusNode ?? FocusNode(onKeyEvent: handleKeyEvent);
    return _searchInputFocusNode!;
  }
  late final WindowControllerState window = WindowController.of(context);

  final chat = OWChat(
    defaultModel: "llama3.1:latest",
    apiKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjA4MDJhNTc5LWZlZGQtNGViZC05NDE1LTkwZjI4MzJmYmM4MyJ9.U-QNDQKKXi2n7Skm0p3dOHNBMj1F_2AkmAu-DnTa1Ik'
  );


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

    // await for (final message in chat.chat(searchInputController.text)) {
    //   stdout.write(message);
    //   stdout.flush();
    // }

    // stdout.addStream(Stream<List<int>>.fromIterable([
    //   utf8.encode('Your message'),
    // ]));

    await stdout.addStream(chat.chat(searchInputController.text).map((v) => utf8.encode(v)));
    stdout.write('\n');
    await stdout.flush();
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

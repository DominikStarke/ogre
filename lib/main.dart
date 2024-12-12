import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:ogre/api/openwebui.dart';
import 'package:ogre/config.dart';
import 'package:ogre/controllers/window.dart';
import 'package:window_manager/window_manager.dart';
import 'package:keypress_simulator/keypress_simulator.dart';

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
        debugShowCheckedModeBanner: false,
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
  ClipboardData? copyContext;
  StringBuffer _responseBuffer = StringBuffer("");
  bool _showResponse = false;
  final TextEditingController promptInputController = TextEditingController();
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

  @override
  initState() {
    super.initState();
    HotkeyEntry(
      key: LogicalKeyboardKey.home,
      modifiers: [HotKeyModifier.shift],
      scope: HotKeyScope.system,
      onUp: onActivate
    ).register();
  }

  Future<void> onActivate (HotKey hotKey) async {
    if(await windowManager.isVisible()) {
      closeWindow();
    } else {
      await Future.delayed(Duration(milliseconds: 20));
      await keyPressSimulator.simulateKeyDown(
        PhysicalKeyboardKey.keyC,
        [ModifierKey.metaModifier],
      );
      await Future.delayed(Duration(milliseconds: 20));
      await keyPressSimulator.simulateKeyUp(
        PhysicalKeyboardKey.keyC,
        [ModifierKey.metaModifier],
      );
      await Future.delayed(Duration(milliseconds: 20));
      
      copyContext = await Clipboard.getData(Clipboard.kTextPlain);

      windowManager.show();
      searchInputFocusNode.requestFocus();
      promptInputController.selection = TextSelection.fromPosition(const TextPosition(offset: 0));
    }
  }

  clearWindow () {
    setState(() {
      _showResponse = false;
      _responseBuffer = StringBuffer();
      chat.clear();
      promptInputController.clear();

      final minSize = windowOptions.minimumSize;
      if(minSize != null) {
        windowManager.setSize(minSize);
      }
    });
  }

  closeWindow () {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      window.hide();
    });
  }


  KeyEventResult handleKeyEvent (FocusNode node, KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.escape && event is KeyUpEvent) {
      clearWindow();
      closeWindow();
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
    bool first = true;
    _responseBuffer = StringBuffer();
    await for (var v in chat.chat('''### Context
${copyContext?.text ?? ''}

### Prompt
${promptInputController.text}''')) {
      if(first) {
        windowManager.setSize(const Size(800, 600));
        _showResponse = true;
      }

      setState(() {
        _responseBuffer.write(v);
        first = false;
      });


      // await Clipboard.setData(ClipboardData(text: v));
      // await Future.delayed(Duration(milliseconds: 20));
      // await keyPressSimulator.simulateKeyDown(
      //   PhysicalKeyboardKey.keyV,
      //   [ModifierKey.metaModifier],
      // );
      // await Future.delayed(Duration(milliseconds: 20));
      // await keyPressSimulator.simulateKeyUp(
      //   PhysicalKeyboardKey.keyV,
      //   [ModifierKey.metaModifier],
      // );
      // await Future.delayed(Duration(milliseconds: 20));

      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 44,
              child: TextFormField(
                controller: promptInputController,
                focusNode: searchInputFocusNode,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Prompt',
                ),
                onChanged: (String value) async {
                        
                },
              ),
            ),
          ),
          if (_showResponse)
            SizedBox(
              width: 800,
              height: 540,
              child: Markdown(data: _responseBuffer.toString()),
            ),
        ],
      ),
    );
  }
}

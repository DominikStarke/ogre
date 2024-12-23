import 'package:flutter/material.dart';
import 'package:ogre/controllers/app.dart';
import 'package:ogre/controllers/llm_controller.dart';

import 'package:ogre/screens/chat.dart';
// import 'package:ogre/screens/settings.dart';

void main() async {
  runApp(const OgreApp());
}

class OgreApp extends StatelessWidget {
  const OgreApp({super.key});

  get scheme => ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark);

  @override
  Widget build(BuildContext context) {
    return AppController(
      child: LlmController(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: scheme,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: scheme,
          ),
          home: const Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
            floatingActionButton: FloatingPopupMenuButton(),
            body: OgreChat()
          ),
        ),
      ),
    );
  }
}

class FloatingPopupMenuButton extends StatelessWidget {
  const FloatingPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: PopupMenuButton<String>(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(scheme.surfaceContainerLowest.withValues(alpha: .5)),
        ),
        onSelected: (String result) {
          if(result == 'go_to_settings') {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings()));
          } else if(result == 'clear_chat') {
            LlmController.of(context).clearChat();
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'go_to_settings',
            child: Text('Settings'),
          ),
          PopupMenuItem<String>(
            value: 'clear_chat',
            child: Text('Clear chat', style: TextStyle(color: scheme.error)),
          ),
        ],
        icon: const Icon(Icons.more_vert),
      ),
    );
  }
}
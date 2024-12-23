import 'package:flutter/material.dart';
import 'package:ogre/controllers/app.dart';
import 'package:ogre/controllers/llm.dart';

import 'package:ogre/screens/chat.dart';
import 'package:ogre/screens/settings.dart';
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
          home: const OgreChat(),
          routes: {
            '/settings': (context) => const Settings(),
          },
        ),
      ),
    );
  }
}

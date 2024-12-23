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

  get darkScheme => ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark);
  get lightScheme => ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.light);

  @override
  Widget build(BuildContext context) {
    return AppController(
      loading: const Material(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      child: LlmController(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightScheme,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkScheme,
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

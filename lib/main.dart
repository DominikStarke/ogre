import 'package:flutter/material.dart';
import 'package:ogre/controllers/app.dart';
import 'package:ogre/controllers/llm.dart';

import 'package:ogre/screens/chat.dart';
import 'package:ogre/screens/settings.dart';
import 'package:ogre/theme/theme.dart';

void main() async {
  runApp(const OgreApp());
}

class OgreApp extends StatelessWidget {
  const OgreApp({super.key});

  static Route<dynamic>? onGenerateRoute (settings) {
    if(settings.name == '/settings') {
      return MaterialPageRoute(
        builder: (context) => const Settings(),
      );
    } else {
      return MaterialPageRoute(
        builder: (context) => const OgreChat(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Ogre",
      theme: getTheme(Brightness.light),
      darkTheme: getTheme(Brightness.dark),
      home: const AppController(
        loading: Center(
          child: CircularProgressIndicator(),
        ),
        child: LlmController(
          child: Navigator(
            onGenerateRoute: onGenerateRoute,
          ),
        ),
      ),
    );
  }
}

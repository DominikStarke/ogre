import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:ogre/controllers/llm.dart';
import 'package:ogre/theme/material_chat.dart';
import 'package:ogre/widgets/app_menu.dart';

class OgreChat extends StatelessWidget {
  const OgreChat({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LlmController.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: const AppMenu(),
      body: ListenableBuilder(
        listenable: controller.configChanged,
        builder: (context, _) {
          if(controller.llmProvider == null) {
            return const Center(
              child: Text("No provider selected. Go to settings and configure your AI provider.")
            );
          } else {
            return LlmChatView(
              messageSender: controller.clipboardAttachmentSender,
              provider: controller.llmProvider!,
              style: materialChatThemeOf(context),
            );
          }
        } 
      ),
    );
  }
}

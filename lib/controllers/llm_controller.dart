import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ogre/controllers/app.dart';
import 'package:ogre/llm_providers/openwebui.dart';

class LlmController extends StatefulWidget {
  final Widget child;
  const LlmController({super.key, required this.child});

  @override
  createState() => LlmControllerState();

  static LlmControllerState of(BuildContext context) {
    final state = context.findAncestorStateOfType<LlmControllerState>();
    if(state == null) {
      throw Exception('LlmConfigurationState not found in context');
    }
    return state;
  }
}

class LlmControllerState extends State<LlmController> with ChangeNotifier {

  LlmProvider? _llmProvider;

  LlmProvider get llmProvider {
    _llmProvider = _llmProvider ?? OpenwebuiProvider(
      host: 'http://localhost:3000',
      model: 'qwen2.5:latest',
      apiKey: dotenv.get('OPENWEBUI_API_KEY'),
    );
    return _llmProvider!;
  }

  void clearChat () {
    _llmProvider = null;
    notifyListeners();
  }

  Stream<String> clipboardAttachmentSender (String prompt, {required Iterable<Attachment> attachments}) async* {
    final controller = AppController.of(context);
    if (controller.clipboardData != null) {
      final fileAttachment = FileAttachment(
        name: 'clipboardData',
        mimeType: 'text/plain',
        bytes: Uint8List.fromList(utf8.encode(controller.clipboardData?.text ?? '')),
      );
      controller.clipboardData = null;
      yield* llmProvider.sendMessageStream(
        prompt,
        attachments: [...attachments, fileAttachment],
      );
    } else {
      yield* llmProvider.sendMessageStream(prompt, attachments: attachments);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

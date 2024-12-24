import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_ai_providers/flutter_ai_providers.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:ogre/controllers/app.dart';
import 'package:ogre/controllers/llm_config_store.dart';
import 'package:ogre/llm_providers/const.dart';
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

class LlmControllerState extends State<LlmController> {
  ValueNotifier<LlmProvider?>? _notifier;
  ValueNotifier<LlmProvider?> get notifier {
    _notifier = _notifier ?? ValueNotifier<LlmProvider?>(llmProvider);
    return _notifier!;
  }

  LlmProvider? _llmProvider;
  LlmProvider? get llmProvider => _llmProvider;

  LlmConfigStore get _storage => LlmConfigStore(
    platform: Theme.of(context).platform,
  );

  Future<LlmConfigStoreModel> getConfig () async {
    return await _storage.load();
  }

  Future<void> saveConfig (LlmConfigStoreModel config) async {
    await _storage.save(config);
    _configure(config.clone());
  }

  void _loadAndConfigure () async {
    final config = await getConfig();
    _configure(config.clone());
  }

  void _configure (LlmConfigStoreModel config) {
    if (config.defaultProvider == LlmProviderType.openwebui) {
      _llmProvider = OpenwebuiProvider(
        baseUrl: config.owuiHost,
        model: config.owuiModel,
        apiKey: config.owuiApiKey,
      );
    } else if (config.defaultProvider == LlmProviderType.openai) {
      _llmProvider = OpenAIProvider(
        baseUrl: config.oaiHost,
        model: config.oaiModel,
        apiKey: config.oaiApiKey,
      );
    } else if (config.defaultProvider == LlmProviderType.anthropic) {
      _llmProvider = AnthropicProvider(
        baseUrl: config.anthropicHost,
        model: config.anthropicModel,
        apiKey: config.anthropicApiKey,
      );
    } else if (config.defaultProvider == LlmProviderType.ollama) {
      _llmProvider = OllamaProvider(
        baseUrl: config.ollamaHost,
        model: config.ollamaModel,
      );
    }

    notifier.value = llmProvider;
  }

  void clearChat () {
    _llmProvider = null;
    notifier.value = llmProvider;
  }

  Stream<String> clipboardAttachmentSender (String prompt, {required Iterable<Attachment> attachments}) async* {
    if(llmProvider == null) {
      yield "No provider selected. Go to settings and configure your AI provider.";
      return;
    }
    final controller = AppController.of(context);
    if (controller.clipboardData != null && attachments.isEmpty) {
      final fileAttachment = FileAttachment(
        name: 'clipboardData',
        mimeType: 'text/plain',
        bytes: Uint8List.fromList(utf8.encode(controller.clipboardData?.text ?? '')),
      );
      controller.clipboardData = null;
      yield* llmProvider!.sendMessageStream(
        prompt,
        attachments: [...attachments, fileAttachment],
      );
    } else {
      controller.clipboardData = null;
      yield* llmProvider!.sendMessageStream(prompt, attachments: attachments);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAndConfigure();
  }

  @override
  void dispose() {
    super.dispose();
    notifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

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
  ValueNotifier<List<LlmConfigStoreModel>>? _configChanged;
  ValueNotifier<List<LlmConfigStoreModel>> get configChanged {
    _configChanged = _configChanged ?? ValueNotifier<List<LlmConfigStoreModel>>(_configs);
    return _configChanged!;
  }

  final List<LlmConfigStoreModel> _configs = [];
  List<LlmConfigStoreModel> get configs => [..._configs];
  LlmConfigStoreModel get selectedConfig => _configs.firstWhere((config) => config.isDefault, orElse: () => _configs.first);

  LlmProvider _llmProvider = EchoProvider();
  LlmProvider? get llmProvider => _llmProvider;

  final _configStore = LlmConfigStore();

  Future<void> loadConfigs () async {
    _configs.clear();
    _configs.addAll(await _configStore.loadAll());
    configure(selectedConfig);
  }

  Future<void> saveConfigs (List<LlmConfigStoreModel> configs) async {
    _configs.clear();
    _configs.addAll(configs);
    await _configStore.saveAll(configs);
  }

  void configure (LlmConfigStoreModel config) {
    for(final c in _configs) {
      c.isDefault = false;
    }

    config.isDefault = true;
    if (config.provider == LlmProviderType.openwebui) {
      _llmProvider = OpenwebuiProvider(
        baseUrl: config.host,
        model: config.model,
        apiKey: config.apiKey,
      );
    } else if (config.provider == LlmProviderType.openai) {
      _llmProvider = OpenAIProvider(
        baseUrl: config.host,
        model: config.model,
        apiKey: config.apiKey,
        headers: config.header,
        organization: config.organization,
        queryParams: config.queryParams,
      );
    } else if (config.provider == LlmProviderType.anthropic) {
      _llmProvider = AnthropicProvider(
        baseUrl: config.host,
        model: config.model,
        apiKey: config.apiKey,
        headers: config.header,
        queryParams: config.queryParams,
      );
    } else if (config.provider == LlmProviderType.ollama) {
      _llmProvider = OllamaProvider(
        baseUrl: config.host,
        model: config.model,
        headers: config.header,
        queryParams: config.queryParams,
      );
    }

    configChanged.value = configs;
    saveConfigs(configs);
  }

  void clearChat () {
    configure(selectedConfig);
  }

  Stream<String> clipboardAttachmentSender (String prompt, {required Iterable<Attachment> attachments}) async* {
    if(llmProvider == null) {
      yield "No provider selected. Go to settings and configure your AI provider.";
      return;
    }

    if (attachments.isEmpty) {
      final clipboard = AppController.of(context).clipboard;
      yield* llmProvider!.sendMessageStream(
        prompt,
        attachments: [
          ...attachments,
          ...clipboard.files,
          ...clipboard.texts,
          ...clipboard.images
        ],
      );
      clipboard.clear();
    } else {
      yield* llmProvider!.sendMessageStream(prompt, attachments: attachments);
    }
  }

  @override
  void initState() {
    super.initState();
    loadConfigs();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    configChanged.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

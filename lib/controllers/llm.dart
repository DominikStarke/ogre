import 'package:flutter/material.dart';
import 'package:flutter_ai_providers/flutter_ai_providers.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ogre/controllers/app.dart';
import 'package:ogre/controllers/llm_config_store.dart';
import 'package:ogre/llm_providers/const.dart';
import 'package:ogre/llm_providers/tool.dart';
import 'package:ogre/tools/open_broswer.dart';
import 'package:ogre/tools/search_images.dart';
import 'package:ogre/tools/search_videos.dart';
import 'package:ogre/tools/search_web.dart';

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

  late final clipboard = AppController.of(context).clipboard;

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
    configChanged.value = configs;
  }

  void configure (LlmConfigStoreModel config) {
    for(final c in _configs) {
      c.isDefault = false;
    }

    config.isDefault = true;
    if (config.provider == LlmProviderType.openwebui) {
      _llmProvider = OpenWebUIProvider(
        baseUrl: config.host,
        model: config.model,
        apiKey: config.apiKey,
        history: _llmProvider.history,
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

    _llmProvider = ToolProvider(
      tools: [
        OpenBrowserTool(),
        SearchWebTool(),
        SearchVideosTool(),
        SearchImagesTool(),
      ],
      provider: _llmProvider
    );

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

    yield* llmProvider!.sendMessageStream(prompt, attachments: [
      ...attachments,
      ...clipboard.files,
      ...clipboard.texts,
      ...clipboard.images
    ]);
    clipboard.clear();
  }

  @override
  void initState() {
    super.initState();
    loadConfigs();
  }

  @override
  void dispose() {
    super.dispose();
    configChanged.dispose();
  }

  Widget responseBuilder (BuildContext context, ChatMessage response) {
    final fragments = response.fragments;
    if(fragments.isNotEmpty) {
      var responseText = (response.text ?? '');
      responseText = responseText.replaceAll(RegExp(r'<flutter_tool>.*?<\/flutter_tool>', dotAll: true), '');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for(final fragment in fragments)
            fragment.builder(context),
            // if(fragment is SearchWebToolFragment)
          // if(responseText.isNotEmpty) Markdown(data: responseText, shrinkWrap: true)
        ]
      );
    }

    return Markdown(data: response.text ?? '', shrinkWrap: true);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

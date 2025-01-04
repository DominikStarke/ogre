import 'package:flutter/material.dart';
import 'package:flutter_ai_providers/flutter_ai_providers.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:ogre/controllers/app.dart';
import 'package:ogre/controllers/llm_config_store.dart';
import 'package:ogre/llm_providers/const.dart';
import 'package:ogre/llm_providers/tool.dart';
import 'package:ogre/tools/open_broswer.dart';
import 'package:ogre/tools/search_images.dart';
import 'package:ogre/tools/search_maps.dart';
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


  final ValueNotifier<List<OwuiChatListEntry>> _chatListChanged = ValueNotifier<List<OwuiChatListEntry>>([]);
  ValueNotifier<List<OwuiChatListEntry>> get chatListChanged {
    if(!isOpenWebUiProvider) {
      return _chatListChanged;
    }

    return (__llmProvider as OpenWebUIProvider).chatListNotifier;
  }

  final List<OwuiChatListEntry> _chatList = [];
  List<OwuiChatListEntry> get chatList {
    if(!isOpenWebUiProvider) {
      return _chatList;
    }

    return (__llmProvider as OpenWebUIProvider).chats;
  }
  // OwuiChatListEntry get selectedChat => _chatList.firstWhere((config) => config.isDefault, orElse: () => _chatList.first);

  late final clipboard = AppController.of(context).clipboard;

  LlmProvider __llmProvider = EchoProvider(); // The actual provider wrapper by _llmProvider
  LlmProvider _llmProvider = EchoProvider(); // Tool provider wrapper for __llmProvider
  LlmProvider? get llmProvider => _llmProvider;

  final _configStore = LlmConfigStore();

  bool get isOpenWebUiProvider {
    return __llmProvider is OpenWebUIProvider;
  }


  Future<void> loadConfigs () async {
    _configs.clear();
    _configs.addAll(await _configStore.loadAll());
    configure(selectedConfig);
  }

  Future<void> loadChat (OwuiChatListEntry chat) async {
    if(!isOpenWebUiProvider) {
      return;
    }

    await (__llmProvider as OpenWebUIProvider).loadChat(chat.id);
  }
  
  void clearChat () async {
    if(!isOpenWebUiProvider) {
      return;
    }

    (__llmProvider as OpenWebUIProvider).clearChat();
  }

  Future<void> saveConfigs (List<LlmConfigStoreModel> configs) async {
    _configs.clear();
    _configs.addAll(configs);
    await _configStore.saveAll(configs);
  }

  Future<void> configureAndSave(LlmConfigStoreModel config) async {
    configure(config);
    await saveConfigs(configs);
  }

  void configure (LlmConfigStoreModel config) {
    for(final c in _configs) {
      c.isDefault = false;
    }

    config.isDefault = true;
    if (config.provider == LlmProviderType.openwebui) {
      __llmProvider = OpenWebUIProvider(
        baseUrl: config.host,
        apiKey: config.apiKey,
      );
    } else if (config.provider == LlmProviderType.openai) {
      __llmProvider = OpenAIProvider(
        baseUrl: config.host,
        model: config.model,
        apiKey: config.apiKey,
        headers: config.header,
        organization: config.organization,
        queryParams: config.queryParams,
      )..history = _llmProvider.history;
    } else if (config.provider == LlmProviderType.anthropic) {
      __llmProvider = AnthropicProvider(
        baseUrl: config.host,
        model: config.model,
        apiKey: config.apiKey,
        headers: config.header,
        queryParams: config.queryParams,
      )..history = _llmProvider.history;
    } else if (config.provider == LlmProviderType.ollama) {
      __llmProvider = OllamaProvider(
        baseUrl: config.host,
        model: config.model,
        headers: config.header,
        queryParams: config.queryParams,
      )..history = _llmProvider.history;
    }

    _llmProvider = ToolProvider(
      tools: [
        OpenBrowserTool(),
        SearchWebTool(),
        SearchVideosTool(),
        SearchImagesTool(),
        SearchMapsTool(),
      ],
      provider: __llmProvider
    );

    configChanged.value = configs;
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

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

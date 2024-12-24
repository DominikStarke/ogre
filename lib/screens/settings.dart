import 'package:flutter/material.dart';
import 'package:ogre/controllers/llm.dart';
import 'package:ogre/controllers/llm_config_store.dart';
import 'package:ogre/llm_providers/const.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late final controller = LlmController.of(context);
  final _formKey = GlobalKey<FormState>();
  bool _loading = true;

  LlmConfigStoreModel _config = LlmConfigStoreModel();

  @override
  void initState() {
    super.initState();
    asyncInit();
  }

  Future<void> asyncInit() async {
    _config = await controller.getConfig();
    setState(() {
      _loading = false;
    });
  }

  Future<void> save() async {
    await controller.saveConfig(_config);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
          }
          save();
        },
        child: const Text("Save"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          if(_loading) const Center(child: CircularProgressIndicator()),
          if(_loading == false) Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                DropdownMenu<LlmProviderType>(
                  initialSelection: _config.defaultProvider,
                  dropdownMenuEntries: LlmProviderType.values.map((type) => DropdownMenuEntry(
                    label: type.value,
                    value: type,
                  )).toList(),
                  label: const Text('Use Provider'),
                  hintText: 'Select a provider',
                  width: double.infinity,
                  onSelected: (value) {
                    setState(() {
                      _config.defaultProvider = value ?? LlmProviderType.none;
                    });
                  },
                ),

                const Divider(),
                const Text("openwebui"),

                TextFormField(
                  initialValue: _config.owuiApiKey,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'API Key',
                  ),
                  onSaved: (value) {
                    _config.owuiApiKey = value ?? "";
                  },
                ),

                TextFormField(
                  initialValue: _config.owuiHost,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'Host',
                    hintText: 'https://api.openai.com',
                  ),
                  onSaved: (value) {
                    _config.owuiHost = value ?? "";
                  },
                ),

                TextFormField(
                  initialValue: _config.owuiModel,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'Model',
                    hintText: 'gpt-3.5-turbo',
                  ),
                  onSaved: (value) {
                    _config.owuiModel = value ?? "";
                  },
                ),

                const Divider(),
                const Text("openai"),

                TextFormField(
                  initialValue: _config.oaiApiKey,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'API Key',
                  ),
                  onSaved: (value) {
                    _config.oaiApiKey = value ?? "";
                  },
                ),

                TextFormField(
                  initialValue: _config.oaiHost,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'Host',
                    hintText: 'https://api.openai.com',
                  ),
                  onSaved: (value) {
                    _config.oaiHost = value ?? "";
                  },
                ),

                TextFormField(
                  initialValue: _config.oaiModel,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'Model',
                    hintText: 'gpt-3.5-turbo',
                  ),
                  onSaved: (value) {
                    _config.oaiModel = value ?? "";
                  },
                ),

                const Divider(),
                const Text("ollama"),

                TextFormField(
                  initialValue: _config.ollamaApiKey,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'API Key',
                  ),
                  onSaved: (value) {
                    _config.ollamaApiKey = value ?? "";
                  },
                ),

                TextFormField(
                  initialValue: _config.ollamaHost,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'Host',
                    hintText: 'https://api.openai.com',
                  ),
                  onSaved: (value) {
                    _config.ollamaHost = value ?? "";
                  },
                ),

                TextFormField(
                  initialValue: _config.ollamaModel,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'Model',
                    hintText: 'gpt-3.5-turbo',
                  ),
                  onSaved: (value) {
                    _config.ollamaModel = value ?? "";
                  },
                ),

                const Divider(),
                const Text("Anthropic"),

                TextFormField(
                  initialValue: _config.anthropicApiKey,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'API Key',
                  ),
                  onSaved: (value) {
                    _config.anthropicApiKey = value ?? "";
                  },
                ),

                TextFormField(
                  initialValue: _config.anthropicHost,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'Host',
                    hintText: 'https://api.openai.com',
                  ),
                  onSaved: (value) {
                    _config.anthropicHost = value ?? "";
                  },
                ),

                TextFormField(
                  initialValue: _config.anthropicModel,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'Model',
                    hintText: 'gpt-3.5-turbo',
                  ),
                  onSaved: (value) {
                    _config.anthropicModel = value ?? "";
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

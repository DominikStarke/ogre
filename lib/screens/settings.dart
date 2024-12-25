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
  late final _controller = LlmController.of(context);
  final _formKey = GlobalKey<FormState>();

  List<LlmConfigStoreModel> _configs = [];
  LlmConfigStoreModel _selectedConfig = LlmConfigStoreModel();
  final _selectedConfigName = ValueNotifier<String>("");

  @override
  void initState() {
    super.initState();
    asyncInit();
  }

  @override
  dispose() {
    _selectedConfigName.dispose();
    super.dispose();
  }

  Future<void> asyncInit() async {
    _configs = _controller.configs;
    if (_configs.isNotEmpty) {
      setConfig(_configs.firstWhere((config) => config.isDefault, orElse: () => _configs.first));
    }
  }

  Future<void> saveConfig() async {
    await _controller.saveConfigs(_configs);
  }

  Future<void> addConfig() async {
    final newConfig = LlmConfigStoreModel(name: "New Configuration");
    _configs.add(newConfig);
    setConfig(newConfig);
  }

  Future<void> removeConfig(LlmConfigStoreModel config) async {
    _configs.remove(config);
    if (_configs.isNotEmpty) {
      setConfig(_configs.first);
    } else {
      addConfig();
    }
    await saveConfig();
  }

  void setName(String? name) {
    if(name != null) {
      _selectedConfigName.value = name;
      _selectedConfig.name = name;
    }
  }

  void setConfig(LlmConfigStoreModel? config) {
    if(config != null) {
      setState(() {
        _selectedConfig = config;
        _selectedConfigName.value = _selectedConfig.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: addConfig,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
          }
          saveConfig();
        },
        child: const Icon(Icons.save),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListenableBuilder(
                listenable: _selectedConfigName,
                builder: (context, _) => DropdownButtonFormField<LlmConfigStoreModel>(
                  key: UniqueKey(),
                  value: _selectedConfig,
                  selectedItemBuilder: (context) {
                    return _configs.map((config) {
                      return Text(_selectedConfigName.value);
                    }).toList();
                  },
                  items: _configs.map((config) {
                    return DropdownMenuItem(
                      key: UniqueKey(),
                      value: config,
                      child: Text(config.name),
                    );
                  }).toList(),
                  onChanged: setConfig,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    labelText: 'Select Configuration',
                  ),
                )
              ),

              const Divider(),

              TextFormField(
                key: UniqueKey(),
                initialValue: _selectedConfig.name,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  labelText: 'Configuration Name',
                ),
                onChanged: setName,
              ),
              
              DropdownMenu<LlmProviderType>(
                initialSelection: _selectedConfig.provider,
                dropdownMenuEntries: LlmProviderType.values.map((type) => DropdownMenuEntry(
                  label: type.value,
                  value: type,
                )).toList(),
                label: const Text('Use Provider'),
                hintText: 'Select a provider',
                width: double.infinity,
                onSelected: (value) {
                  setState(() {
                    _selectedConfig.provider = value ?? LlmProviderType.none;
                  });
                },
              ),
              
              TextFormField(
                key: UniqueKey(),
                initialValue: _selectedConfig.apiKey,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  labelText: 'API Key',
                ),
                onSaved: (value) {
                  _selectedConfig.apiKey = value ?? "";
                },
              ),
              
              TextFormField(
                key: UniqueKey(),
                initialValue: _selectedConfig.host,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  labelText: 'Host',
                  hintText: 'https://api.example.com',
                ),
                onSaved: (value) {
                  _selectedConfig.host = value ?? "";
                },
              ),
              
              TextFormField(
                key: UniqueKey(),
                initialValue: _selectedConfig.model,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  labelText: 'Model',
                  hintText: 'model-name',
                ),
                onSaved: (value) {
                  _selectedConfig.model = value ?? "";
                },
              ),
              
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.error),
                  foregroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.onError),
                ),
                onPressed: () => removeConfig(_selectedConfig),
                child: const Text('Delete Configuration'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

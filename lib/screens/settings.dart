import 'package:flutter/material.dart';
import 'package:ogre/controllers/llm.dart';
import 'package:ogre/controllers/llm_config_store.dart';
import 'package:ogre/llm_providers/const.dart';
import 'dart:convert';
import 'package:ogre/controllers/app.dart';
import 'package:ogre/controllers/app_config_store.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late final _llmController = LlmController.of(context);
  late final _appController = AppController.of(context);
  final _formKey = GlobalKey<FormState>();

  List<LlmConfigStoreModel> _configs = [];
  LlmConfigStoreModel _selectedConfig = LlmConfigStoreModel();
  final _selectedConfigName = ValueNotifier<String>("");
  AppConfigStoreModel _appConfig = AppConfigStoreModel();

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
    _configs = _llmController.configs;
    _appConfig = _appController.config;
    if (_configs.isNotEmpty) {
      setConfig(_configs.firstWhere((config) => config.isDefault, orElse: () => _configs.first));
    }
  }

  Future<void> saveConfig() async {
    await _llmController.saveConfigs(_configs);
    await _appController.saveConfig();
  }

  Future<void> addConfig() async {
    final newConfig = LlmConfigStoreModel(name: "New Configuration");
    _configs.add(newConfig);
    setConfig(newConfig);
  }

  Future<void> duplicate(LlmConfigStoreModel config) async {
    final newConfig = config.copyWith(
      isDefault: false,
      name: "Copy of ${config.name}",
    );
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

  String? jsonValidator(value) {
    if(value.isEmpty) {
      return null;
    }
    try {
      if (value != null) {
        jsonDecode(value);
      }
    } catch (e) {
      return 'Invalid JSON';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        scrolledUnderElevation: 0,
        title: const Text('Settings'),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              spacing: 24,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("App Settings", style: theme.textTheme.titleLarge),

                // DropdownButtonFormField<String>(
                //   value: _appConfig.themeBrightness,
                //   items: const [
                //     DropdownMenuItem(value: "dark", child: Text("Dark")),
                //     DropdownMenuItem(value: "light", child: Text("Light")),
                //     DropdownMenuItem(value: "automatic", child: Text("Automatic")),
                //   ],
                //   onChanged: (value) {
                //     setState(() {
                //       _appConfig.themeBrightness = value ?? "automatic";
                //     });
                //   },
                //   decoration: const InputDecoration(
                //     labelText: 'Theme Brightness',
                //   ),
                // ),

                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Hide application when inactive'),
                  value: _appConfig.autoHide,
                  onChanged: (value) {
                    setState(() {
                      _appConfig.autoHide = value;
                    });
                  },
                ),

                Text("Provider Configurations", style: theme.textTheme.titleLarge),

                Row(
                  spacing: 4,
                  children: [
                    ListenableBuilder(
                      listenable: _selectedConfigName,
                      builder: (context, _) {
                        return Expanded(
                          child: DropdownButtonFormField<LlmConfigStoreModel>(
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
                              labelText: 'Select Configuration',
                            ),
                          ),
                        );
                      }
                    ),
                    IconButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(scheme.primaryContainer),
                        foregroundColor: WidgetStatePropertyAll(scheme.onPrimaryContainer),
                      ),
                      icon: const Icon(Icons.add),
                      onPressed: addConfig,
                    ),
                
                    IconButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(scheme.tertiaryContainer),
                        foregroundColor: WidgetStatePropertyAll(scheme.onTertiaryContainer),
                      ),
                      icon: const Icon(Icons.copy),
                      onPressed: () => duplicate(_selectedConfig),
                    ),
                
                    IconButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(scheme.errorContainer),
                        foregroundColor: WidgetStatePropertyAll(scheme.onErrorContainer),
                      ),
                      icon: const Icon(Icons.delete),
                      onPressed: () => removeConfig(_selectedConfig),
                    ),
                  ],
                ),
          
                TextFormField(
                  key: UniqueKey(),
                  initialValue: _selectedConfig.name,
                  decoration: const InputDecoration(
                    labelText: 'Configuration Name',
                  ),
                  onChanged: setName,
                ),
                
                DropdownButtonFormField<LlmProviderType>(
                  value: _selectedConfig.provider,
                  items: LlmProviderType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedConfig.provider = value ?? LlmProviderType.none;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Provider',
                    hintText: 'Select a provider',
                  ),
                ),
                
                TextFormField(
                  key: UniqueKey(),
                  initialValue: _selectedConfig.apiKey,
                  decoration: const InputDecoration(
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
                    labelText: 'Host',
                    hintText: 'http://localhost:3000/api',
                  ),
                  onSaved: (value) {
                    _selectedConfig.host = value ?? "";
                  },
                ),
                
                TextFormField(
                  key: UniqueKey(),
                  initialValue: _selectedConfig.model,
                  decoration: const InputDecoration(
                    labelText: 'Model',
                    hintText: 'model-name',
                  ),
                  onSaved: (value) {
                    _selectedConfig.model = value ?? "";
                  },
                ),
                
                TextFormField(
                  key: UniqueKey(),
                  initialValue: _selectedConfig.organization,
                  decoration: const InputDecoration(
                    labelText: 'Organization (Optional)',
                  ),
                  onSaved: (value) {
                    _selectedConfig.organization = value;
                  },
                ),
          
                TextFormField(
                  key: UniqueKey(),
                  initialValue: _selectedConfig.header != null ? jsonEncode(_selectedConfig.header) : null,
                  decoration: const InputDecoration(
                    labelText: 'Headers (Optional JSON)',
                    hintText: '{"key1": "value1", "key2": "value2"}',
                  ),
                  minLines: null,
                  maxLines:  null,
                  validator: jsonValidator,
                  onSaved: (value) {
                    try {
                      _selectedConfig.header = value != null ? Map<String, String>.from(jsonDecode(value)) : null;
                    } catch (e) {
                      _selectedConfig.header = null;
                    }
                  },
                ),
          
                TextFormField(
                  key: UniqueKey(),
                  initialValue: _selectedConfig.queryParams != null ? jsonEncode(_selectedConfig.queryParams) : null,
                  decoration: const InputDecoration(
                    labelText: 'QueryParams (Optional JSON)',
                    hintText: '{"key1": "value1", "key2": "value2"}',
                  ),
                  minLines: null,
                  maxLines:  null,
                  validator: jsonValidator,
                  onSaved: (value) {
                    try {
                      _selectedConfig.header = value != null ? Map<String, String>.from(jsonDecode(value)) : null;
                    } catch (e) {
                      _selectedConfig.header = null;
                    }
                  },
                ),

                const SizedBox(height: 56) // add some extra space for the FAB
              ],
            ),
          ),
        ],
      ),
    );
  }
}

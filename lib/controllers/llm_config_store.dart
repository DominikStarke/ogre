import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ogre/llm_providers/const.dart';

class LlmConfigStore {
  final String _storeKey = "llm_config_store";
  late final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true)
  );

  LlmConfigStoreModel get _defaultConfig => LlmConfigStoreModel(
    isDefault: true,
    name: "Default"
  );

  Future<List<LlmConfigStoreModel>> loadAll() async {
    final result = await _storage.read(key: _storeKey);

    if (result != null) {
      final List<dynamic> jsonList = jsonDecode(result);
      try {
        final configurations = jsonList.map((json) => LlmConfigStoreModel.fromJson(json)).toList();
        if (configurations.isEmpty) {
          return [_defaultConfig];
        }
        return configurations;
      } catch (e) {
        return [_defaultConfig];
      }
    } else {
      return [_defaultConfig];
    }
  }

  Future<void> saveAll(List<LlmConfigStoreModel> models) async {
    await _storage.write(key: _storeKey, value: jsonEncode(models.map((model) => model.toJson()).toList()));
  }
}

class LlmConfigStoreModel {
  LlmProviderType provider;
  String host;
  String model;
  String apiKey;
  bool isDefault;
  String name;
  Map<String, String>? header;
  String? organization;
  Map<String, String>? queryParams;

  LlmConfigStoreModel({
    this.provider = LlmProviderType.none,
    this.host = "",
    this.model = "",
    this.apiKey = "",
    this.isDefault = false,
    this.name = "Default Configuration",
    this.header,
    this.organization,
    this.queryParams,
  });

  static LlmConfigStoreModel fromJson(Map<String, dynamic> json) {
    return LlmConfigStoreModel(
      provider: LlmProviderType.values.where((element) => element.value == json['provider']).firstOrNull ?? LlmProviderType.none,
      host: json['host'] ?? "",
      model: json['model'] ?? "",
      apiKey: json['apiKey'] ?? "",
      isDefault: json['isDefault'] ?? false,
      name: json['name'] ?? "Default Configuration",
      header: (json['header'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, v as String)),
      organization: json['organization'],
      queryParams: (json['queryParams'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, v as String)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provider': provider.value,
      'host': host,
      'model': model,
      'apiKey': apiKey,
      'isDefault': isDefault,
      'name': name,
      'header': header,
      'organization': organization,
      'queryParams': queryParams,
    };
  }
}


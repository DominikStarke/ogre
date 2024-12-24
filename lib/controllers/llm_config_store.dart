import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io' show Platform;

import 'package:ogre/llm_providers/const.dart';


class LlmConfigStore {
  final String _storeKey = "llm_config_store";
  FlutterSecureStorage? __storage;
  FlutterSecureStorage get _storage {
    __storage = __storage ?? FlutterSecureStorage(aOptions: Platform.isAndroid
      ? const AndroidOptions(encryptedSharedPreferences: true)
      : AndroidOptions.defaultOptions
    );
    return __storage!;
  }

  Future<LlmConfigStoreModel> load () async {
    final result = await _storage.read(key: _storeKey);
    if(result != null) {
      return LlmConfigStoreModel.fromJson(jsonDecode(result));
    } else {
      return LlmConfigStoreModel();
    }
  }

  Future<void> save (LlmConfigStoreModel model) async {
    await _storage.write(key: _storeKey, value: jsonEncode(model.toJson()));
  }
}

class LlmConfigStoreModel {
  LlmProviderType defaultProvider;

  String owuiHost;
  String owuiModel;
  String owuiApiKey;

  String oaiHost;
  String oaiModel;
  String oaiApiKey;

  String anthropicHost;
  String anthropicModel;
  String anthropicApiKey;

  String ollamaHost;
  String ollamaModel;
  String ollamaApiKey;

  LlmConfigStoreModel({
    this.defaultProvider = LlmProviderType.none,
    this.owuiHost = "",
    this.owuiModel = "",
    this.owuiApiKey = "",

    this.oaiHost = "",
    this.oaiModel = "",
    this.oaiApiKey = "",
    
    this.anthropicHost = "",
    this.anthropicModel = "",
    this.anthropicApiKey = "",
    
    this.ollamaHost = "",
    this.ollamaModel = "",
    this.ollamaApiKey = "",
  });

  static LlmConfigStoreModel fromJson (Map<String, dynamic> json) {
    return LlmConfigStoreModel(
      defaultProvider: LlmProviderType.values.where((element) => element.value == json['defaultProvider']).firstOrNull ?? LlmProviderType.none,
      owuiHost: json['owuiHost'] ?? "",
      owuiModel: json['owuiModel'] ?? "",
      owuiApiKey: json['owuiApiKey'] ?? "",
      
      oaiHost: json['oaiHost'] ?? "",
      oaiModel: json['oaiModel'] ?? "",
      oaiApiKey: json['oaiApiKey'] ?? "",
      
      anthropicHost: json['anthropicHost'] ?? "",
      anthropicModel: json['anthropicModel'] ?? "",
      anthropicApiKey: json['anthropicApiKey'] ?? "",
      
      ollamaHost: json['ollamaHost'] ?? "",
      ollamaModel: json['ollamaModel'] ?? "",
      ollamaApiKey: json['ollamaApiKey'] ?? "",
    );
  }

  Map<String, dynamic> toJson () {
    return {
      'defaultProvider': defaultProvider.value,
      'owuiHost': owuiHost,
      'owuiModel': owuiModel,
      'owuiApiKey': owuiApiKey,

      'oaiHost': oaiHost,
      'oaiModel': oaiModel,
      'oaiApiKey': oaiApiKey,

      'anthropicHost': anthropicHost,
      'anthropicModel': anthropicModel,
      'anthropicApiKey': anthropicApiKey,

      'ollamaHost': ollamaHost,
      'ollamaModel': ollamaModel,
      'ollamaApiKey': ollamaApiKey,
    };
  }

  LlmConfigStoreModel clone () {
    return LlmConfigStoreModel(
      defaultProvider: defaultProvider,
      owuiHost: owuiHost,
      owuiModel: owuiModel,
      owuiApiKey: owuiApiKey,
      
      oaiHost: oaiHost,
      oaiModel: oaiModel,
      oaiApiKey: oaiApiKey,
      
      anthropicHost: anthropicHost,
      anthropicModel: anthropicModel,
      anthropicApiKey: anthropicApiKey,
      
      ollamaHost: ollamaHost,
      ollamaModel: ollamaModel,
      ollamaApiKey: ollamaApiKey,
    );
  }
}


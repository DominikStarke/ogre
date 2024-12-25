import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppConfigStore {
  final String _storeKey = "app_config_store";
  late final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true)
  );

  AppConfigStoreModel get _defaultConfig => AppConfigStoreModel(
    themeBrightness: "automatic",
    autoHide: false,
  );

  Future<AppConfigStoreModel> load() async {
    final result = await _storage.read(key: _storeKey);

    if (result != null) {
      try {
        final json = jsonDecode(result);
        return AppConfigStoreModel.fromJson(json);
      } catch (e) {
        return _defaultConfig;
      }
    } else {
      return _defaultConfig;
    }
  }

  Future<void> save(AppConfigStoreModel model) async {
    await _storage.write(key: _storeKey, value: jsonEncode(model.toJson()));
  }
}

class AppConfigStoreModel {
  String themeBrightness;
  bool autoHide;

  AppConfigStoreModel({
    this.themeBrightness = "automatic",
    this.autoHide = false,
  });

  static AppConfigStoreModel fromJson(Map<String, dynamic> json) {
    return AppConfigStoreModel(
      themeBrightness: json['themeBrightness'] ?? "automatic",
      autoHide: json['autoHide'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeBrightness': themeBrightness,
      'autoHide': autoHide,
    };
  }
}

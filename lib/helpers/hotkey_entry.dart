import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

class HotkeyEntry extends HotKey {
  final Function(HotKey)? onUp;
  final Function(HotKey)? onDown;
  
  HotkeyEntry({
    required LogicalKeyboardKey key,
    super.modifiers,
    super.scope,
    this.onUp,
    this.onDown
  }): super (key: key);

  Future<void> register() async {
    await hotKeyManager.register(this, keyDownHandler: onDown, keyUpHandler: onUp);
  }

  Future<void> unregister() async {
    await hotKeyManager.unregister(this);
  }
}


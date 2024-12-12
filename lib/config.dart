import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:ogre/controllers/window.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

WindowOptions windowOptions = const WindowOptions(
  size: Size(800, 60),
  titleBarStyle: TitleBarStyle.hidden,
  alwaysOnTop: true,
  skipTaskbar: true,
  center: true,
  windowButtonVisibility: false,
  maximumSize: Size(800, 60),
  minimumSize: Size(800, 60),
);

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

  register() {
    hotKeyManager.register(this, keyDownHandler: onDown, keyUpHandler: onUp);
  }

  unregister() {
    hotKeyManager.unregister(this);
  }
}

const trayIcon = 'assets/app_icon.png';

Menu getTrayMenuConfiguration (WindowControllerState controller) {
  return Menu(
    items: [
      MenuItem(
        key: 'exit_app',
        label: 'Exit',
        onClick: (menuItem) {
          controller.closeApplication();
        },
      ),
    ],
  );
}


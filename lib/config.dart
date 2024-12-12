import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:ogre/controllers/window.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

WindowOptions windowOptions = const WindowOptions(
  size: Size(300, 60),
  titleBarStyle: TitleBarStyle.hidden,
  alwaysOnTop: true,
  skipTaskbar: true,
  center: true,
  windowButtonVisibility: false,
  maximumSize: Size(300, 60),
  minimumSize: Size(300, 60),
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
        key: 'show_window',
        label: 'Show Window',
      ),
      MenuItem(
        key: 'hide_window',
        label: 'Hide Window',
      ),
      MenuItem.separator(),
      MenuItem.submenu(
        label: 'Submenu',
        submenu: Menu(
          items: [
            MenuItem(
              type: 'checkbox',
              key: 'submenu_item_1',
              label: 'Submenu Item 1',
            ),
            MenuItem(
              key: 'submenu_item_2',
              label: 'Submenu Item 2',
            ),
          ]
        )
      ),
      MenuItem(
        key: 'exit_app',
        label: 'Exit App',
        onClick: (menuItem) {
          controller.closeApplication();
        },
      ),
    ],
  );
}


import 'dart:async';
import 'dart:io' show exit;

import 'package:flutter/material.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:ogre/config.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class WindowController extends StatefulWidget {
  final Widget child;
  final Future<void> Function()? onTrayIconMouseDown;
  final void Function()? onTrayIconRightMouseDown;
  final void Function()? onTrayIconRightMouseUp;
  final void Function()? onWindowClose;
  final Future<void> Function(MenuItem menuItem)? onTrayMenuItemClick;
  final WindowOptions? windowOptions;
  final List<HotkeyEntry> hotkeys;
  final Function(WindowControllerState)? getTrayMenuConfiguration;
  final String appIcon;

  const WindowController({
    super.key,
    required this.child,
    this.onTrayIconMouseDown,
    this.onTrayIconRightMouseDown,
    this.onTrayIconRightMouseUp,
    this.onWindowClose,
    this.onTrayMenuItemClick,
    this.windowOptions,
    this.getTrayMenuConfiguration,
    this.hotkeys = const [],
    required this.appIcon,
  });

  @override
  State<WindowController> createState() => WindowControllerState();

  static WindowControllerState of(BuildContext context) {
    final state = context.findAncestorStateOfType<WindowControllerState>();
    if(state == null) {
      throw Exception('WindowListenerWidget not found in context');
    }
    return state;
  }
}

class WindowControllerState extends State<WindowController> with TrayListener, WindowListener {

  @override
  initState() {
    trayManager.addListener(this);
    super.initState();
    _init();
  }

  Future<void> _init () async {
    WidgetsFlutterBinding.ensureInitialized();
    await hotKeyManager.unregisterAll(); // Ensure no hotkeys are unregistered on hot reload
    await windowManager.ensureInitialized();

    windowManager.waitUntilReadyToShow(widget.windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });

    await trayManager.setIcon(widget.appIcon);

    await _setTrayConfiguration();
    
    for (var hotkey in widget.hotkeys) {
      hotkey.register();
    }
  }

  Future<void> _setTrayConfiguration () async {
    if(widget.getTrayMenuConfiguration != null) {
      await trayManager.setContextMenu(widget.getTrayMenuConfiguration?.call(this));
    }
  }

  Future<void> hide() async {
    await windowManager.hide();
  }

  @override
  void onTrayIconMouseDown() async {
    if (widget.onTrayIconMouseDown != null) {
      await widget.onTrayIconMouseDown!();
    }
  }

  @override
  void onTrayIconRightMouseDown() {
    if (widget.onTrayIconRightMouseDown != null) {
      widget.onTrayIconRightMouseDown!();
    }
  }

  @override
  void onTrayIconRightMouseUp() {
    trayManager.popUpContextMenu();
    // if (widget.onTrayIconRightMouseUp != null) {
    //   widget.onTrayIconRightMouseUp!();
    // }
  }

  @override
  void onWindowClose() {
    if (widget.onWindowClose != null) {
      widget.onWindowClose!();
    }
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    if (widget.onTrayMenuItemClick != null) {
      await widget.onTrayMenuItemClick!(menuItem);
    }
  }

  void closeApplication([code = 0]) {
    exit(code);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
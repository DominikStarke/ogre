import 'dart:async';
import 'dart:io' show exit;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:ogre/controllers/clipboard.dart';
import 'package:ogre/helpers/hotkey_entry.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'package:ogre/controllers/app_config_store.dart';

class AppController extends StatefulWidget {
  final Widget child;
  final Widget? loading;

  const AppController({
    super.key,
    required this.child,
    this.loading
  });

  @override
  State<AppController> createState() => AppControllerState();

  static AppControllerState of(BuildContext context) {
    final state = context.findAncestorStateOfType<AppControllerState>();
    if(state == null) {
      throw Exception('WindowListenerWidget not found in context');
    }
    return state;
  }
}

class AppControllerState extends State<AppController> with TrayListener, WindowListener, WidgetsBindingObserver {

  final WindowOptions _windowOptions = const WindowOptions(
    size: Size(900, 600),
    titleBarStyle: TitleBarStyle.hidden,
    alwaysOnTop: true,
    skipTaskbar: true,
    center: false,
    windowButtonVisibility: false,
  );

  final ClipboardController clipboard = ClipboardController();

  final _configStore = AppConfigStore();
  bool _initialized = false;
  AppConfigStoreModel _config = AppConfigStoreModel();
  AppConfigStoreModel get config => _config;

  @override
  initState() {
    trayManager.addListener(this);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  @override dispose() {
    trayManager.removeListener(this);
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    clipboard.dispose();
  }

  Future<void> _init () async {
    WidgetsFlutterBinding.ensureInitialized();
    await loadConfig();
    
    try {
      await hotKeyManager.unregisterAll(); // Ensure no hotkeys are unregistered on hot reload
      await windowManager.ensureInitialized();
      await trayManager.setIcon('assets/app_icon.png');
      await _setTrayConfiguration();
      windowManager.waitUntilReadyToShow(_windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
      HotkeyEntry(
        key: LogicalKeyboardKey.home,
        modifiers: [HotKeyModifier.shift],
        scope: HotKeyScope.system,
        onUp: _onActivate
      ).register();
    } catch(e) {
      /// Skip unsupported platforms
    }
    
    setState(() {
      _initialized = true;
    });
  }

  Future<void> loadConfig() async {
    _config = await _configStore.load();
    setState(() {});
  }

  Future<void> saveConfig() async {
    await _configStore.save(_config);
  }

  Future<void> _setTrayConfiguration () async {
    await trayManager.setContextMenu(Menu(
      items: [
        MenuItem(
          key: 'exit_app',
          label: 'Exit',
          onClick: (menuItem) {
            closeApplication();
          },
        ),
      ],
    ));
  }

  Future<void> _onActivate (HotKey hotKey) async {
    if(await windowManager.isVisible()) {
      _hide();
    } else {
      _show();
    }
  }

  Future<void> _hide() async {
    await windowManager.hide();
  }

  Future<void> _show() async {
    await windowManager.show();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.inactive && _config.autoHide) {
      _hide();
    } else {
      // clipboard.update();
    }
  }

  @override
  void didUpdateWidget(AppController oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _initialized = false;
    });
    _init();
  }

  @override
  void onTrayIconMouseUp() async {
    if(await windowManager.isVisible()) {
      _hide();
    } else {
      await windowManager.show();
    }
  }

  @override
  void onTrayIconRightMouseDown() {

  }

  @override
  Future<void> onTrayIconRightMouseUp() async {
    await trayManager.popUpContextMenu();
  }

  @override
  void onWindowClose() {

  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {

  }

  void closeApplication([code = 0]) {
    exit(code);
  }

  @override
  Widget build(BuildContext context) {
    if(_initialized) {
      return widget.child;
    } else {
      return widget.loading ?? Container();
    }
  }
}

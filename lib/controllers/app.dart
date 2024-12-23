import 'dart:async';
import 'dart:io' show exit;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:keypress_simulator/keypress_simulator.dart';
import 'package:ogre/llm_providers/openwebui.dart';
import 'package:ogre/config.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class AppController extends StatefulWidget {
  final Widget child;

  const AppController({
    super.key,
    required this.child,
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

class AppControllerState extends State<AppController> with TrayListener, WindowListener, ChangeNotifier {
  bool _initialized = false;
  ClipboardData? clipboardData;

  final WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 600),
    titleBarStyle: TitleBarStyle.hidden,
    alwaysOnTop: true,
    skipTaskbar: true,
    center: false,
    windowButtonVisibility: false,
    maximumSize: Size(800, 600),
    minimumSize: Size(800, 600),
  );

  late LlmProvider llmProvider = OpenwebuiProvider(
    host: 'http://localhost:3000',
    model: 'llama3.1:latest',
    apiKey: dotenv.get('OPENWEBUI_API_KEY'),
  );

  @override
  initState() {
    trayManager.addListener(this);
    super.initState();
    _init();
  }

  Future<void> _init () async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");
    await hotKeyManager.unregisterAll(); // Ensure no hotkeys are unregistered on hot reload
    await windowManager.ensureInitialized();
    await trayManager.setIcon('assets/app_icon.png');
    await _setTrayConfiguration();
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
    HotkeyEntry(
      key: LogicalKeyboardKey.home,
      modifiers: [HotKeyModifier.shift],
      scope: HotKeyScope.system,
      onUp: onActivate
    ).register();
    setState(() {
      _initialized = true;
    });
  }

  clearChat() {
    llmProvider = OpenwebuiProvider(
      host: 'http://localhost:3000',
      model: 'qwen2.5:latest',
      apiKey: dotenv.get('OPENWEBUI_API_KEY'),
    );
    notifyListeners();
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

  Future<void> onActivate (HotKey hotKey) async {
    if(await windowManager.isVisible()) {
      hide();
    } else {
      await Future.delayed(const Duration(milliseconds: 20));
      await keyPressSimulator.simulateKeyDown(
        PhysicalKeyboardKey.keyC,
        [ModifierKey.metaModifier],
      );
      await Future.delayed(const Duration(milliseconds: 20));
      await keyPressSimulator.simulateKeyUp(
        PhysicalKeyboardKey.keyC,
        [ModifierKey.metaModifier],
      );
      await Future.delayed(const Duration(milliseconds: 20));
      
      clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      windowManager.show();
    }
  }

  Future<void> hide() async {
    await windowManager.hide();
  }

  @override
  void didUpdateWidget(covariant AppController oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _initialized = false;
    });
    _init();
  }

  @override
  void onTrayIconMouseDown() async {

  }

  @override
  void onTrayIconRightMouseDown() {

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
      return Container();
    }
  }
}
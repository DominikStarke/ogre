import 'package:flutter/material.dart';
import 'package:ogre/controllers/llm.dart';

class AppMenu extends StatelessWidget {
  const AppMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListenableBuilder(
      listenable: LlmController.of(context).configChanged,
      builder: (context, result) {
        final configs = LlmController.of(context).configs;
        return Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: PopupMenuButton<String>(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(scheme.surfaceContainerLowest.withValues(alpha: .5)),
            ),
            onSelected: (String result) {
              if(result == 'go_to_settings') {
                Navigator.pushNamed(context, "/settings");
              } else if(result == 'clear_chat') {
                LlmController.of(context).clearChat();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'go_to_settings',
                child: Text('Settings'),
              ),
              
              const PopupMenuDivider(),

              ...configs.map((config) {
                return CheckedPopupMenuItem(
                  checked: config.isDefault,
                  value: configs.indexOf(config).toString(),
                  child: Text(config.name),
                  onTap: () {
                    LlmController.of(context).configure(config);
                  },
                );
              }),

              const PopupMenuDivider(),
              
              PopupMenuItem<String>(
                value: 'clear_chat',
                child: Text('Clear chat', style: TextStyle(color: scheme.error)),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
        );
      }
    );
  }
}

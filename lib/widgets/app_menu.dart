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
          padding: const EdgeInsets.all(10.0),
          child: MenuAnchor(
            consumeOutsideTap: true,
            builder: (context, controller, widget) {
              return IconButton(
                icon: const Icon(Icons.more_vert),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(scheme.surfaceContainerLowest),
                ),
                color: scheme.tertiary,
                onPressed: () {
                  if(controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
              );
            },
            menuChildren: [
              MenuItemButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/settings");
                },
                child: const Text('Settings'),
              ),

              const Divider(),

              ...configs.map((config) {
                return MenuItemButton(
                  onPressed: () {
                    LlmController.of(context).configure(config);
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        value: config.isDefault,
                        onChanged: (bool? value) {
                          LlmController.of(context).configure(config);
                        },
                      ),
                      Text(config.name),
                    ],
                  ),
                );
              }),

              const Divider(),

              MenuItemButton(
                onPressed: () {
                  LlmController.of(context).clearChat();
                },
                child: Text('Clear chat', style: TextStyle(color: scheme.error)),
              ),
            ],
          ),
        );
      }
    );
  }
}

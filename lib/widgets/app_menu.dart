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
        final controller =  LlmController.of(context);
        final configs = controller.configs;
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

              for(final config in configs) MenuItemButton(
                onPressed: () {
                  controller.configure(config);
                  controller.saveConfigs(configs);
                },
                child: Row(
                  children: [
                    Checkbox(
                      value: config.isDefault,
                      onChanged: (bool? value) {
                        controller.configure(config);
                        controller.saveConfigs(configs);
                      },
                    ),
                    Text(config.name),
                  ],
                ),
              ),

              const Divider(),

              MenuItemButton(
                onPressed: () {
                  controller.clearChat();
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

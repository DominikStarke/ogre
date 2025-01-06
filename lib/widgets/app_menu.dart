import 'package:flutter/material.dart';
import 'package:ogre/controllers/llm.dart';

class AppMenu extends StatelessWidget {
  const AppMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    toggleModleSelection(String model) {
      final controller = LlmController.of(context);
      if(controller.modelSelection.contains(model)) {
        final models = controller.modelSelection;
        models.remove(model);
        controller.modelSelection = models;
      } else {
        controller.modelSelection = [...controller.modelSelection, model];
      }
    }

    return ListenableBuilder(
      listenable: LlmController.of(context).configChanged,
      builder: (context, result) {
        final controller =  LlmController.of(context);
        final configs = controller.configs;
        return ListenableBuilder(
          listenable: controller.modelListNotifier,
          builder: (context, _) {
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

                  const PopupMenuItem(
                    enabled: false,
                    child: Text("Models")
                  ),

                  for(final model in controller.models) MenuItemButton(
                    onPressed: () {
                      toggleModleSelection(model);
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          value: controller.modelSelection.contains(model),
                          onChanged: (bool? value) {
                            toggleModleSelection(model);
                          },
                        ),
                        Text(model),
                      ],
                    ),
                  ),

                  const Divider(),
            
                  const PopupMenuItem(
                    enabled: false,
                    child: Text("Providers")
                  ),

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
                        Text("(${config.provider.value}) ${config.name}"),
                      ],
                    ),
                  ),
            
                  const PopupMenuDivider(),
            
                  MenuItemButton(
                    onPressed: () {
                      controller.deleteChat();
                    },
                    child: Text('Delete Chat', style: TextStyle(color: scheme.error)),
                  ),
                ],
              ),
            );
          }
        );
      }
    );
  }
}

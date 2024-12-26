import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:ogre/controllers/app.dart';
import 'package:ogre/controllers/llm.dart';

class ClipboardMenu extends StatelessWidget {
  const ClipboardMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final clipboard = AppController.of(context).clipboard;
    return ListenableBuilder(
      listenable: clipboard,
      builder: (context, result) {
        final scheme = Theme.of(context).colorScheme;
        final attachments = [...clipboard.files, ...clipboard.texts, ...clipboard.images];

        if(attachments.isEmpty) {
          return const SizedBox();
        }

        return Padding(
          padding: const EdgeInsets.all(10),
          child: MenuAnchor(
            builder: (context, controller, widget) {
              return IconButton(
                icon: const Icon(Icons.content_paste_rounded),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(scheme.tertiary),
                ),
                color: scheme.onTertiary,
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
              ...attachments.map((attachment) {

                return MenuItemButton(
                  
                  onPressed: () {
                    LlmController.of(context).clearChat();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(attachment.name, textAlign: TextAlign.start),
                      Text((attachment as FileAttachment).mimeType, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                );
              }),

              const Divider(),

              MenuItemButton(
                onPressed: () {
                  LlmController.of(context).clearChat();
                },
                child: Text('Clear', style: TextStyle(color: scheme.error)),
              ),
            ],
          ),
        );
      }
    );
  }
}

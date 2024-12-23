import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ogre/controllers/llm_controller.dart';
import 'package:ogre/widgets/app_menu.dart';

class OgreChat extends StatelessWidget {
  const OgreChat({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LlmController.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: const AppMenu(),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final scheme = Theme.of(context).colorScheme;
          final buttonTheme = Theme.of(context).buttonTheme;
          return LlmChatView(
            messageSender: controller.clipboardAttachmentSender,
            provider: controller.llmProvider,
            style: LlmChatViewStyle(
              backgroundColor: scheme.surfaceContainerLowest,
              progressIndicatorColor: scheme.onPrimaryContainer,
              userMessageStyle: UserMessageStyle(
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)
                  ),
                ),
                textStyle: TextStyle(color: scheme.onPrimaryContainer)
              ),
              llmMessageStyle: LlmMessageStyle(
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHigh,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)
                  ),
                ),
                markdownStyle: MarkdownStyleSheet.fromTheme(Theme.of(context))
              ),
              chatInputStyle: ChatInputStyle(
                backgroundColor: scheme.surfaceContainerLowest,
                decoration: BoxDecoration(
                  border: Border.all(color: scheme.surfaceBright, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                textStyle: TextStyle(color: scheme.onSurface),
                hintStyle: TextStyle(color: scheme.surfaceContainerHighest),
              ),
              addButtonStyle: ActionButtonStyle(
                icon: Icons.add,
                iconColor: buttonTheme.colorScheme?.onPrimary,
                iconDecoration: BoxDecoration(
                  color: buttonTheme.colorScheme?.primary,
                  shape: BoxShape.circle,
                ),
              ),
              attachFileButtonStyle: ActionButtonStyle(
                icon: Icons.attach_file,
                iconColor: buttonTheme.colorScheme?.onPrimary,
                iconDecoration: BoxDecoration(
                  color: buttonTheme.colorScheme?.primary,
                  shape: BoxShape.circle,
                ),
              ),
              cameraButtonStyle: ActionButtonStyle(
                icon: Icons.camera_alt,
                iconColor: buttonTheme.colorScheme?.onPrimary,
                iconDecoration: BoxDecoration(
                  color: buttonTheme.colorScheme?.primary,
                  shape: BoxShape.circle,
                ),
              ),
              stopButtonStyle: ActionButtonStyle(
                icon: Icons.stop,
                iconColor: buttonTheme.colorScheme?.onError,
                iconDecoration: BoxDecoration(
                  color: buttonTheme.colorScheme?.error,
                  shape: BoxShape.circle,
                ),
              ),
              closeButtonStyle: ActionButtonStyle(
                icon: Icons.close,
                iconColor: buttonTheme.colorScheme?.onPrimary,
                iconDecoration: BoxDecoration(
                  color: buttonTheme.colorScheme?.primary,
                  shape: BoxShape.circle,
                ),
              ),
              cancelButtonStyle: ActionButtonStyle(
                icon: Icons.cancel,
                iconColor: buttonTheme.colorScheme?.onPrimary,
                iconDecoration: BoxDecoration(
                  color: buttonTheme.colorScheme?.primary,
                  shape: BoxShape.circle,
                ),
              ),
              copyButtonStyle: ActionButtonStyle(
                icon: Icons.copy,
                iconColor: buttonTheme.colorScheme?.onPrimary,
                iconDecoration: BoxDecoration(
                  color: buttonTheme.colorScheme?.primary,
                  shape: BoxShape.circle,
                ),
              ),
              editButtonStyle: ActionButtonStyle(
                icon: Icons.edit,
                iconColor: buttonTheme.colorScheme?.onPrimary,
                iconDecoration: BoxDecoration(
                  color: buttonTheme.colorScheme?.primary,
                  shape: BoxShape.circle,
                ),
              ),
              galleryButtonStyle: ActionButtonStyle(
                icon: Icons.photo,
                iconColor: buttonTheme.colorScheme?.onPrimary,
                iconDecoration: BoxDecoration(
                  color: buttonTheme.colorScheme?.primary,
                  shape: BoxShape.circle,
                ),
              ),
              recordButtonStyle: ActionButtonStyle(
                icon: Icons.mic,
                iconColor: buttonTheme.colorScheme?.onPrimary,
                iconDecoration: BoxDecoration(
                  color: buttonTheme.colorScheme?.primary,
                  shape: BoxShape.circle,
                ),
              ),
              submitButtonStyle: ActionButtonStyle(
                icon: Icons.send,
                iconColor: buttonTheme.colorScheme?.onPrimary,
                iconDecoration: BoxDecoration(
                  color: buttonTheme.colorScheme?.primary,
                  shape: BoxShape.circle,
                ),
              ),
              closeMenuButtonStyle: ActionButtonStyle(
                icon: Icons.close,
                iconColor: buttonTheme.colorScheme?.onPrimary,
                iconDecoration: BoxDecoration(
                  color: buttonTheme.colorScheme?.primary,
                  shape: BoxShape.circle,
                ),
              ),
              actionButtonBarDecoration: BoxDecoration(
                color: scheme.surfaceContainerLowest,
              ),
              fileAttachmentStyle: const FileAttachmentStyle(),
              suggestionStyle: SuggestionStyle(
                decoration: BoxDecoration(
                  color: scheme.onError,
                ),
              ),
            )
          );
        }
      ),
    );
  }
}

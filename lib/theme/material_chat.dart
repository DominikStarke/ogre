import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

LlmChatViewStyle materialChatThemeOf (BuildContext context) {
  final theme = Theme.of(context);
  final scheme = theme.colorScheme;
  final buttonTheme = theme.buttonTheme;
  
  return LlmChatViewStyle(
    backgroundColor: theme.scaffoldBackgroundColor,
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
      textStyle: TextStyle(color: scheme.onSurface),
    ),
    llmMessageStyle: LlmMessageStyle(
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20)
        ),
      ),
      markdownStyle: MarkdownStyleSheet.fromTheme(theme),
      iconColor: scheme.onTertiary,
      iconDecoration: BoxDecoration(
        color: scheme.tertiary,
        shape: BoxShape.circle,
      ),
    ),
    chatInputStyle: ChatInputStyle(
      backgroundColor: theme.scaffoldBackgroundColor,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        border: Border.all(color: scheme.outline, width: 1),
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
      iconColor: buttonTheme.colorScheme?.surface,
      iconDecoration: const BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
      ),
    ),
    cancelButtonStyle: ActionButtonStyle(
      icon: Icons.cancel,
      iconColor: buttonTheme.colorScheme?.onError,
      iconDecoration: BoxDecoration(
        color: buttonTheme.colorScheme?.error,
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
      iconColor: buttonTheme.colorScheme?.onTertiary,
      iconDecoration: BoxDecoration(
        color: buttonTheme.colorScheme?.tertiary,
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
      iconColor: buttonTheme.colorScheme?.onError,
      iconDecoration: BoxDecoration(
        color: buttonTheme.colorScheme?.error,
        shape: BoxShape.circle,
      ),
    ),
    actionButtonBarDecoration: const BoxDecoration(
      color: Colors.transparent,
    ),
    fileAttachmentStyle: FileAttachmentStyle(
      decoration: BoxDecoration(
        color: scheme.tertiary,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      filenameStyle: TextStyle(color: scheme.onTertiary),
      filetypeStyle: TextStyle(color: scheme.onTertiary.withValues(alpha: .5)),
      iconDecoration: BoxDecoration(
        color: scheme.surfaceContainer,
        shape: BoxShape.circle,
      ),
      iconColor: scheme.onSurface,
    ),
    suggestionStyle: SuggestionStyle(
      decoration: BoxDecoration(
        color: scheme.onError,
      ),
    ),
  );
}
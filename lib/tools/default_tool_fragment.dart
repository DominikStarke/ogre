import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

class DefaultToolFragment extends ChatMessageFragment {
  final String? title;
  final String? subTitle;
  final Widget body;
  final IconData icon;

  DefaultToolFragment({
    this.title,
    this.subTitle,
    required this.body,
    this.icon = Icons.auto_awesome,
  });

  @override
  Widget builder(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      key: key,
      color: theme.colorScheme.tertiaryContainer,

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.colorScheme.onTertiaryContainer),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(title != null) Text(title!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onTertiaryContainer
                    )
                  ),
                  if(subTitle != null) Text(subTitle!, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onTertiaryContainer)
                  ),
                  Flexible(
                    child: DefaultTextStyle(
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onTertiaryContainer
                      ) ?? const TextStyle(),
                      child: body
                    ), // Text(body, softWrap: true, style: TextStyle(color: theme.colorScheme.onTertiaryContainer)),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}

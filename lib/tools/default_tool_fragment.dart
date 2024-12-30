import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

class DefaultToolFragment extends ChatMessageFragment {
  final String title;
  final String subTitle;
  final Widget body;

  const DefaultToolFragment({
    required this.title,
    required this.subTitle,
    required this.body,
  });

  @override
  Widget builder(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.tertiaryContainer,

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.auto_awesome, color: theme.colorScheme.onTertiaryContainer,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(title,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onTertiaryContainer
                      ))
                    ),
                    Flexible(
                      child: Text(subTitle, softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onTertiaryContainer)
                      ),
                    ),
                  ],
                ),
              ],
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
      )
    );
  }
}

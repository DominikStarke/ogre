import 'package:flutter/material.dart';
import 'package:ogre/llm_providers/tool.dart';
import 'package:ogre/tools/default_tool_fragment.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchImagesTool extends LlmTool {
  @override
  String get functionName => 'searchImages';

  @override
  Future<void> call(LlmToolCall call) async {
    final queries = call.parameters["queries"];
    if(queries is List) {
      for(final query in queries) {
        final uri = Uri(
          scheme: 'http',
          host: 'localhost',
          path: 'search',
          port: 4000,
          queryParameters: {
            "q": query,
            "language": "all",
            "time_range": "",
            "safesearch": "0",
            "categories": "images"
          }
        );
        await launchUrl(uri);
        break; // Break the loop after one iteration
      }
    }
  }

  @override
  DefaultToolFragment getFrament(LlmToolCall call) {
    return DefaultToolFragment(
      title: call.functionName,
      subTitle: call.task,
      body: Text('Searching the web for: ${call.parameters["queries"].join(', ')}'),
    );
  }
}

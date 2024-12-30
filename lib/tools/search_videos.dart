import 'package:flutter/material.dart';
import 'package:ogre/llm_providers/tool.dart';
import 'package:ogre/tools/default_tool_fragment.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchVideosTool extends LlmTool {
  @override
  String get functionName => 'searchVideos';

  launch(String query) async {
    final url = Uri(
      scheme: 'https',
      host: 'www.youtube.com',
      path: 'results',
      queryParameters: {
        "search_query": query,
      }
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Future<void> call(LlmToolCall call) async {
    final queries = call.parameters["queries"];

    if(queries is List) {
      for(final query in queries) {
        launch(query);
        break; // Break the loop after one iteration
      }
    }
  }

  @override
  DefaultToolFragment getFrament(LlmToolCall call) {
    return DefaultToolFragment(
      title: call.functionName,
      subTitle: call.task,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for(final query in call.parameters["queries"])
            TextButton(
              onPressed: () => launch(query),
              child: Text(query)
            ),
        ],
      ),
    );
  }
}

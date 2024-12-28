import 'dart:developer';
import 'package:ogre/llm_providers/tool.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchWebTool extends LlmTool {
  @override
  String get functionName => 'searchWeb';

  @override
  Future<void> call(LlmToolCall call) async {
    final queries = call.parameters["queries"];
    log('SearchWebTool called with: $queries');
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
            "categories": "general"
          }
        );
        await launchUrl(uri);
        break; // Break the loop after one iteration
      }
    }
  }
}

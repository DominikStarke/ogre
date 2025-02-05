import 'package:flutter/material.dart';
import 'package:ogre/llm_providers/tool.dart';
import 'package:ogre/tools/default_tool_fragment.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenBrowserTool extends LlmTool {
  @override
  String get toolName => 'openBrowser';

  @override
  Future<void> call(LlmToolCall call) async {
    final url = call.parameters['url'];
    if (url is String) {
      final uri = Uri.parse(url);
      await launchUrl(uri);
    }
  }

  @override
  Widget getFrament(LlmToolCall call) {
    return DefaultToolFragment(
      // title: call.functionName,
      // subTitle: call.task,
      icon: Icons.open_in_browser,
      body: Text(call.parameters['url'] ?? ""),
    );
  }
}

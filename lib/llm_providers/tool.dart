import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

/// The LlmTool class represents a tool that can be called by the ToolProvider.
/// Each tool must implement the `functionName` getter and the `call` method.
abstract class LlmTool {
  /// The name of the function that this tool implements.
  /// It is crucial that this matches the `functionName` in the corresponding `LlmToolCall` instance.
  /// If the names do not match, the ToolProvider will not be able to find and invoke the correct tool.
  String get toolName;

  /// The method that will be called when this tool is invoked.
  /// 
  /// [call] - The LlmToolCall instance containing the task, function name, and parameters.
  Future<void> call(LlmToolCall call);

  Widget getFrament(LlmToolCall call);
}

/// The LlmToolCall class represents a call to a tool with specific parameters.
class LlmToolCall {
  /// A text description of the tool called.
  final String task;

  /// The name of the function to be called.
  /// It is crucial that this matches the `functionName` of the corresponding `LlmTool` implementation.
  /// If the names do not match, the ToolProvider will not be able to find and invoke the correct tool.
  final String functionName;

  /// The parameters required for the function call.
  final Map<String, dynamic> parameters;

  LlmToolCall({
    required this.task,
    required this.functionName,
    required this.parameters,
  });

  /// Creates an LlmToolCall instance from a JSON map.
  /// 
  /// [json] - The JSON map containing the task, function name, and parameters.
  static LlmToolCall? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    try {
      return LlmToolCall(
        task: json['task'],
        functionName: json['function'],
        parameters: Map<String, dynamic>.from(json['parameters']),
      );
    } catch (e) {
      return null;
    }
  }

  /// Creates an LlmToolCall instance from a JSON string.
  /// 
  /// [jsonString] - The JSON string containing the task, function name, and parameters.
  static LlmToolCall? fromJsonString(String jsonString) {
    try {
      final jsonData = json.decode(jsonString);
      return LlmToolCall.fromJson(jsonData);
    } catch (e) {
      return null;
    }
  }
}

/// The ToolProvider class wraps other providers to enable the execution of user-defined tools.
/// 
/// In the context of large language models (LLMs), tool calling allows the model to invoke specific tools
/// to perform tasks that require specialized knowledge or capabilities. The ToolProvider class acts as a
/// middleware that intercepts messages, detects tool call patterns, and delegates the execution to the
/// appropriate tool. This enables the integration of various tools with LLMs, enhancing their functionality
/// and allowing them to perform complex tasks.
///
/// The `searchPattern` parameter is a regular expression pattern used to detect tool call requests within
/// the message content. The `stopPattern` parameter is used to identify the end of a tool call request.
/// The `searchPattern` is only used if the `stopPattern` is found in the message content.
///
/// Usage:
/// ```
/// ToolProvider(
///   provider: OpenAiProvider(...),
///   tools: [
///     SearchWebTool(),
///     SearchVideosTool(),
///     SearchImagesTool(),
///   ],
///   searchPattern: r"<flutter_tool>([\s\S]*?)<\/flutter_tool>", // optional
///   stopPattern: "</flutter_tool>" // optional
/// )
/// ```
class ToolProvider extends LlmProvider with ChangeNotifier {
  final LlmProvider _provider;
  final List<LlmTool> _tools;
  final String _startPattern;
  final String _stopPattern;

  String get stopPattern => _stopPattern;
  String get startPattern => _startPattern;

  /// Creates a ToolProvider instance.
  /// 
  /// [provider] - The LLM provider to wrap.
  /// [tools] - A list of tools that can be called.
  /// [searchPattern] - A regular expression pattern used to detect tool call requests within the message content.
  /// [stopPattern] - A pattern used to identify the end of a tool call request.
  ToolProvider({
    required LlmProvider provider,
    List<LlmTool> tools = const [],
    String stopPattern = "</flutter_tool>",
    String startPattern = "<flutter_tool>",
  }): _provider = provider, _startPattern = startPattern, _stopPattern = stopPattern, _tools = tools {
    _provider.addListener(notifyListeners);
  }

  final StringBuffer _messageBuffer = StringBuffer();

  @override
  Stream<String> generateStream(String prompt, {Iterable<Attachment> attachments = const []}) async* {
    final stream = _provider.sendMessageStream(prompt, attachments: attachments);

    await for (final chunk in stream) {
      _checkTool(chunk);
      yield chunk;
    }

    _messageBuffer.clear();
  }

  @override
  Stream<String> sendMessageStream(String prompt, {Iterable<Attachment> attachments = const []}) async* {
    final stream = _provider.sendMessageStream(prompt, attachments: attachments);

    await for (final chunk in stream) {
      _checkTool(chunk);
      yield chunk;
    }

    _messageBuffer.clear();
  }

  /// Checks if a tool needs to be called based on the message content.
  /// If a tool call pattern is detected, it extracts the tool call information and invokes the tool.
  bool _checkTool(String chunk) {
    _messageBuffer.write(chunk);
    final message = _messageBuffer.toString();

    if (message.contains(_stopPattern) && message.contains(startPattern)) {
      final startBlocks = message.split(_startPattern); // guaranteed len 2
      
      for (final block in startBlocks) {
        final isStopBlock = block.contains(_stopPattern);
        if(isStopBlock) {
          final blocks = block.split(_stopPattern);
          _callTool(LlmToolCall.fromJsonString(blocks.first));
        }
      }
      _messageBuffer.clear();
    }
    return false;
  }

  /// Calls the appropriate tool based on the LlmToolCall instance.
  /// 
  /// [call] - The LlmToolCall instance containing the task, function name, and parameters.
  void _callTool(LlmToolCall? call) {
    if(call == null) return;
    final tool = _tools.where((t) => t.toolName == call.functionName).firstOrNull;

    if(tool != null) {
      history.last.leading.add(tool.getFrament(call));
      tool.call(call);
    } else {
      log("Tool ${call.functionName} not found. Parameters: ${call.parameters}");
    }
  }

  @override
  get history => _provider.history;

  @override
  set history(history) {
    _provider.history = history;
  }
}

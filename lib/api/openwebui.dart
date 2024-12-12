import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

/// A class representing a chat interface for an OpenWebUI compatible API.
class OWChat {
  final String apiKey;
  final String apiUrl;
  final String defaultModel;
  List<Message> _history = [];

  /// Creates an instance of [OWChat].
  ///
  /// [apiKey] is the API key for authentication.
  /// [apiUrl] is the base URL of the API.
  /// [defaultModel] is the default model to be used for the chat.
  OWChat({required this.apiKey, this.apiUrl = 'http://localhost:3000/api/chat/completions', this.defaultModel = 'llama3.1'});

  /// Sends a chat message and returns a stream of responses.
  ///
  /// [content] is the message content to be sent.
  /// [model] is the model to be used for the chat. Defaults to the instance's default model.
  Stream<String> chat(String content, {String? model}) async* {
    _history.add(Message(role: "user", content: content));

    final request = http.Request('POST', Uri.parse(apiUrl))
      ..headers.addAll({
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      })
      ..body = jsonEncode(ChatRequest(model: model ?? defaultModel, messages: _history).toJson());

    final streamedResponse = await http.Client().send(request);

    if (streamedResponse.statusCode == 200) {
      final responseStream = streamedResponse.stream.transform(utf8.decoder);
      StringBuffer completeResponse = StringBuffer();

      await for (var chunk in responseStream) {
        final messages = chunk.split('\n');
        for (var message in messages) {
          if (message.startsWith('data: [DONE]')) {
            _history.add(Message(role: "assistant", content: completeResponse.toString()));
            yield '';
            return;
          }
          if (message.isEmpty) continue;
          final cleanedMessage = message.replaceFirst('data: ', '').trim();
          try {
            final chatResponse = ChatResponse.fromJson(jsonDecode(cleanedMessage));
            for (var choice in chatResponse.choices) {
              final content = choice.message.content ?? '';
              completeResponse.write(content);
              yield content;
            }
          } catch (e) {
            print('Error decoding message: $cleanedMessage');
          }
        }
      }
    } else {
      throw Exception('Failed to load response');
    }
  }

  /// Lists available models from the API.
  Future<List<String>> listModels() async {
    final response = await http.get(
      Uri.parse('$apiUrl/models'),
      headers: {
        'Authorization': 'Bearer $apiKey',
      },
    );

    if (response.statusCode == 200) {
      final models = jsonDecode(response.body) as List;
      return models.map((model) => model.toString()).toList();
    } else {
      throw Exception('Failed to load models');
    }
  }

  void clear () {
    _history = [];
  }
}

/// A class representing a message in the chat.
class Message {
  final String? role;
  final String? content;

  /// Creates an instance of [Message].
  ///
  /// [role] is the role of the message sender (e.g., "user").
  /// [content] is the content of the message.
  Message({required this.role, required this.content});

  /// Converts the [Message] instance to a JSON object.
  Map<String, dynamic> toJson() => {
    'role': role,
    'content': content,
  };

  /// Creates an instance of [Message] from a JSON object.
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      role: json['role'] ?? 'assistant',
      content: json['delta']?['content'],
    );
  }
}

/// A class representing a chat request.
class ChatRequest {
  final String model;
  final List<Message> messages;

  /// Creates an instance of [ChatRequest].
  ///
  /// [model] is the model to be used for the chat.
  /// [messages] is the list of messages in the chat history.
  ChatRequest({required this.model, required this.messages});

  /// Converts the [ChatRequest] instance to a JSON object.
  Map<String, dynamic> toJson() => {
    'model': model,
    'stream': true,
    'messages': messages.map((message) => message.toJson()).toList(),
  };
}

/// A class representing a chat response.
class ChatResponse {
  final List<Choice> choices;

  /// Creates an instance of [ChatResponse].
  ///
  /// [choices] is the list of choices in the response.
  ChatResponse({required this.choices});

  /// Creates an instance of [ChatResponse] from a JSON object.
  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      choices: (json['choices'] as List).map((choice) => Choice.fromJson(choice)).toList(),
    );
  }
}

/// A class representing a choice in the chat response.
class Choice {
  final Message message;

  /// Creates an instance of [Choice].
  ///
  /// [message] is the message in the choice.
  Choice({required this.message});

  /// Creates an instance of [Choice] from a JSON object.
  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      message: Message.fromJson(json),
    );
  }
}

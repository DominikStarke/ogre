enum LlmProviderType {
  none,
  openwebui,
  anthropic,
  ollama,
  openai;

  String get value {
    switch (this) {
      case LlmProviderType.none:
        return "none";
      case LlmProviderType.openwebui:
        return "openwebui";
      case LlmProviderType.anthropic:
        return "anthropic";
      case LlmProviderType.ollama:
        return "ollama";
      case LlmProviderType.openai:
        return "openai";
    }
  }
}
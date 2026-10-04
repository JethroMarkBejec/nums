import 'assistant_service.dart';

/// Keeps chat rules replaceable while the demo remains fully on-device.
abstract class ChatRepository {
  Future<AssistantReply> replyTo(String message, {bool preferTagalog = false});
}

class LocalChatRepository implements ChatRepository {
  final AssistantService _rules = AssistantService();
  @override
  Future<AssistantReply> replyTo(String message,
          {bool preferTagalog = false}) =>
      _rules.getReply(message, preferTagalog: preferTagalog);
}

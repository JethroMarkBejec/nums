class AssistantService {
  Future<String> getSuggestion(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return 'Suggested pairing for "$query": a classic butter cookie and a warm drink.';
  }
}

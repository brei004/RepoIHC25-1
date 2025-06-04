class SentimentService {
  static String analyze(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('no puedo') || lower.contains('es difícil') || lower.contains('fracaso')) {
      return 'negative';
    } else if (lower.contains('me encanta') || lower.contains('quiero ayudar') || lower.contains('solucionar')) {
      return 'positive';
    } else {
      return 'neutral';
    }
  }
}

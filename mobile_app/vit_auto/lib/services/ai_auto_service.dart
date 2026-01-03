import 'package:google_generative_ai/google_generative_ai.dart';
import '../config/gemini_config.dart';

class AiAutoService {
  final _model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: geminiApiKey,
  );

  Future<String> ask({
    required String userName,
    required String message,
  }) async {
    final prompt = '''
You are "AI Auto", an assistant inside the VIT-AP VIT Auto app.

Your role:
- Help students plan departures
- Explain rush timings
- Be short, practical, friendly

User ($userName) says:
$message
''';

    final response = await _model.generateContent([Content.text(prompt)]);
    return response.text ?? "I couldn’t think of a reply 🤔";
  }
}
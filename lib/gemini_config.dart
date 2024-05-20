import 'package:google_generative_ai/google_generative_ai.dart';

const instruction =
    "Respond directly as if you are a human having a natural conversation, without any preamble or introduction, or any formatting or text styles. Give short and long answer in between as what would any human would respond, as if you are speaking: ";

final generationConfig = GenerationConfig(
  temperature: 1,
  topP: 0.95,
  topK: 64,
  maxOutputTokens: 8192,
);

final safetySettings = [
  SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
  SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
  SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
  SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
];

const model = 'gemini-1.5-flash-latest';

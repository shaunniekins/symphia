// controller.dart
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:html/parser.dart' as htmlparser;
import 'package:symphia/gemini_config.dart';
import 'global.dart';
import 'package:characters/characters.dart';

class Controller extends GetxController {
  var speech = stt.SpeechToText();
  var isListening = false.obs;
  var text = ''.obs;
  var hasSpoken = false.obs;
  RxList<String> chatHistory = <String>[].obs;
  final prompt = instruction;

  void onListen() async {
    if (!isListening.value) {
      bool available = await speech.initialize(
        onStatus: (val) async {
          if (val == 'notListening' && isListening.value && !hasSpoken.value) {
            isListening.value = false;
            List<Content> history =
                chatHistory.map((message) => Content.text(message)).toList();
            var content = Content.text("$prompt${text.value}");
            history.add(content);
            var response = await geminiModel?.generateContent(history);
            String? output = response?.text;

            // Remove emojis from the output
            output = output!.characters
                .where(
                    (char) => char.length == 1 && char.runes.first <= 0x1f6c5)
                .join();

            speak(output);
            chatHistory.add(output);
          } else if (val == 'listening') {
            isListening.value = true;
          }
        },
      );
      if (available) {
        speech.listen(onResult: (val) => text.value = val.recognizedWords);
      }
    }
  }

  final flutterTts = FlutterTts();

  Future<void> stopSpeaking() async {
    await flutterTts.stop();
  }

  void speak(String text) async {
    String cleanedText = htmlparser.parse(text).documentElement?.text ?? text;
    cleanedText =
        cleanedText.toLowerCase().replaceAll(RegExp(r'\\[^\\w\\s\\]|\_'), ' ');

    // Remove asterisks and other special styling characters
    cleanedText = cleanedText.replaceAll(RegExp(r'[*_~`]|\\'), ' ');

    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(1.3);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.awaitSynthCompletion(true);
    await flutterTts.speak(cleanedText);
    // Clear the text value after speaking
    this.text.value = '';
  }
}

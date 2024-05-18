import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:html/parser.dart' as htmlparser;

class Controller extends GetxController {
  var speech = stt.SpeechToText();
  var isListening = false.obs;
  var text = ''.obs;
  var hasSpoken = false.obs;

  final gemini = Gemini.instance;

  void onListen() async {
    if (!isListening.value) {
      bool available = await speech.initialize(
        onStatus: (val) async {
          if (val == 'notListening' && isListening.value && !hasSpoken.value) {
            isListening.value = false;
            gemini
                .streamGenerateContent(
                    "Respond directly as if you are a human having a natural conversation, without any preamble or introduction, or any formatting or text styles. Give short answer as what would any human would respond, as if you are speaking: ${text.value}")
                .listen((value) {
              if (value.output != null) {
                String output = value.output ?? '';
                print('Output Length: ${output.length}');
                speak(output);
              }
            }).onError((e) {
              print('Gemini Error: $e');
            });
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

  void speak(String text) async {
    String cleanedText = htmlparser.parse(text).documentElement?.text ?? text;
    cleanedText =
        cleanedText.toLowerCase().replaceAll(RegExp(r'\[^\\w\\s\]|\_'), ' ');
    await flutterTts.setPitch(1.0);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.awaitSynthCompletion(true);
    await flutterTts.speak(text);

    // Clear the text value after speaking
    this.text.value = '';
  }
}

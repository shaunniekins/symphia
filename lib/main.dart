import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'my_app.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  Gemini.init(apiKey: dotenv.env['GEMINI_API_KEY']!);
  runApp(const MyApp());
}

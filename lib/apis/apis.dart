import 'dart:developer';
import 'dart:typed_data' as td;
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:stability_image_generation/stability_image_generation.dart';
import 'package:translator_plus/translator_plus.dart';
import '../helper/global.dart';


class APIs {
  //get answer from gemini
  static Future<String> getAnswer(String question) async {
    try {
      if (kDebugMode) {
      log('Gemini model initialized');
    }

      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: apiKey,
      );

      final content = [Content.text(question)];
      final res = await model.generateContent(content, safetySettings: [
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
      ]);

      log('res: ${res.text}');

      return res.text!;
    } catch (e) {
      log('getAnswerGeminiE: $e');
      return 'Something went wrong (Try again in sometime)';
    }
  }
  //generate image
  static Future<td.Uint8List> generateImage({
    required String prompt,
    required String stabilityApiKey,
    required ImageAIStyle imageAIStyle,
  }) async {
    try {
      log('Generating image with prompt: $prompt');

      final StabilityAI ai = StabilityAI();

      final dynamic rawImage = await ai.generateImage(
        apiKey: stabilityApiKey,
        imageAIStyle: imageAIStyle,
        prompt: prompt,
      );

      final td.Uint8List image = rawImage as td.Uint8List;

      log('Image generated successfully');
      return image;
    } catch (e) {
      log('generateImageE: $e');
      throw Exception('Failed to generate image: $e');
    }
  }

  static Future<String> googleTranslate(
      {required String from, required String to, required String text}) async {
    try {
      final res = await GoogleTranslator().translate(text, from: from, to: to);

      return res.text;
    } catch (e) {
      log('googleTranslateE: $e ');
      return 'Something went wrong!';
    }
  }
}
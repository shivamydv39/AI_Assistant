import 'dart:developer';
import 'dart:typed_data' as td;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:stability_image_generation/stability_image_generation.dart';
import 'package:translator_plus/translator_plus.dart';

import '../helper/global.dart';

class APIs {
  //get answer from google gemini ai
  static Future<String> getAnswer(String question) async {
    try {
      log('api key: $apiKey');

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

  // At the top of your file, use a prefix for one of the imports:


// Then modify your function:
  static Future<td.Uint8List> generateImage({
    required String prompt,
    required String stabilityApiKey,
    required ImageAIStyle imageAIStyle,
  }) async {
    try {
      log('Generating image with prompt: $prompt');

      final StabilityAI ai = StabilityAI();

      // Cast the result to the expected Uint8List type
      final dynamic rawImage = await ai.generateImage(
        apiKey: stabilityApiKey,
        imageAIStyle: imageAIStyle,
        prompt: prompt,
      );

      // Cast the result to ensure type consistency using the prefixed type
      final td.Uint8List image = rawImage as td.Uint8List;

      log('Image generated successfully');
      return image;
    } catch (e) {
      log('generateImageE: $e');
      throw Exception('Failed to generate image: $e');
    }
  }
  //get answer from chat gpt
  // static Future<String> getAnswer(String question) async {
  //   try {
  //     log('api key: $apiKey');

  //     //
  //     final res =
  //         await post(Uri.parse('https://api.openai.com/v1/chat/completions'),

  //             //headers
  //             headers: {
  //               HttpHeaders.contentTypeHeader: 'application/json',
  //               HttpHeaders.authorizationHeader: 'Bearer $apiKey'
  //             },

  //             //body
  //             body: jsonEncode({
  //               "model": "gpt-3.5-turbo",
  //               "max_tokens": 2000,
  //               "temperature": 0,
  //               "messages": [
  //                 {"role": "user", "content": question},
  //               ]
  //             }));

  //     final data = jsonDecode(res.body);

  //     log('res: $data');
  //     return data['choices'][0]['message']['content'];
  //   } catch (e) {
  //     log('getAnswerGptE: $e');
  //     return 'Something went wrong (Try again in sometime)';
  //   }
  // }

  /* static Future<List<String>> searchAiImages(String prompt) async {
    try {
      final res = await http.get(Uri.parse('https://lexica.art/api/v1/search?q=$prompt'));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        if (data != null && data['images'] != null) {
          return List.from(data['images']).map((e) => e['src'].toString()).toList();
        } else {
          log('searchAiImagesE: Invalid JSON structure');
          return [];
        }
      } else {
        log('searchAiImagesE: HTTP error ${res.statusCode}');
        return [];
      }
    } catch (e) {
      log('searchAiImagesE: $e');
      return [];
    }
  }*/




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
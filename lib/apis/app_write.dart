import 'dart:developer';

import 'package:appwrite/appwrite.dart';

import '../helper/global.dart';

class AppWrite {
  static final _client = Client();
  static final _database = Databases(_client);

  static void init() {
    _client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('67ed6a71003812eebcef')
        .setSelfSigned(status: true);
    getApiKey();
  }

  static Future<String> getApiKey() async {
    try {
      final d = await _database.getDocument(
          databaseId: '67ed6c97001cfe7b2aff',
          collectionId: 'apikey',
          documentId: 'geminikey');

      apiKey = d.data['apiKey'];
      log(apiKey);
      return apiKey;
    } catch (e) {
      log('$e');
      return '';
    }
  }
}
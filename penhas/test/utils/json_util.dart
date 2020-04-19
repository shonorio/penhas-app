import 'dart:convert';
import 'dart:io';

class JsonUtil {
  static Future<Map<String, dynamic>> getJson({String from}) {
    return JsonUtil.getString(from: from)
        .then((fileContent) => JsonDecoder().convert(fileContent));
  }

  static Future<String> getString({String from}) {
    return File("test/assets/json/$from").readAsString();
  }
}
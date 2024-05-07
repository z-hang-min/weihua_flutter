/*
 * @Author: HZH
 * @Date: 2020-10-28 13:26:36
 * @LastEditTime: 2020-10-29 09:12:57
 * @LastEditors: Please set LastEditors
 * @Description: 中文字符转码处理类
 * @FilePath: /express-user-app/lib/utils/sh_custom_transcoding.dart
 */
import 'dart:convert';

class SHCustomTranscoding {
  /*
    将含有中文的字符串转码encode，进行传值
    string 转成 encodeString
  */
  static String encodeStringWithChineseTranscode(String str) {
    return jsonEncode(Utf8Encoder().convert(str));
  }

  /*
    将已经编码含有中文的字符串，进行解码操作
    encodeString 转成 string
  */
  static String decodeStringWithChineseTranscode(String str) {
    List<int> list = [];
    //字符串解码
    jsonDecode(str).forEach(list.add);
    final String value = Utf8Decoder().convert(list);
    // var mapValue = json.decode(value);
    return value;
  }

  /*
     传入Map类型的数据进行编码成字符串 Map转成jsonString
  */
  static String encodeWithMapString(Map mapValue) {
    String jsonString = json.encode(mapValue);
    var jsons = jsonEncode(Utf8Encoder().convert(jsonString));
    return jsons;
  }

  /*
     传入jsonString转成Map
  */
  static Map decodeWithMapString(String str) {
    List<int> list = [];

    ///字符串解码
    jsonDecode(str).forEach(list.add);
    final String value = Utf8Decoder().convert(list);
    var mapValue = json.decode(value);
    return mapValue;
  }

// Uri.encodeComponent(url); // To encode url
// Uri.decodeComponent(encodedUrl);

}

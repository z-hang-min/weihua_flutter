import 'dart:convert';

import 'package:weihua_flutter/utils/log.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:lpinyin/lpinyin.dart';

class StringUtils {
  StringUtils._();

  static String toMD5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  static String? urlDecoder(String? data) {
    return data == null ? null : HtmlUnescape().convert(data);
  }

  static String? removeHtmlLabel(String? data) {
    return data?.replaceAll(RegExp('<[^>]+>'), '');
  }

  static String getNospacePinyin(String data) {
    return PinyinHelper.getPinyinE(data).replaceAll(' ', '');
  }

  static bool isEmptyString(String? str) {
    if (str == null || str.isEmpty) {
      return true;
    }
    return false;
  }

  // 是否不是空字符串
  static bool isNotEmptyString(String? str) {
    if (str != null && str.isNotEmpty) {
      return true;
    }
    return false;
  }

  static bool isMobileNumber(String mobile) {
    if (isEmptyString(mobile)) return false;
    String str = mobile.replaceAll(" ", "");
    if (str.length == 11 && str.startsWith("1")) {
      return true;
    } else {
      return false;
    }
  }

  // 🔥格式化手机号为344
  static String formatMobile344(String? mobile) {
    if (isEmptyString(mobile)) return '';
    if (mobile!.length <= 4) {
      return mobile;
    }
    mobile =
        mobile.replaceAllMapped(new RegExp(r"(^\d{3}|\d{4}\B)"), (Match match) {
      return '${match.group(0)} ';
    });
    if (mobile.endsWith(' ')) {
      mobile = mobile.substring(0, mobile.length - 1);
    }
    return mobile;
  }

  // 格式化手机号为188**1412
  static String formatMobileStar(String? mobile) {
    if (isEmptyString(mobile)) return '';
    if (mobile!.length <= 4) {
      return mobile;
    }
    mobile = mobile.replaceFirst(new RegExp(r'\d{4}'), '****', 3);
    // mobile.replaceRange(3, 6, "*");
    return mobile;
  }

  static String getMap2JsonSting(String name, String phone) {
    Map contactmap = {'userName': name, 'numberVal': phone};
    String jsonString = json.encode(contactmap);
    return "\'" + jsonString + "\'";
  }

  static String get95WithSpace(String numer95) {
    if (numer95.isEmpty) return '';
    if (numer95.startsWith('95013')) {
      numer95 = numer95.replaceAll(' ', "");
      numer95 = numer95.trim().replaceRange(0, 5, '95013 ');
    }
    return numer95;
  }
}

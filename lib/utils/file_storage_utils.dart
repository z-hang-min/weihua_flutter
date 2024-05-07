/*
 * @Author: HZH
 * @Date: 2021-03-04 09:36:41
 * @LastEditTime: 2021-03-08 10:40:15
 * @LastEditors: Please set LastEditors
 * @Description: 利用文件存储数据工具类
 * @FilePath: /app-station-flutter/lib/utils/sh_file_storage_utils.dart
 */
import 'dart:io';

import 'package:weihua_flutter/utils/log.dart';
import 'package:path_provider/path_provider.dart';

class SHFileStorageUtils {
  /// 利用文件存储数据
  /// string为需要存储的文本，fileNameStr为文件名称（例如：file.text）
  static saveString(String string, String fileNameStr) async {
    // final file = await getFile('file.text');
    final file = await getFile(fileNameStr);
    // 写入字符串
    file.writeAsString(string);
  }

  /// 获取存在文件中的数据
  /// fileNameStr为文件名称（例如：file.text）
  static Future<String> getFileString(String fileNameStr) async {
    final file = await getFile(fileNameStr);
    return file.readAsString();
  }

  /// 初始化文件路径
  /// fileNameStr为文件名称（例如：file.text）
  static Future<File> getFile(String fileName) async {
    //获取应用文件目录类似于Ios的NSDocumentDirectory和Android上的 AppData目录
    final fileDirectory = await getApplicationDocumentsDirectory();

    //获取存储路径
    final filePath = fileDirectory.path;

    //或者file对象（操作文件记得导入import 'dart:io'）
    return new File(filePath + "/" + fileName);
  }

  static Future<File> getSaveFile(String fileName) async {
    var dirloc = "";
    if (Platform.isAndroid) {
      dirloc = "/sdcard/download/";
    } else {
      dirloc = (await getTemporaryDirectory()).path;
      dirloc = dirloc.replaceFirst("Library/Caches", "Documents");
    }
    return new File(dirloc + "/records/" + fileName);
  }

  static copyFile(String newPath, String oldPath) {
    // 将test目录下的info.json复制到test2目录下的info2.json中
    File info1 = new File(oldPath);
    info1.copySync(newPath);
  }

  static Future<bool> isFileExist(String fileNameStr) async {
    final file = await getFile(fileNameStr);
    bool exist = await file.exists();
    Log.d("文件是否存在 $exist ${file.path}  ");
    if (exist) {
      Log.d("文件是否存在 $exist ${file.length()} ${file.path}  ");
    }
    return exist;
  }
}

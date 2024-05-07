import 'package:weihua_flutter/utils/log.dart';
import 'package:intl/intl.dart';

int currentTimeMillis() {
  return new DateTime.now().millisecondsSinceEpoch;
}

class TimeUtil {
  //时间格式化，根据总秒数转换为对应的 hh:mm:ss 格式
  static String constructTime(int seconds) {
    // int hour = seconds ~/ 3600;
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    return _formatTime(minute) + ":" + _formatTime(second);
  }

  // 数字格式化，将 0~9 的时间转换为 00~09
  static String _formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }

  //时间格式化，根据总秒数转换为对应的 hh时mm分ss秒 格式
  static String constructCallTime(int seconds) {
    int hour = seconds ~/ 3600;
    // int hour = 0;
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    Log.w('$hour--$minute--$second');
    if (hour > 0)
      return _formatTime(hour) +
          "时" +
          _formatTime(minute) +
          "分" +
          _formatTime(second) +
          '秒';
    else if (hour == 0 && minute > 0)
      return "$minute" + "分" + _formatTime(second) + '秒';
    return _formatTime(second) + '秒';
  }

  static String formatTimeDay(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    return DateFormat("HH:mm:ss").format(dateTime);
  }

  static String formatTime(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    return DateFormat("yyyy年MM月dd日 HH:mm:ss").format(dateTime);
  }

  static String formatTimeWithReg(int time, String reg) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    return DateFormat(reg).format(dateTime);
  }

  static String formatTimeDot(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    return DateFormat("yyyy.MM.dd").format(dateTime);
  }

  static String formatTime2(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    return DateFormat("yyyy年MM月dd日").format(dateTime);
  }

  static String formatCallTime(int callTime) {
    int nowTime = DateTime.now().millisecondsSinceEpoch;
    DateTime nowDTime = DateTime.now();
    DateTime callDTime = DateTime.fromMillisecondsSinceEpoch(callTime);
    int _nDay = nowDTime.day;
    int _cDay = callDTime.day;
    if (nowTime - callTime <= 1000 * 60 * 60 * 24 * 3) {
      if (_cDay == _nDay) {
        //同一天
        return "今天 " + formatTimeDay(callTime);
      } else if (_nDay - _cDay == 1) {
        return "昨天 " + formatTimeDay(callTime);
      } else if (_nDay - _cDay == 2) {
        return "前天 " + formatTimeDay(callTime);
      }
    }
    return formatTime(callTime);
  }

  static String formatTimeDayWithreg(int time, String rex) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    return DateFormat(rex).format(dateTime);
  }

  static String formatTimeWithreg(int time, String reg) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    return DateFormat(reg).format(dateTime);
  }

  static String formatCallTimeWithreg(int callTime) {
    int nowTime = DateTime.now().millisecondsSinceEpoch;
    DateTime nowDTime = DateTime.now();
    DateTime callDTime = DateTime.fromMillisecondsSinceEpoch(callTime);
    int _nDay = nowDTime.day;
    int _cDay = callDTime.day;
    if (nowTime - callTime <= 1000 * 60 * 60 * 24 * 3) {
      if (_cDay == _nDay) {
        //同一天
        return "今天 " + formatTimeDayWithreg(callTime, "HH:mm");
      } else if (_nDay - _cDay == 1) {
        return "昨天 " + formatTimeDayWithreg(callTime, "HH:mm");
      } else if (_nDay - _cDay == 2) {
        return "前天 " + formatTimeDayWithreg(callTime, "HH:mm");
      }
    }
    return formatTimeWithreg(callTime, "yyyy年MM月dd日 HH:mm");
  }

  static int getTime(String date) {
    if (date.isEmpty) return 0;
    DateTime newDate = DateTime.parse(date);
    return newDate.millisecondsSinceEpoch;
  }
}

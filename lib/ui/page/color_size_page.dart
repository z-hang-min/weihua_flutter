import 'package:weihua_flutter/config/router_manger.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///
/// @Desc:
/// @Author: zhhli
/// @Date: 2021-03-26
///
///
///
///
//   static const TextTheme dense2018 = TextTheme(
//     headline1 : TextStyle( fontSize: 96.0, fontWeight: FontWeight.w100, textBaseline: TextBaseline.ideographic),
//     headline2 : TextStyle( fontSize: 60.0, fontWeight: FontWeight.w100, textBaseline: TextBaseline.ideographic),
//     headline3 : TextStyle( fontSize: 48.0, fontWeight: FontWeight.w400, textBaseline: TextBaseline.ideographic),
//     headline4 : TextStyle( fontSize: 34.0, fontWeight: FontWeight.w400, textBaseline: TextBaseline.ideographic),
//     headline5 : TextStyle( fontSize: 24.0, fontWeight: FontWeight.w400, textBaseline: TextBaseline.ideographic),
//     headline6 : TextStyle( fontSize: 21.0, fontWeight: FontWeight.w500, textBaseline: TextBaseline.ideographic),
//     bodyText1 : TextStyle( fontSize: 17.0, fontWeight: FontWeight.w400, textBaseline: TextBaseline.ideographic),
//     bodyText2 : TextStyle( fontSize: 15.0, fontWeight: FontWeight.w400, textBaseline: TextBaseline.ideographic),
//     subtitle1 : TextStyle( fontSize: 17.0, fontWeight: FontWeight.w400, textBaseline: TextBaseline.ideographic),
//     subtitle2 : TextStyle( fontSize: 15.0, fontWeight: FontWeight.w500, textBaseline: TextBaseline.ideographic),
//     button    : TextStyle( fontSize: 15.0, fontWeight: FontWeight.w500, textBaseline: TextBaseline.ideographic),
//     caption   : TextStyle( fontSize: 13.0, fontWeight: FontWeight.w400, textBaseline: TextBaseline.ideographic),
//     overline  : TextStyle( fontSize: 11.0, fontWeight: FontWeight.w400, textBaseline: TextBaseline.ideographic),
//   );

//static const TextTheme englishLike2018 = TextTheme(
//     headline1 : TextStyle( fontSize: 96.0, fontWeight: FontWeight.w300, textBaseline: TextBaseline.alphabetic, letterSpacing: -1.5),
//     headline2 : TextStyle( fontSize: 60.0, fontWeight: FontWeight.w300, textBaseline: TextBaseline.alphabetic, letterSpacing: -0.5),
//     headline3 : TextStyle( fontSize: 48.0, fontWeight: FontWeight.w400, textBaseline: TextBaseline.alphabetic, letterSpacing: 0.0),
//     headline4 : TextStyle( fontSize: 34.0, fontWeight: FontWeight.w400, textBaseline: TextBaseline.alphabetic, letterSpacing: 0.25),
//     headline5 : TextStyle( fontSize: 24.0, fontWeight: FontWeight.w400, textBaseline: TextBaseline.alphabetic, letterSpacing: 0.0),
//     headline6 : TextStyle( fontSize: 20.0, fontWeight: FontWeight.w500, textBaseline: TextBaseline.alphabetic, letterSpacing: 0.15),
//     bodyText1 : TextStyle( fontSize: 16.0, fontWeight: FontWeight.w400, textBaseline: TextBaseline.alphabetic, letterSpacing: 0.5),
//     bodyText2 : TextStyle( fontSize: 14.0, fontWeight: FontWeight.w400, textBaseline: TextBaseline.alphabetic, letterSpacing: 0.25),
//     subtitle1 : TextStyle( fontSize: 16.0, fontWeight: FontWeight.w400, textBaseline: TextBaseline.alphabetic, letterSpacing: 0.15),
//     subtitle2 : TextStyle( fontSize: 14.0, fontWeight: FontWeight.w500, textBaseline: TextBaseline.alphabetic, letterSpacing: 0.1),
//     button    : TextStyle( fontSize: 14.0, fontWeight: FontWeight.w500, textBaseline: TextBaseline.alphabetic, letterSpacing: 1.25),
//     caption   : TextStyle( fontSize: 12.0, fontWeight: FontWeight.w400, textBaseline: TextBaseline.alphabetic, letterSpacing: 0.4),
//     overline  : TextStyle( fontSize: 10.0, fontWeight: FontWeight.w400, textBaseline: TextBaseline.alphabetic, letterSpacing: 1.5),
//);
class ColorSizePage extends StatefulWidget {
  @override
  _ColorSizePageState createState() => _ColorSizePageState();
}

class _ColorSizePageState extends State<ColorSizePage> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    TextTheme textTheme = themeData.textTheme;

    TextStyle headline6 = textTheme.headline6!;
    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle subtitle2 = textTheme.subtitle2!;
    TextStyle bodyText1 = textTheme.bodyText1!;
    TextStyle bodyText2 = textTheme.bodyText2!;
    TextStyle button = textTheme.button!;
    TextStyle caption = textTheme.caption!;

    return Theme(
      data: themeData.copyWith(
        appBarTheme: themeData.appBarTheme.copyWith(
          // 设置状态栏文字颜色
          color: themeData.brightness == Brightness.light
              ? Colors.white
              : Colors.black,
          elevation: 0,
          centerTitle: true, toolbarTextStyle: themeData.textTheme.copyWith(
              headline6: headline6.copyWith(color: Colors.red, fontSize: 18)).bodyText2, titleTextStyle: themeData.textTheme.copyWith(
              headline6: headline6.copyWith(color: Colors.red, fontSize: 18)).headline6,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Color size"),
        ),
        body: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: InkWell(
                    child: Text("login"),
                    onTap: () =>
                        Navigator.of(context).pushNamed(RouteName.login),
                  ),
                ),
                Center(
                  child: InkWell(
                    child: Text(
                      "切换模式",
                      style: button.change(context, color: Colors.red),
                    ),
                    onTap: () => Provider.of<ThemeModel>(context, listen: false)
                        .switchTheme(),
                  ),
                ),
                Table(
                  columnWidths: const <int, TableColumnWidth>{
                    0: FixedColumnWidth(80),
                    // 1: FixedColumnWidth(160),
                  },
                  border: TableBorder(
                    top: BorderSide(color: Colors.red),
                    left: BorderSide(color: Colors.red),
                    right: BorderSide(color: Colors.red),
                    bottom: BorderSide(color: Colors.red),
                    horizontalInside: BorderSide(color: Colors.red),
                    verticalInside: BorderSide(color: Colors.green),
                  ),
                  children: [
                    _tableRow("headline6", "appbar title, 18, 0xFF212121"),
                    _tableRow(
                        "subtitle1", "大标题 16, 0xFF212121, ListTile.title"),
                    _tableRow("subtitle2", "副标题 14 0xFF666666"),
                    _tableRow("bodyText1", "正文字体／标题／名称 16 0xFF212121"),
                    _tableRow("bodyText2", "默认字体，直接使用Text，未设置属性 14 0xFF666666"),
                    _tableRow("button", "白色， 16"),
                    _tableRow("caption", "12 , 0xFF666666"),
                  ],
                ),
                Text(
                  "微话 headline6  ${headline6.fontSize}  ${headline6.color}",
                  style: textTheme.headline6,
                ),
                Text(
                  "微话 subtitle1  ${subtitle1.fontSize}  ${subtitle1.color}",
                  style: textTheme.subtitle1,
                ),
                Text(
                  "微话 subtitle2  ${subtitle2.fontSize}  ${subtitle2.color}",
                  style: textTheme.subtitle2,
                ),
                Text(
                  "微话 body1      ${bodyText1.fontSize}  ${bodyText1.color}",
                  style: textTheme.bodyText1,
                ),
                Text(
                  "微话 body2   ${bodyText2.fontSize}  ${bodyText2.color}",
                  style: textTheme.bodyText2,
                ),
                Text(
                  "微话 button   ${button.fontSize}  ${button.color}",
                  style: button.change(context, color: Colour.titleColor),
                ),
                Text(
                  "微话 caption   ${caption.fontSize}  ${caption.color}",
                  style: textTheme.caption,
                ),
                Text(
                  "微话 none set style",
                ),
                Text(
                  "微话 body2    ${bodyText2.fontSize}  ${bodyText2.color}",
                  style: textTheme.bodyText2,
                ),
                Text(
                    "改变特定字体大小、颜色 subtitle1.change(context, color: Colors.red, fontSize: 16)",
                    style: TextStyle()
                        .change(context, color: Colors.red, fontSize: 16)),
                Card(
                  child: Column(
                    children: [
                      Text("企业信息"),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(RouteName.dbTestPage);
                        },
                        child: Icon(
                          Icons.ac_unit,
                          color: themeData.primaryColor,
                        ),
                      ),
                      Text(
                        "企业信息",
                        style:
                            bodyText2.change(context, color: Colour.titleColor),
                      ),
                    ],
                  ),
                ),
                TextField(
                  decoration:
                      InputDecoration(border: InputBorder.none, hintText: "输入"),
                ),
                ListTile(
                  title: Text(
                    "ListTile",
                  ),
                  leading: Text("ListTile", style: bodyText2),
                  trailing: Text("ListTile"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  TableRow _tableRow(String name, String desc) {
    return TableRow(children: [
      Text(name),
      TableCell(
          child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(desc),
      ))
    ]);
  }
}

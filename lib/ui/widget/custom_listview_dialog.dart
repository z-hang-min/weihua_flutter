import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListViewDialog extends Dialog {
  final List<String> data;

  ListViewDialog({required this.data});

  @override
  Widget build(BuildContext context) {
    double height = 58.0 * data.length + 68;
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center(
        //保证控件居中效果
        child: new Container(
          width: 320.w,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Theme.of(context).brightness == Brightness.light
                ? Colour.backgroundColor2
                : Colour.f2C2C2C,
          ),
          child: Column(
            children: [
              Container(
                height: data.length * 58.0,
                child: ListView.builder(
                    itemCount: data.length == 0 ? 0 : data.length,
                    itemBuilder: (BuildContext context, int position) {
                      return itemWidget(context, position);
                    }),
              ),
              Container(
                height: 10,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colour.cFF1E1E1E
                    : Colour.cFFF7F8F9,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 58,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    '取消',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .change(context, color: Colour.titleColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemWidget(BuildContext context, int index) {
    return InkWell(
      child: Container(
        height: 58,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 57,
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                data[index],
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            Divider(
              height: 1,
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.pop(context, data[index]);
      },
    );
  }

  static Future showCustomDialog(
      BuildContext context, List<String> list) async {
    var result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ListViewDialog(data: list);
        });
    return result;
  }
}

import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

///
/// @Desc:
///
/// @Author: zhhli
///
/// @Date: 21/5/31
///

class BlankDivider extends StatelessWidget {
  final double height;

  BlankDivider({this.height = 10});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(height),
      color: context.isBrightness
          ? Color.fromRGBO(247, 248, 249, 1.0)
          : Color.fromRGBO(17, 17, 17, 1.0),
    );
  }
}

class MyDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
        height: 1.0,
        indent: 15.0,
        endIndent: 15.0,
        thickness: 1.0,
        color: context.isBrightness ? Colour.cFFEEEEEE : Colour.f0x1AFFFFFF);
  }
}

/// 弹窗条目
class BottomItemWidget extends StatelessWidget {
  final String title;
  final String? imgUrl;
  final GestureTapCallback? onTap;
  final bool autoPop;

  /// title
  ///
  /// autoPop 是否自动关闭弹窗
  BottomItemWidget(this.title, {this.imgUrl, this.onTap, this.autoPop = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: onTap,
      onTap: () {
        //关闭弹框
        if (autoPop) {
          Navigator.of(context).pop();
        }

        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        height: 58.h,
        //左右排开的线性布局
        child: Row(
          //所有的子Widget 水平方向居中
          mainAxisAlignment: MainAxisAlignment.center,
          //所有的子Widget 竖直方向居中
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            imgUrl == null
                ? SizedBox(width: 0)
                : SvgPicture.asset(ImageHelper.wrapAssets(imgUrl!)),
            imgUrl == null
                ? SizedBox(width: 0)
                : SizedBox(
                    width: 10.w,
                  ),
            Text(title, textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }
}

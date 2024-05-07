import 'package:weihua_flutter/config/resource_mananger.dart';
import 'package:weihua_flutter/provider/provider_widget.dart';
import 'package:weihua_flutter/ui/page/cloudnotification/viewmodel/notification_temple_model.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

///
/// @Desc: 新增模板 更改模板
///
/// @Author: zm
///
/// @Date: 21/8/30
///

class NewNoticeTemPage extends StatefulWidget {
  final dynamic notifacationInfo;

  NewNoticeTemPage(this.notifacationInfo);
  @override
  State createState() => _NewNoticeTemPageState();
}

class _NewNoticeTemPageState extends State<NewNoticeTemPage> {
  NotificationTempleModel _model = NotificationTempleModel();

  AudioPlayer audioPlayer = AudioPlayer();
  bool isModify = false;

  void _updateState(BuildContext context) {
    if (_model.isBusy) {
      EasyLoading.show();
    }
    if (_model.isIdle) {
      EasyLoading.dismiss();
    }

    if (_model.isError) {
      _model.showErrorMessage(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _listenAudioPlayerStateController();
    isModify = widget.notifacationInfo != null;

    if (widget.notifacationInfo != null) {
      _model.updateTempName(widget.notifacationInfo!.templateName);
      _model.updateTempContent(widget.notifacationInfo!.templateContent);
    }
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  void deactivate() async {
    print('结束');
    // int result = await audioPlayer.release();
    int result = 0;
    if (result == 1) {
      print('release success');
    } else {
      print('release failed');
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;
    TextStyle subtitle1 = textTheme.subtitle1!;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          isModify ? '更改模板' : '新增模板',
          style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colour.f333333
                  : Colour.fffffff),
        ),
        backgroundColor: Theme.of(context).cardColor,
        leading: new IconButton(
            icon: SvgPicture.asset(ImageHelper.wrapAssets(context.isBrightness
                ? "nav_icon_return.svg"
                : "nav_icon_return_sel.svg")),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: ProviderWidgetNoConsumer(
          model: _model,
          child: GestureDetector(
              // 触摸收起键盘
              // behavior: HitTestBehavior.translucent,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
                  color: context.isBrightness
                      ? Colour.c0xFFF7F8FD
                      : Colour.FF111111,
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 10.h, left: 10.h, right: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '模板名称',
                        style: subtitle1.change(context, color: Colour.f333333),
                      ),
                      _nameRow(context),
                      Text(
                        '通知内容',
                        style: subtitle1.change(context, color: Colour.f333333),
                      ),
                      _contentInput(context),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(ImageHelper.wrapAssets(
                                    'icon_tip_blue.svg')),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                  '温馨提示:',
                                  style: subtitle1.change(context,
                                      fontSize: 14, color: Colour.f333333),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 19.h,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 22.w, right: 22.w),
                              child: Text(
                                '模板中不能出现广告、诈骗、色情、不文明、等违规违法内容。一经发现立即封号。已购买套餐次数不退换。',
                                style: TextStyle(
                                    fontSize: 12, color: Colour.cFF666666),
                              ),
                            )
                          ],
                        ),
                      ),
                      // Spacer(),
                    ],
                  )))),
      bottomSheet: Container(
        margin: EdgeInsets.all(15.w),
        child: CupertinoButton(
          borderRadius: BorderRadius.circular(25),
          padding: EdgeInsets.all(1),
          color: Colour.f0F8FFB,
          disabledColor: Colour.f0F8FFB.withAlpha(100),
          child: Container(
            height: 50.h,
            alignment: Alignment.center,
            child: Text(
              widget.notifacationInfo == null ? '确认' : '更改',
              style: TextStyle(color: Colour.fffffff),
            ),
          ),
          onPressed: () async {
            if (isModify) {
              _doSubmitUpdate();
            } else {
              _doSubmitAdd();
            }
          },
        ),
      ),
    );
  }

  Widget _nameRow(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;

    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle subtitle2 = textTheme.subtitle2!;

    String name = _model.tempName;

    final _nameCtrl = TextEditingController(text: name);
    _nameCtrl.selection =
        TextSelection.fromPosition(TextPosition(offset: _nameCtrl.text.length));

    return Container(
      height: 54.h,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      margin: EdgeInsets.only(bottom: 15.w, top: 15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        color: Theme.of(context).cardColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 1,
            child: TextField(
              // inputFormatters: [FilteringTextInputFormatter.deny(' ')], // 禁止输入空格
              autofocus: false,
              controller: _nameCtrl,
              // textAlign: TextAlign.start,
              maxLines: 1,
              maxLength: 20,
              style: subtitle1,
              // style: Theme.of(context).textTheme.bodyText2,
              cursorColor: context.isBrightness
                  ? Theme.of(context).primaryColor
                  : Colors.white,
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                counterText: '',
                // 掩藏自带字数
                hintText: '请输入模板名称',
                hintStyle: subtitle2.change(context,
                    fontSize: 16, color: Colour.cFF999999),
              ),
              keyboardType: TextInputType.text,
              onChanged: (text) {
                if (text.isNotEmpty && text.length > 20) {
                  showToast("超出字数限制");
                } else {
                  _model.updateTempName(text);
                }
              },
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(1.0),
              child: Consumer<NotificationTempleModel>(
                  builder: (context, model, child) {
                return Text(
                  '${_model.tempName.length}/20',
                  style: TextStyle(color: Colour.cFF999999, fontSize: 12),
                );
              })),
        ],
      ),
    );
  }

  Widget _contentInput(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    TextTheme textTheme = themeData.textTheme;

    TextStyle subtitle1 = textTheme.subtitle1!;
    TextStyle subtitle2 = textTheme.subtitle2!;

    String content = _model.tempContent;

    final _contentCtrl = TextEditingController(text: content);

    return Container(
      height: 170.h,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      margin: EdgeInsets.only(bottom: 31.w, top: 15.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        color: Theme.of(context).cardColor,
      ),
      child: Stack(
        children: [
          Container(
            child: TextField(
              autofocus: false,
              controller: _contentCtrl,
              // textAlign: TextAlign.start,
              maxLength: 60,
              style: subtitle1,
              maxLines: 10,
              // style: Theme.of(context).textTheme.bodyText2,
              cursorColor: context.isBrightness
                  ? Theme.of(context).primaryColor
                  : Colors.white,
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                // counterText: "",
                hintText: '请输入通知内容',
                hintStyle: subtitle2.change(context,
                    fontSize: 16, color: Colour.cFF999999),
              ),
              keyboardType: TextInputType.multiline,
              onChanged: (text) {
                if (text.isNotEmpty && text.length > 60) {
                  showToast("超出字数限制");
                } else {
                  _model.updateTempContent(text);
                }
              },
            ),
          ),
          Align(
              alignment: Alignment.bottomLeft,
              child: InkWell(
                onTap: () async {
                  if (_model.tempContent.trim().isEmpty) {
                    showToast('试听失败，请输入通知内容');
                  } else {
                    _model.isPlaying ? pause() : play();
                    // 切换播放状态
                    _model.togglePlayState();
                  }
                },
                child: Container(
                  padding: EdgeInsets.only(left: 3),
                  width: 64.w,
                  height: 26.h,
                  decoration: BoxDecoration(
                      color: Colour.FF19BA6C,
                      borderRadius: BorderRadius.circular(14)),
                  child: Row(
                    children: [
                      Consumer<NotificationTempleModel>(
                          builder: (context, model, _) {
                        _updateState(context);
                        return SvgPicture.asset(ImageHelper.wrapAssets(
                            !model.isPlaying
                                ? 'icon_audio_statrt.svg'
                                : 'icon_suspend.svg'));
                      }),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        '试听',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      )
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  play() async {
    // String text = await _model.textToVoice();
    // int result = await audioPlayer.play(text);
    // if (result == 1) {
    //   // success
    //   print('play success');
    // } else {
    //   print('play failed');
    // }
  }

  pause() async {
    // int result = await audioPlayer.pause();
    // if (result == 1) {
    //   // success
    //   print('pause success');
    // } else {
    //   print('pause failed');
    // }
  }

  ///监听播放器当前状态
  _listenAudioPlayerStateController() {
    // audioPlayer.onPlayerCompletion.listen((event) {
    //   _model.togglePlayState();
    // });
  }

  void _doSubmitAdd() async {
    if (_model.tempName.trim().isEmpty && _model.tempContent.trim().isEmpty) {
      showToast('设置失败,请输入模版名称和通知内容');
    } else if (_model.tempName.trim().isEmpty) {
      showToast('设置失败,请输入模版名称');
    } else if (_model.tempContent.trim().isEmpty) {
      showToast('设置失败,请输入通知内容');
    } else {
      bool result = await _model.addNotificationModel();
      if (result == true) {
        showToast("设置成功");
        Navigator.pop(context, true);
      } else {
        _model.showErrorMessage(context);
        EasyLoading.dismiss();
      }
    }
  }

  void _doSubmitUpdate() async {
    if (_model.tempName.trim().isEmpty && _model.tempContent.trim().isEmpty) {
      showToast('更改失败,请输入模版名称和通知内容');
    } else if (_model.tempName.trim().isEmpty) {
      showToast('更改失败,请输入模版名称');
    } else if (_model.tempContent.trim().isEmpty) {
      showToast('更改失败,请输入通知内容');
    } else {
      bool result = await _model.updateNotificationModel(_model.tempName,
          _model.tempContent, widget.notifacationInfo.templateId.toString());
      if (result == true) {
        showToast("更改模版成功");
        Navigator.pop(context, true);
      } else {
        _model.showErrorMessage(context);
        EasyLoading.dismiss();
      }
    }
  }
}

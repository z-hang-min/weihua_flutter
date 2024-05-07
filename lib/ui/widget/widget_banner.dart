import 'dart:async';

import 'package:weihua_flutter/model/get_banner_result.dart';
import 'package:weihua_flutter/view_model/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef OnTapCallback = Widget Function(int index);

class CustomSwiperBanner extends StatefulWidget {
  final List<BannerInfo> images;
  final void Function(BannerInfo) onTapCallback;

  CustomSwiperBanner({required this.images, required this.onTapCallback});

  @override
  State<StatefulWidget> createState() {
    return _CustomSwiperBannerState();
  }
}

class _CustomSwiperBannerState extends State<CustomSwiperBanner> {
  var _curIndex = 0;
  PageController _pageController = PageController();
  var length = 0;

  var _timer;

  _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 3), (t) {
      if (widget.images.length == 1) return;

      _curIndex++;
      _pageController.animateToPage(
        _curIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    });
  }

  @override
  void initState() {
     super.initState();
    length = widget.images.length;
    _startTimer();
  }

  @override
  void dispose() {
     super.dispose();
    _stopTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130.h,
      child: Stack(
        children: [
          Container(
            height: 150.h,
            child: PageView.builder(
              itemBuilder: ((content, index) {
                length = widget.images.length;
                return GestureDetector(
                  onPanDown: (details) {
                    _cancelTimer();
                  },
                  onTap: () {
                    widget.onTapCallback(widget.images[index % length]);
                  },
                  child: Image.network(
                    '${widget.images[index % length].pic}',
                    fit: BoxFit.contain,
                  ),
                );
              }),
              scrollDirection: Axis.horizontal,
              reverse: false,
              controller: _pageController,
              physics: PageScrollPhysics(parent: BouncingScrollPhysics()),
              onPageChanged: ((index) {
                setState(() {
                  // if (index == 0) {
                  //   _curIndex = length;
                  // }
                  _curIndex = index;
                  // else
                  //   _curIndex = index;
                });
              }),
            ),
          ),
          Visibility(
              visible: widget.images.length > 1, child: _buildIndicator()),
        ],
      ),
    );
  }

  /// 点击到图片的时候取消定时任务
  _cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
      _startTimer();
    }
  }

  _stopTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  Widget _buildIndicator() {
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.images.map((s) {
          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: Container(
                width: 10.w,
                height: 2.h,
                color: s == widget.images[_curIndex % widget.images.length]
                    ? Colors.white
                    : Colour.f66ffffff,
              ));
        }).toList(),
      ),
    );
  }
}

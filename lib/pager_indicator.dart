import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:material_page_reveal/pages.dart';

class PagerIndicator extends StatelessWidget {
  final PagerIndicatorViewModel viewModel;

  PagerIndicator({this.viewModel});

  @override
  Widget build(BuildContext context) {
    List<PageBubble> bubbles = [];

    for (int i = 0; i < viewModel.pageList.length; i++) {
      var page = viewModel.pageList[i];
      var percentActive;
      if (i == viewModel.activePage) {
        percentActive = 1.0 - viewModel.slidePercent;
      } else if (i == viewModel.activePage - 1 &&
          viewModel.slideDirection == SlideDirection.leftToRight) {
        percentActive = viewModel.slidePercent;
      } else if (i == viewModel.activePage + 1 &&
          viewModel.slideDirection == SlideDirection.rightToLeft) {
        percentActive = viewModel.slidePercent;
      } else {
        percentActive = 0.0;
      }

      bool isHollow = i > viewModel.activePage ||
          (i == viewModel.activePage &&
              viewModel.slideDirection == SlideDirection.leftToRight);

      bubbles.add(
        PageBubble(
            viewModel: PagerBubbleViewModel(
          icon: page.pageIcon,
          color: page.color,
          isHollow: isHollow,
          activePercent: percentActive,
        )),
      );
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: Container(),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: bubbles)
      ],
    );
  }
}

enum SlideDirection {
  leftToRight,
  rightToLeft,
  none,
}

class PagerIndicatorViewModel {
  final List<PageViewModel> pageList;
  final int activePage;
  final SlideDirection slideDirection;
  final double slidePercent;

  PagerIndicatorViewModel({
    this.pageList,
    this.activePage,
    this.slideDirection,
    this.slidePercent,
  });
}

class PageBubble extends StatelessWidget {
  final PagerBubbleViewModel viewModel;

  PageBubble({this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(height: 50,
              child: Container(
          child: Opacity(
            opacity: viewModel.activePercent,
          ),
          width: lerpDouble(20.0, 40.0, viewModel.activePercent),
          height: lerpDouble(20.0, 40.0, viewModel.activePercent),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: viewModel.isHollow
                  ? const Color(0x88FFFFFF)
                      .withAlpha(0x88 * viewModel.activePercent.round())
                  : const Color(0x88FFFFFF),
              border: Border.all(
                  width: 3.0,
                  color: viewModel.isHollow
                      ? const Color(0x88FFFFFF)
                          .withAlpha(0x88 * 1 - viewModel.activePercent.round())
                      : Colors.transparent)),
        ),
      ),
    );
  }
}

class PagerBubbleViewModel {
  final Color color;
  final bool isHollow;
  final double activePercent;
  final Icon icon;

  PagerBubbleViewModel(
      {this.color, this.isHollow, this.activePercent, this.icon});
}

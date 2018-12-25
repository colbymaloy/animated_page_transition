import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_page_reveal/pager_indicator.dart';

class PageReveal extends StatelessWidget {
  final double revealPercent;
  final Widget child;
  final SlideDirection slideDirection;

  PageReveal({this.revealPercent, this.child, this.slideDirection});

  @override
  Widget build(BuildContext context) {
    return  ClipOval(
      child: child,
      clipper: BottomOvalClipper(revealPercent, slideDirection),
    );
  }
}

class BottomOvalClipper extends CustomClipper<Rect> {
  final double revealPercent;
  final SlideDirection slideDirection;
  BottomOvalClipper(this.revealPercent, this.slideDirection);

  @override
  getClip(Size size) {
    final epicenter = slideDirection == SlideDirection.rightToLeft
        ? Offset(size.width * .9, size.height / 2)
        : Offset(size.width *.1, size.height /2);

    double theta = atan(epicenter.dy / epicenter.dx);
    final distanceToCorner = epicenter.dy / sin(theta);

    final radius = distanceToCorner * revealPercent;

    final diameter = 2 * radius;

    return Rect.fromLTWH(
        epicenter.dx - radius, epicenter.dy - radius, diameter, diameter);
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

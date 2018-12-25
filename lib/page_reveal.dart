import 'dart:math';

import 'package:flutter/material.dart';

class PageReveal extends StatelessWidget {
  final double revealPercent;
  final Widget child;

  PageReveal({this.revealPercent, this.child});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: child,
      clipper: BottomOvalClipper(revealPercent),
    );
  }
}

class BottomOvalClipper extends CustomClipper<Rect> {
  final double revealPercent;

  BottomOvalClipper(this.revealPercent);

  @override
  getClip(Size size) {
    final epicenter = Offset(size.width / 2, size.height * .9);

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

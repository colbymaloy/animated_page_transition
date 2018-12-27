import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart ';
import 'package:material_page_reveal/pager_indicator.dart';

class PageDragger extends StatefulWidget {
  final bool canRtoL;
  final bool canLtoR;

  final StreamController<SlideUpdate> slideUpdateStream;

  PageDragger({this.slideUpdateStream, this.canLtoR, this.canRtoL});

  @override
  _PageDraggerState createState() => _PageDraggerState();
}

class _PageDraggerState extends State<PageDragger> {
  static const FULL_TRANSITION_PX = 250.0;

  Offset dragStart;
  SlideDirection slideDirection;
  double slidePercent = 0.0;
  onDragStart(DragStartDetails details) {
    dragStart = details.globalPosition;
  }

  onDragUpdate(DragUpdateDetails details) {
    if (dragStart != null) {
      final newPosition = details.globalPosition;
      final dx = dragStart.dx - newPosition.dx;

      if (dx > 0.0 && widget.canRtoL) {
        slideDirection = SlideDirection.rightToLeft;
      } else if (dx < 0.0 && widget.canLtoR) {
        slideDirection = SlideDirection.leftToRight;
      } else {
        slideDirection = SlideDirection.none;
      }

      if (slideDirection != SlideDirection.none) {
        slidePercent = (dx / FULL_TRANSITION_PX).abs().clamp(0.0, 1.0);
      } else {
        slidePercent = 0.0;
      }

      widget.slideUpdateStream.add(SlideUpdate(
          direction: slideDirection,
          slidePercent: slidePercent,
          updateType: UpdateType.dragging));

     
    }
  }

  onDragEnd(DragEndDetails details) {
    widget.slideUpdateStream.add(SlideUpdate(
        updateType: UpdateType.doneDragging,
        slidePercent: 0.0,
        direction: SlideDirection.none));
    dragStart = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: onDragStart,
      onHorizontalDragUpdate: onDragUpdate,
      onHorizontalDragEnd: onDragEnd,
    );
  }
}

class AnimatedPageDragger {
  static const PERCENT_PER_MILLI = .005;

  final slideDirection;
  final tansitionGoal;

  AnimationController completionAnimationController;

  AnimatedPageDragger(
      {this.slideDirection,
      this.tansitionGoal,
      slidePercent,
      StreamController<SlideUpdate> slideUpdateStream,
      TickerProvider vsync}) {
    var startSlidePercent = slidePercent;
    var endSlidePercent;
    var duration;

    if (tansitionGoal == TransitionGoal.open) {
      endSlidePercent = 1.0;
      final slideRemaining = 1.0 - slidePercent;
      duration =
          Duration(milliseconds: (slideRemaining / PERCENT_PER_MILLI).round());
    } else {
      endSlidePercent = 0.0;
      duration =
          Duration(milliseconds: (slidePercent / PERCENT_PER_MILLI).round());
    }

    completionAnimationController =
        AnimationController(duration: duration, vsync: vsync)
          ..addListener(() {
            slidePercent = lerpDouble(startSlidePercent, endSlidePercent,
                completionAnimationController.value);

            slideUpdateStream.add(SlideUpdate(
                direction: slideDirection,
                slidePercent: slidePercent,
                updateType: UpdateType.animating));
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              slideUpdateStream.add(SlideUpdate(
                  updateType: UpdateType.doneAnimating,
                  slidePercent: endSlidePercent,
                  direction: slideDirection));
            }
          });
  }

  run(){
    completionAnimationController.forward(from: 0.0);
  }

  dispose(){
    completionAnimationController.dispose();
  }
}

enum TransitionGoal { open, close }

enum UpdateType { dragging, doneDragging, animating, doneAnimating }

class SlideUpdate {
  final direction;
  final slidePercent;
  UpdateType updateType;

  SlideUpdate({this.direction, this.slidePercent, this.updateType});
}

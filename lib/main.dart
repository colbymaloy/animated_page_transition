import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_page_reveal/page_dragger.dart';
import 'package:material_page_reveal/page_reveal.dart';
import 'package:material_page_reveal/pager_indicator.dart';
import 'pages.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(
        fontFamily: "RobotoThin",
        textTheme: TextTheme(
            title: TextStyle(
                fontSize: 40.0,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  StreamController<SlideUpdate> slideUpdateStream;

  AnimatedPageDragger animatedPageDragger;

  int activeIndex = 0;
  int nextPageIndex = 0;

  SlideDirection slideDirection = SlideDirection.none;
  double slidePercent = 0.0;

  _MyHomePageState() {
    slideUpdateStream = StreamController<SlideUpdate>();

    slideUpdateStream.stream.listen((event) {
      setState(() {
        if (event.updateType == UpdateType.dragging) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;

          if (slideDirection == SlideDirection.leftToRight) {
            nextPageIndex = activeIndex - 1;
          } else if (slideDirection == SlideDirection.rightToLeft) {
            nextPageIndex = activeIndex + 1;
          } else {
            nextPageIndex = activeIndex;
          }

          nextPageIndex.clamp(0.0, pages.length);
        } else if (event.updateType == UpdateType.doneDragging) {
          if (slidePercent > .5) {
            animatedPageDragger = AnimatedPageDragger(
                slideDirection: slideDirection,
                slidePercent: slidePercent,
                tansitionGoal: TransitionGoal.open,
                slideUpdateStream: slideUpdateStream,
                vsync: this);
          } else {
            animatedPageDragger = AnimatedPageDragger(
                slideDirection: slideDirection,
                slidePercent: slidePercent,
                tansitionGoal: TransitionGoal.close,
                slideUpdateStream: slideUpdateStream,
                vsync: this);
            nextPageIndex = activeIndex;
          }

          animatedPageDragger.run();
        } else if (event.updateType == UpdateType.animating) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;
        } else if (event.updateType == UpdateType.doneAnimating) {
          activeIndex = nextPageIndex;

          slideDirection = SlideDirection.none;
          slidePercent = 0.0;
          animatedPageDragger.dispose();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Page(
            pageViewModel: pages[activeIndex],
            percentVisible: 1.0,canContinue: activeIndex >= pages.length - 1,
          ),
          
          PageReveal(
              revealPercent: slidePercent,
              slideDirection: slideDirection,
              child: Page(
                pageViewModel: pages[nextPageIndex],
                percentVisible: slidePercent,
                canContinue: false,
              )),
          PagerIndicator(
            viewModel: PagerIndicatorViewModel(
                pageList: pages,
                activePage: activeIndex,
                slideDirection: slideDirection,
                slidePercent: slidePercent),
          ),
          PageDragger(
            canLtoR: activeIndex > 0,
            canRtoL: activeIndex < pages.length - 1,
            slideUpdateStream: slideUpdateStream,
          )
        ],
      ),
    );
  }
}

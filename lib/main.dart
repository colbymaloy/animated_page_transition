import 'package:flutter/material.dart';
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

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Page(pageViewModel: pages[0]),
          Page(pageViewModel: pages[1]),
          PageReveal(revealPercent: 1.0, child: Page(pageViewModel: pages[2])),
          PagerIndicator(
            viewModel: PagerIndicatorViewModel(
                pageList: pages,
                activePage: 1,
                slideDirection: SlideDirection.rightToLeft,
                slidePercent: 0.0),
          )
        ],
      ),
    );
  }
}

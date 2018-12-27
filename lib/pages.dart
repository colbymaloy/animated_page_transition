import 'package:flutter/material.dart';

final pages = [
  PageViewModel(
      "Analyze",
      "something",
      Color(0xFF678FB4),
      Icon(
        Icons.scatter_plot,
        color: Colors.white54,
        size: 200,
      ),
      false),
  PageViewModel(
      "Connect",
      "with something",
      Color(0xFF65B0B4),
      Icon(
        Icons.person,
        color: Colors.white54,
        size: 200,
      ),
      false),
  PageViewModel(
      "Explore",
      "somwhere",
      Color(0xFF9B90BC),
      Icon(
        Icons.explore,
        color: Colors.white54,
        size: 200,
      ),
      true)
];

class Page extends StatelessWidget {
  final PageViewModel pageViewModel;
  final double percentVisible;
  final bool canContinue;
  Page({this.pageViewModel, this.percentVisible = 1.0, this.canContinue});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: pageViewModel.color,
      child: Opacity(
        opacity: percentVisible,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Transform(
                transform: Matrix4.translationValues(
                    0.0, 50.0 * (1 - percentVisible), 0.0),
                child: pageViewModel.pageIcon),
            Transform(
              transform: Matrix4.translationValues(
                  0.0, 30.0 * (1 - percentVisible), 0.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  pageViewModel.title,
                  style: Theme.of(context).textTheme.title,
                ),
              ),
            ),
            Transform(
              transform: Matrix4.translationValues(
                  0.0, 30.0 * (1 - percentVisible), 0.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  pageViewModel.body,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
           /*  canContinue
                ? Transform(
                    transform: Matrix4.translationValues(
                        0.0, 30.0 * (1 - percentVisible), 0.0),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 75.0),
                      child: FlatButton(
                        shape: Border.all(),
                        onPressed: () {},
                        child: Text(
                          "continue",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  )
                : Container() */
          ],
        ),
      ),
    );
  }
}

class PageViewModel {
  final Color color;
  final String title;
  final String body;
  final Icon pageIcon;
  final bool canContinue;

  PageViewModel(
      this.title, this.body, this.color, this.pageIcon, this.canContinue);
}

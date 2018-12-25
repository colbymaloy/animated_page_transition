import 'package:flutter/material.dart';

final pages = [
  PageViewModel(
      "Merry",
      "",
      Color(0xFF678FB4),
      Icon(
        Icons.scatter_plot,
        color: Colors.white54,
        size: 200,
      )),
  PageViewModel(
      "Christmas",
      "",
      Color(0xFF65B0B4),
      Icon(
        Icons.person,
        color: Colors.white54,
        size: 200,
      )),
  PageViewModel(
      "Everyone!",
      "",
      Color(0xFF9B90BC),
      Icon(
        Icons.new_releases,
        color: Colors.white54,
        size: 200,
      ))
];

class Page extends StatelessWidget {
  final PageViewModel pageViewModel;
  final double percentVisible;
  Page({this.pageViewModel, this.percentVisible = 1.0});

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
                padding: const EdgeInsets.only(bottom: 75.0),
                child: Text(
                  pageViewModel.body,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
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

  PageViewModel(this.title, this.body, this.color, this.pageIcon);
}

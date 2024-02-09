import 'package:flutter/widgets.dart';

class NavigationBarItem {
  NavigationBarItem(
      {required this.route, required this.imageIcon, this.label, this.id});

  final GlobalKey? id;
  final String route;
  final String? label;
  final String imageIcon;
}

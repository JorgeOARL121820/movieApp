import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/src/models/nav_bar_model.dart';

final GlobalKey<ScaffoldState> drawerKey = GlobalKey();

List<NavigationBarItem> tabs = <NavigationBarItem>[
  NavigationBarItem(
    route: "",
    imageIcon: "",
    label: '',
  ),
  NavigationBarItem(
    route: "",
    imageIcon: "",
    label: '',
  ),
  NavigationBarItem(
    route: "",
    imageIcon: "",
    label: '',
  ),
];

class ScaffoldBottomNavbar extends StatefulWidget {
  const ScaffoldBottomNavbar({required this.child, super.key});

  final Widget child;

  @override
  State<ScaffoldBottomNavbar> createState() => _ScaffoldBottomNavbarState();
}

class _ScaffoldBottomNavbarState extends State<ScaffoldBottomNavbar> {
  @override
  void initState() {
    super.initState();
  }

  int get currentIndex => _locationToTabIndex();

  int _locationToTabIndex() {
    final RouteMatch lastMatch =
        GoRouter.of(context).routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : GoRouter.of(context).routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();

    int index = -1;

    index = tabs.indexWhere((NavigationBarItem t) {
      return location.startsWith(t.route);
    });

    setState(() {});
    return index < 0 ? 0 : index;
  }

  void _onTap(int index) {
    setState(() {
      context.go(tabs[index].route);
    });
  }

  @override
  Widget build(BuildContext context) {
    currentIndex;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: widget.child,
        key: drawerKey,
        bottomNavigationBar: _generateNavBar());
  }

  Widget? _generateNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (int value) => _onTap(value),
      currentIndex: currentIndex,
      showSelectedLabels: false,
      selectedFontSize: 0,
      unselectedFontSize: 0,
      iconSize: 0,
      showUnselectedLabels: false,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.green,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      items: tabs
          .asMap()
          .map((int index, NavigationBarItem e) {
            return MapEntry<int, BottomNavigationBarItem>(
              index,
              BottomNavigationBarItem(
                icon: Column(
                  children: <Widget>[
                    Container(
                      height: 2,
                      width: double.infinity,
                      decoration: _decorationItem(index == currentIndex),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    const SizedBox(height: 12),
                    _buildIcon(e.imageIcon, index == currentIndex),
                    const SizedBox(height: 6),
                    _buildText(e.label ?? '', index == currentIndex),
                    const SizedBox(height: 12),
                  ],
                ),
                label: "",
              ),
            );
          })
          .values
          .toList(),
    );
  }

  Widget _buildIcon(String icon, bool selected) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
          minHeight: 28, maxHeight: 28, minWidth: 24, maxWidth: 49.67),
      child: SvgPicture.asset(
        icon,
        colorFilter: ColorFilter.mode(
          selected ? Colors.black : Colors.green,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  Text _buildText(String text, bool selected) {
    return Text(
      text,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.fade,
      style: TextStyle(
        color: selected ? Colors.green : Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    );
  }

  BoxDecoration _decorationItem(bool selected) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(50),
    );
  }
}

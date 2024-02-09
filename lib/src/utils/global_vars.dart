import 'package:flutter/material.dart';
import 'package:movie_app/enviroment/enviroment.dart';

/// Environment
late final Environment environment;

/// Provides access to the mainNavigator of the app throughout the app.
final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

/// Provides access to the shellNavbar only exist in child routes of shell routes
final GlobalKey<NavigatorState> shellKey = GlobalKey<NavigatorState>();

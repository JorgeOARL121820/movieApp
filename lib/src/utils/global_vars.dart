import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_app/enviroment/enviroment.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Environment
late final Environment environment;

/// Provides access to the mainNavigator of the app throughout the app.
final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

/// Provides access to the shellNavbar only exist in child routes of shell routes
final GlobalKey<NavigatorState> shellKey = GlobalKey<NavigatorState>();

/// Shared Preferences
late final SharedPreferences prefs;

Stream<List<InternetAddress>>? connection;

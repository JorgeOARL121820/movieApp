import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/enviroment/enviroment.dart';
import 'package:movie_app/src/data/api/bloc/api_bloc.dart';
import 'package:movie_app/src/router/app_router.dart';
import 'package:movie_app/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie_app/injector.dart' as di;

void main() async {
  /// Para asegurarnos que todo se inicializa antes de empezar la app
  WidgetsFlutterBinding.ensureInitialized();

  prefs = await SharedPreferences.getInstance();

  ///Se genera el enviroment
  environment = Environment.env;
  di.init();

  /// Establece la orientación del dispositivo en PorTrait y luego corre la app
  await SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[DeviceOrientation.portraitUp],
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    checkConnection();
    super.initState();
  }

  void checkConnection() async {
    try {
      connection = InternetAddress.lookup('example.com').asStream();
    } on SocketException catch (_) {}
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<ApiBloc>(create: (_) => di.locator<ApiBloc>()),
      ],
      child: MaterialApp.router(
          routerConfig: appRouter,
          themeMode: ThemeMode.dark,
          title: environment.appName,
          theme: ThemeData.dark(useMaterial3: true)),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/src/data/api/bloc/api_bloc.dart';
import 'package:movie_app/src/data/models/movie/movie_model.dart';
import 'package:movie_app/src/utils/utils.dart';

class HomeVideoAppPage extends StatefulWidget {
  static const String route = "/movies";

  const HomeVideoAppPage({super.key});

  @override
  State<HomeVideoAppPage> createState() => _HomeVideoAppPageState();
}

class _HomeVideoAppPageState extends State<HomeVideoAppPage> {
  bool enableAllFunctions = true;
  List<MovieModel>? movies;
  List<MovieModel>? tv;

  @override
  void initState() {
    connection?.listen((List<InternetAddress> result) {
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        enableAllFunctions = true;
      } else {
        enableAllFunctions = false;
      }

      setState(() {});
    });
    context.read<ApiBloc>().add(GetMoviesEvent(true, 1, null, null));
    context.read<ApiBloc>().add(GetMoviesEvent(false, 1, null, null));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApiBloc, ApiState>(
      listener: (BuildContext context, ApiState state) {},
      builder: (BuildContext context, ApiState state) {
        return Scaffold();
      },
    );
  }
}

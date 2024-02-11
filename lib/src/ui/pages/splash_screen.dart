import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/src/data/api/bloc/api_bloc.dart';
import 'package:movie_app/src/ui/pages/pages.dart';

class SplashScreen extends StatefulWidget {
  static const String route = "/";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    loadNextPage();
  }

  void loadNextPage() {
    context.read<ApiBloc>().add(GetCatsEvent(true));
    context.read<ApiBloc>().add(GetCatsEvent(false));
    context.read<ApiBloc>().add(GetAccountEvent());
    Future<void>.delayed(const Duration(milliseconds: 4000), () {
      context.go(HomeVideoAppPage.route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/splash.gif',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

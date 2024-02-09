import 'dart:io';

import 'package:movie_app/src/data/api/api_repository_interface.dart';

class ApiRepository extends ApiRepositoryInterface {
  Future<bool> _checkConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  Future<(String, Map<String, dynamic>)> getMoviesList({String? cat}) async {
    final bool isConnected = await _checkConnection();

    throw UnimplementedError();
  }
}

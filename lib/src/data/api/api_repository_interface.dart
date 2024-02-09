abstract class ApiRepositoryInterface {
  Future<(String, Map<String, dynamic>)> getMoviesList({String? cat});
}

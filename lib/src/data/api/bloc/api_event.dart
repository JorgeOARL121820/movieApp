part of 'api_bloc.dart';

abstract class ApiEvent {}

class GetMoviesEvent extends ApiEvent {
  GetMoviesEvent(this.movies, this.page, this.genres, this.search);
  final bool movies;
  final int page;
  final List<String>? genres;
  final String? search;
}

class GetDetailsMovieEvent extends ApiEvent {
  GetDetailsMovieEvent(this.movieId, this.movie);
  final int movieId;
  final bool movie;
}

class GetCatsEvent extends ApiEvent {
  GetCatsEvent(this.movies);
  final bool movies;
}

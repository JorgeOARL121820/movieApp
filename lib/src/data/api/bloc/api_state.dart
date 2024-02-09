part of 'api_bloc.dart';

abstract class ApiState {
  ApiState({this.catMovies, this.catTv, this.films, this.dettails});
  final List<MovieModel>? films;
  final List<GenreModel>? catMovies;
  final List<GenreModel>? catTv;
  final MovieDetailsModel? dettails;
}

class MoviesInitState extends ApiState {
  MoviesInitState({super.catMovies, super.catTv, super.films});
}

class MovieLoaderState extends ApiState {
  MovieLoaderState({super.catMovies, super.catTv, super.films});
}

class MovieLoaderPaginationState extends ApiState {
  MovieLoaderPaginationState({super.catMovies, super.catTv, super.films});
}

class SuccessInfoState extends ApiState {
  SuccessInfoState({super.catMovies, super.catTv, super.films, super.dettails});
}

class ErrorAppState extends ApiState {
  ErrorAppState(this.error, {super.catMovies, super.catTv, super.films});
  final ErrorModel error;
}

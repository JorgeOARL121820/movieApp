part of 'api_bloc.dart';

abstract class ApiState {
  ApiState(
      {this.catMovies, this.films, this.dettails, this.account, this.type});
  final List<MovieModel>? films;
  final MovieCatType? type;
  final List<GenreModel>? catMovies;
  final MovieDetailsModel? dettails;
  final AccountModel? account;
}

class MoviesInitState extends ApiState {
  MoviesInitState({super.catMovies, super.films});
}

class MovieLoaderState extends ApiState {
  MovieLoaderState({super.catMovies, super.films, super.account});
}

class MovieLoaderFilesState extends ApiState {
  MovieLoaderFilesState({super.catMovies});
}

class MovieLoaderDetailsState extends ApiState {
  MovieLoaderDetailsState({super.catMovies, super.films, super.account});
}

class MovieLoaderPaginationState extends ApiState {
  MovieLoaderPaginationState({super.catMovies, super.films});
}

class SuccessInfoState extends ApiState {
  SuccessInfoState(
      {super.catMovies,
      super.type,
      super.films,
      super.dettails,
      super.account,
      this.message});
  final String? message;
}

class SuccessFilesState extends ApiState {
  SuccessFilesState(this.files);
  final List<String> files;
}

class ErrorAppState extends ApiState {
  ErrorAppState(this.error,
      {super.catMovies, super.films, this.page, this.closeModal});
  final ErrorModel error;
  int? page;
  bool? closeModal;
}

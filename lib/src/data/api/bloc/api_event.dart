part of 'api_bloc.dart';

abstract class ApiEvent {}

class GetMoviesEvent extends ApiEvent {
  GetMoviesEvent(this.page, this.genres, this.type);

  final int page;
  final List<int>? genres;

  final MovieCatType type;
}

class GetDetailsMovieEvent extends ApiEvent {
  GetDetailsMovieEvent(this.movieId);
  final int movieId;
}

class GetCatsEvent extends ApiEvent {
  GetCatsEvent(this.movies);
  final bool movies;
}

class GetAccountEvent extends ApiEvent {
  GetAccountEvent();
}

class UploadFileEvent extends ApiEvent {
  UploadFileEvent(this.file);
  final File file;
}

class GetAllFilesEvent extends ApiEvent {}

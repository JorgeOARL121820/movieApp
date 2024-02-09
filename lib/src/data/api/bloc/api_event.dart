part of 'api_bloc.dart';

abstract class ApiEvent {}

class GetMoviesEvent extends ApiEvent {}

class GetDetailsMovieEvent extends ApiEvent {
  GetDetailsMovieEvent(this.movieId);
  final String movieId;
}

class GetCatsEvent extends ApiEvent {}

class GetActorDetailsEvent extends ApiEvent {
  GetActorDetailsEvent(this.actorId);
  final String actorId;
}

class GetMoviesByActorEvent extends ApiEvent {
  GetMoviesByActorEvent(this.actorId);
  final String actorId;
}

class GetCommentsByMovieEvent extends ApiEvent {
  GetCommentsByMovieEvent(this.movieId);
  final String movieId;
}

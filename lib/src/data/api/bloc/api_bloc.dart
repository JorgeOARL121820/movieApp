import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/src/data/api/api_repository.dart';
import 'package:movie_app/src/data/models/genre/genre_model.dart';
import 'package:movie_app/src/data/models/movie/movie_model.dart';
import 'package:movie_app/src/models/error_model.dart';

part 'api_event.dart';
part 'api_state.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  ApiBloc(this.apiRepository) : super(MoviesInitState()) {
    on<ApiEvent>((event, emit) async {
      switch (event) {
        case GetMoviesEvent _:
          emit(
              MovieLoaderState(catMovies: state.catMovies, catTv: state.catTv));

          final (ErrorModel?, List<MovieModel>?) response =
              await apiRepository.getMoviesTVList(
                  genres: event.genres,
                  isMovie: event.movies,
                  page: event.page,
                  search: event.search);

          if (response.$1 != null) {
            emit(ErrorAppState(response.$1!,
                catMovies: state.catMovies, catTv: state.catTv));
          }

          if (response.$2 != null) {
            emit(SuccessInfoState(
                films: response.$2,
                catMovies: state.catMovies,
                catTv: state.catTv));
          }

        case GetCatsEvent _:
          emit(
              MovieLoaderState(catMovies: state.catMovies, catTv: state.catTv));
          (ErrorModel?, List<GenreModel>?) response;

          if (event.movies) {
            response = await apiRepository.getCats();
          } else {
            response = await apiRepository.getCatsTv();
          }

          if (response.$1 != null) {
            emit(ErrorAppState(response.$1!,
                catMovies: state.catMovies, catTv: state.catTv));
          }

          if (response.$2 != null) {
            if (event.movies) {
              emit(
                  SuccessInfoState(catMovies: response.$2, catTv: state.catTv));
            } else {
              emit(SuccessInfoState(
                  catTv: response.$2, catMovies: state.catMovies));
            }
          }
        case GetDetailsMovieEvent _:
          emit(
              MovieLoaderState(catMovies: state.catMovies, catTv: state.catTv));

          final (ErrorModel?, MovieDetailsModel?) response = await apiRepository
              .getDetails(event.movieId, isMovie: event.movie);

          if (response.$1 != null) {
            emit(ErrorAppState(response.$1!,
                catMovies: state.catMovies, catTv: state.catTv));
          }

          if (response.$2 != null) {
            emit(SuccessInfoState(
                dettails: response.$2,
                catMovies: state.catMovies,
                catTv: state.catTv));
          }
      }
    });
  }

  final ApiRepository apiRepository;
}

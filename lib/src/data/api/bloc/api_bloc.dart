import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/src/data/api/api_repository.dart';
import 'package:movie_app/src/data/api/enum/api_movie_type.dart';
import 'package:movie_app/src/data/models/account/account_model.dart';
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
          if (event.page != 1) {
            emit(MovieLoaderPaginationState(catMovies: state.catMovies));
          } else {
            emit(MovieLoaderState(
              catMovies: state.catMovies,
            ));
          }

          final (ErrorModel?, List<MovieModel>?) response =
              await apiRepository.getMoviesList(
            type: event.type,
            genres: event.genres,
            page: event.page,
          );

          if (response.$1 != null) {
            emit(ErrorAppState(
              response.$1!,
              page: event.page,
              catMovies: state.catMovies,
            ));
          }

          if (response.$2 != null) {
            emit(SuccessInfoState(
              type: event.type,
              films: response.$2,
              catMovies: state.catMovies,
            ));
          }

        case GetCatsEvent _:
          emit(MovieLoaderState(
            catMovies: state.catMovies,
          ));
          (ErrorModel?, List<GenreModel>?) response =
              await apiRepository.getCats();

          if (response.$1 != null) {
            emit(ErrorAppState(
              response.$1!,
              catMovies: state.catMovies,
            ));
          }

          if (response.$2 != null) {
            emit(SuccessInfoState(
              catMovies: response.$2,
            ));
          }
        case GetDetailsMovieEvent _:
          emit(MovieLoaderDetailsState(
            catMovies: state.catMovies,
          ));

          final (ErrorModel?, MovieDetailsModel?) response =
              await apiRepository.getDetails(event.movieId);

          if (response.$1 != null) {
            emit(ErrorAppState(response.$1!,
                catMovies: state.catMovies, closeModal: true));
          }

          if (response.$2 != null) {
            emit(SuccessInfoState(
              dettails: response.$2,
              catMovies: state.catMovies,
            ));
          }

        case GetAccountEvent _:
          emit(MovieLoaderState(catMovies: state.catMovies));

          final response = await apiRepository.getAccountInfo();

          if (response.$1 != null) {
            emit(ErrorAppState(response.$1!, catMovies: state.catMovies));
          }

          if (response.$2 != null) {
            emit(SuccessInfoState(
                catMovies: state.catMovies, account: response.$2));
          }

        case UploadFileEvent _:
          emit(MovieLoaderState(catMovies: state.catMovies));

          final (ErrorModel?, String?) response =
              await apiRepository.saveFile(event.file);

          if (response.$1 != null) {
            emit(ErrorAppState(response.$1!, catMovies: state.catMovies));
          }

          if (response.$2 != null) {
            emit(SuccessInfoState(
                catMovies: state.catMovies, message: response.$2));

            add(GetAllFilesEvent());
          }

        case GetAllFilesEvent _:
          emit(MovieLoaderFilesState(catMovies: state.catMovies));

          final (ErrorModel?, List<String>?) response =
              await apiRepository.getAllFiles();

          if (response.$1 != null) {
            emit(ErrorAppState(response.$1!, catMovies: state.catMovies));
          }

          if (response.$2 != null) {
            emit(SuccessFilesState(response.$2 ?? <String>[]));
          }
      }
    });
  }

  final ApiRepository apiRepository;
}

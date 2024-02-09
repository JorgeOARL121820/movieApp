import 'package:get_it/get_it.dart';
import 'package:movie_app/src/data/api/api_repository.dart';
import 'package:movie_app/src/data/api/bloc/api_bloc.dart';
import 'package:movie_app/src/services/api_service.dart';

final GetIt locator = GetIt.instance;

void init() {
  //Bloc
  locator.registerFactory(() => ApiBloc(locator()));

  //Repositories
  locator.registerLazySingleton<ApiRepository>(
    () => ApiRepository(locator()),
  );

  //Services
  locator.registerLazySingleton<ApiService>(() => ApiService());
}

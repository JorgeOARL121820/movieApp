import 'package:flutter_bloc/flutter_bloc.dart';

part 'api_event.dart';
part 'api_state.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  ApiBloc(ApiState initialState) : super(initialState) {
    on<ApiEvent>((event, emit) {
      
    });
  }
}

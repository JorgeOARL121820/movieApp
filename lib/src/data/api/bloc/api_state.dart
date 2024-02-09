part of 'api_bloc.dart';

abstract class ApiState {}

class MoviesInitState extends ApiState {}

class MovieLoaderState extends ApiState {}

class SuccessInfoState extends ApiState {}

class ErrorAppState extends ApiState {}

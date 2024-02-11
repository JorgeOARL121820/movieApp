// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:movie_app/src/data/models/genre/genre_model.dart';
import 'package:movie_app/src/data/models/movie/movie_entity.dart';

class MovieModel extends MovieEntity {
  MovieModel(
      {super.adult,
      super.backdrop_path,
      super.genre_ids,
      super.id,
      super.original_language,
      super.original_title,
      super.overview,
      super.popularity,
      super.poster_path,
      super.release_date,
      super.title,
      super.video,
      super.vote_average,
      super.vote_count,
      super.first_air_date,
      super.name,
      super.origin_country,
      super.original_name});

  factory MovieModel.fromMap(Map<String, dynamic> json) => MovieModel(
      adult: json['adult'],
      backdrop_path: json['backdrop_path'],
      genre_ids: json['genre_ids']?.cast<int>(),
      id: json['id'],
      original_language: json['original_language'],
      original_title: json['original_title'],
      overview: json['overview'],
      popularity: json['popularity'],
      poster_path: json['poster_path'],
      release_date: json['release_date'],
      title: json['title'],
      video: json['video'],
      vote_average: json['vote_average'],
      vote_count: json['vote_count'],
      first_air_date: json['first_air_date'],
      name: json['name'],
      origin_country: json['origin_country']?.cast<String>(),
      original_name: json['original_name']);

  Map<String, dynamic> toJson() => <String, dynamic>{
        "adult": adult,
        "backdrop_path": backdrop_path,
        "genre_ids": genre_ids,
        "id": id,
        "original_language": original_language,
        "original_title": original_title,
        "overview": overview,
        "popularity": popularity,
        "poster_path": poster_path,
        "release_date": release_date,
        "title": title,
        "video": video,
        "vote_average": vote_average,
        "vote_count": vote_count,
        "first_air_date": first_air_date,
        "name": name,
        "origin_country": origin_country,
        "original_name": original_name,
      };

  @override
  String toString() => json.encode(toJson());
}

class MovieDetailsModel extends MovieDetailsEntity {
  MovieDetailsModel(
      {super.adult,
      super.backdrop_path,
      super.budget,
      super.genres,
      super.homepage,
      super.id,
      super.imdb_id,
      super.original_language,
      super.original_title,
      super.overview,
      super.popularity,
      super.poster_path,
      super.production_companies,
      super.production_countries,
      super.spoken_languages,
      super.release_date,
      super.revenue,
      super.runtime,
      super.status,
      super.tagline,
      super.title,
      super.vote_average,
      super.cast,
      super.vote_count});

  factory MovieDetailsModel.fromMap(Map<String, dynamic> json) =>
      MovieDetailsModel(
        adult: json['adult'],
        backdrop_path: json['backdrop_path'],
        budget: json['budget'],
        genres: (json['genres'] as List<dynamic>?)
            ?.map((dynamic e) => GenreModel.fromMap(e as Map<String, dynamic>))
            .toList(),
        homepage: json['homepage'],
        id: json['id'],
        imdb_id: json['imdb_id'],
        original_language: json['original_language'],
        original_title: json['original_title'],
        overview: json['overview'],
        popularity: json['popularity'],
        poster_path: json['poster_path'],
        cast: (json['cast'] as List<dynamic>?)
            ?.map((dynamic e) => CastModel.fromMap(e as Map<String, dynamic>))
            .toList(),
        production_companies: (json['production_companies'] as List<dynamic>?)
            ?.map((dynamic e) =>
                ProductionCompaniesModel.fromMap(e as Map<String, dynamic>))
            .toList(),
        production_countries: (json['production_countries'] as List<dynamic>?)
            ?.map((dynamic e) =>
                ProductionCountriesModel.fromMap(e as Map<String, dynamic>))
            .toList(),
        spoken_languages: (json['spoken_languages'] as List<dynamic>?)
            ?.map((dynamic e) =>
                SpokenLanguagesModel.fromMap(e as Map<String, dynamic>))
            .toList(),
        release_date: json['release_date'],
        revenue: json['revenue'],
        runtime: json['runtime'],
        status: json['status'],
        tagline: json['tagline'],
        title: json['title'],
        vote_average: json['vote_average'],
        vote_count: json['vote_count'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "adult": adult,
        "backdrop_path": backdrop_path,
        "budget": budget,
        "cast": cast,
        "genres": genres,
        "homepage": homepage,
        "id": id,
        "imdb_id": imdb_id,
        "original_language": original_language,
        "original_title": original_title,
        "overview": overview,
        "popularity": popularity,
        "poster_path": poster_path,
        "production_companies": production_companies,
        "production_countries": production_countries,
        "spoken_languages": spoken_languages,
        "release_date": release_date,
        "revenue": revenue,
        "runtime": runtime,
        "status": status,
        "tagline": tagline,
        "title": title,
        "vote_average": vote_average,
        "vote_count": vote_count,
      };

  @override
  String toString() => json.encode(toJson());
}

class ProductionCompaniesModel extends ProductionCompaniesEntity {
  ProductionCompaniesModel(
      {super.id, super.logo_path, super.name, super.origin_country});

  factory ProductionCompaniesModel.fromMap(Map<String, dynamic> json) =>
      ProductionCompaniesModel(
          id: json['id'],
          logo_path: json['logo_path'],
          name: json['name'],
          origin_country: json['origin_country']);

  Map<String, dynamic> toJson() => <String, dynamic>{
        "id": id,
        "logo_path": logo_path,
        "name": name,
        "origin_country": origin_country
      };

  @override
  String toString() => json.encode(toJson());
}

class ProductionCountriesModel extends ProductionCountriesEntity {
  ProductionCountriesModel({super.iso_3166_1, super.name});

  factory ProductionCountriesModel.fromMap(Map<String, dynamic> json) =>
      ProductionCountriesModel(
          iso_3166_1: json['iso_3166_1'], name: json['name']);

  Map<String, dynamic> toJson() =>
      <String, dynamic>{"iso_3166_1": iso_3166_1, "name": "name"};

  @override
  String toString() => json.encode(toJson());
}

class SpokenLanguagesModel extends SpokenLanguagesEntity {
  SpokenLanguagesModel({super.english_name, super.iso_639_1, super.name});

  factory SpokenLanguagesModel.fromMap(Map<String, dynamic> json) =>
      SpokenLanguagesModel(
          english_name: json['english_name'],
          iso_639_1: json['iso_639_1'],
          name: json['name']);

  Map<String, dynamic> toJson() => <String, dynamic>{
        "english_name": english_name,
        "iso_639_1": iso_639_1,
        "name": name,
      };

  @override
  String toString() => json.encode(toJson());
}

class CastModel extends CastEntity {
  CastModel(
      {super.adult,
      super.cast_id,
      super.character,
      super.credit_id,
      super.gender,
      super.id,
      super.known_for_department,
      super.name,
      super.order,
      super.original_name,
      super.popularity,
      super.profile_path});

  factory CastModel.fromMap(Map<String, dynamic> json) => CastModel(
        adult: json['adult'],
        cast_id: json['cast_id'],
        character: json['character'],
        credit_id: json['credit_id'],
        gender: json['gender'],
        id: json['id'],
        known_for_department: json['known_for_department'],
        name: json['name'],
        order: json['order'],
        original_name: json['original_name'],
        popularity: json['popularity'],
        profile_path: json['profile_path'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "adult": adult,
        "cast_id": cast_id,
        "character": character,
        "credit_id": credit_id,
        "gender": gender,
        "id": id,
        "known_for_department": known_for_department,
        "name": name,
        "order": order,
        "original_name": original_name,
        "popularity": popularity,
        "profile_path": profile_path,
      };

  @override
  String toString() => json.encode(toJson());
}

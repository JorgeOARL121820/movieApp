// ignore_for_file: non_constant_identifier_names

import 'package:movie_app/src/data/models/genre/genre_entity.dart';

class MovieEntity {
  final bool? adult;
  final String? backdrop_path;
  final List<int>? genre_ids;
  final List<String>? origin_country;
  final String? original_name;
  final String? name;
  final String? first_air_date;
  final int? id;
  final String? original_language;
  final String? original_title;
  final String? overview;
  final double? popularity;
  final String? poster_path;
  final String? release_date;
  final String? title;
  final bool? video;
  final double? vote_average;
  final int? vote_count;

  MovieEntity(
      {this.adult,
      this.backdrop_path,
      this.genre_ids,
      this.origin_country,
      this.original_name,
      this.name,
      this.first_air_date,
      this.id,
      this.original_language,
      this.original_title,
      this.overview,
      this.popularity,
      this.poster_path,
      this.release_date,
      this.title,
      this.video,
      this.vote_average,
      this.vote_count});
}

class MovieDetailsEntity {
  final bool? adult;
  final String? backdrop_path;
  final bool? budget;
  final List<GenreEntity>? genres;
  final String? homepage;
  final int? id;
  final String? imdb_id;
  final String? original_language;
  final String? original_title;
  final String? overview;
  final double? popularity;
  final String? poster_path;
  final List<ProductionCompaniesEntity>? production_companies;
  final List<ProductionCountriesEntity>? production_countries;
  final List<SpokenLanguagesEntity>? spoken_languages;
  final String? release_date;
  final int? revenue;
  final int? runtime;
  final String? status;
  final String? tagline;
  final String? title;
  final double? vote_average;
  final int? vote_count;
  final List<CastEntity>? cast;

  MovieDetailsEntity(
      {this.adult,
      this.backdrop_path,
      this.budget,
      this.genres,
      this.homepage,
      this.cast,
      this.id,
      this.imdb_id,
      this.original_language,
      this.original_title,
      this.overview,
      this.popularity,
      this.poster_path,
      this.production_companies,
      this.production_countries,
      this.spoken_languages,
      this.release_date,
      this.revenue,
      this.runtime,
      this.status,
      this.tagline,
      this.title,
      this.vote_average,
      this.vote_count});
}

class ProductionCompaniesEntity {
  ProductionCompaniesEntity(
      {this.id, this.logo_path, this.name, this.origin_country});
  final int? id;
  final String? logo_path;
  final String? name;
  final String? origin_country;
}

class ProductionCountriesEntity {
  final String? iso_3166_1;
  final String? name;

  ProductionCountriesEntity({this.iso_3166_1, this.name});
}

class SpokenLanguagesEntity {
  final String? english_name;
  final String? iso_639_1;
  final String? name;

  SpokenLanguagesEntity({this.english_name, this.iso_639_1, this.name});
}

class CastEntity {
  final bool? adult;
  final int? gender;
  final int? id;
  final String? known_for_department;
  final String? name;
  final String? original_name;
  final double? popularity;
  final String? profile_path;
  final int? cast_id;
  final String? character;
  final String? credit_id;
  final int? order;

  CastEntity(
      {this.adult,
      this.gender,
      this.id,
      this.known_for_department,
      this.name,
      this.original_name,
      this.popularity,
      this.profile_path,
      this.cast_id,
      this.character,
      this.credit_id,
      this.order});
}

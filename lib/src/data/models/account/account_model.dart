// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:movie_app/src/data/models/account/account_enttity.dart';

class AccountModel extends AccountEntity {
  AccountModel(
      {super.avatar_path,
      super.id,
      super.include_adult,
      super.iso_3166_1,
      super.iso_639_1,
      super.name,
      super.username});

  factory AccountModel.fromMap(Map<String, dynamic> json) => AccountModel(
        avatar_path: json['avatar_path'],
        id: json['id'],
        include_adult: json['include_adult'],
        iso_3166_1: json['iso_3166_1'],
        iso_639_1: json['iso_639_1'],
        name: json['name'],
        username: json['username'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "avatar_path": avatar_path,
        "id": id,
        "include_adult": include_adult,
        "iso_3166_1": iso_3166_1,
        "iso_639_1": iso_639_1,
        "name": name,
        "username": username,
      };

  @override
  String toString() => json.encode(toJson());
}

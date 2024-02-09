import 'dart:convert';

import 'package:movie_app/src/data/models/genre/genre_entity.dart';

class GenreModel extends GenreEntity {
  GenreModel({super.id, super.name});

  factory GenreModel.fromMap(Map<String, dynamic> json) => GenreModel(
      id: int.tryParse(json['id']?.toString() ?? ''),
      name: json['name']?.toString());

  Map<String, dynamic> toJson() => <String, dynamic>{"id": id, "name": name};

  @override
  String toString() => json.encode(toJson());
}

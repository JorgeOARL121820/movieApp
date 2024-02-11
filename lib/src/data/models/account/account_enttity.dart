// ignore_for_file: non_constant_identifier_names

class AccountEntity {
  final int? id;
  final String? iso_639_1;
  final String? iso_3166_1;
  final String? name;
  final bool? include_adult;
  final String? username;
  final String? avatar_path;

  AccountEntity(
      {this.id,
      this.iso_639_1,
      this.iso_3166_1,
      this.name,
      this.include_adult,
      this.username,
      this.avatar_path});
}

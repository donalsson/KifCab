import 'dart:convert';

import 'dart:ffi';

class CourseDuration {
  String id;
  String name;


  CourseDuration(
    String id,
    String name,
  ) {
    this.id = id;
    this.name = name;

  }

  CourseDuration.fromJson(Map json)
      : id = json['id'],
        name = json['name'];

  Map toJson() {
    return {
      'id': id,
      'name': name
    };
  }

  static Map<String, dynamic> toMap(CourseDuration courseDuration) => {
        'id': courseDuration.id,
        'name': courseDuration.name,

      };


  CourseDuration.fill(
      {this.id,
      this.name});

}

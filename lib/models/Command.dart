import 'dart:convert';

import 'dart:ffi';

class Command {
  String id;
  int status;
  DateTime date_creation;
  String depart;
  String arrive;
  int hdebut;
  double cout;


  Command(
    String id,
      int status,
    DateTime date_creation,
    String depart,
    String arrive,
    int hdebut,
    double cout,
  ) {
    this.id = id;
    this.status = status;
    this.date_creation = date_creation;
    this.depart = depart;
    this.arrive = arrive;
    this.hdebut = hdebut;
    this.cout = cout;

  }

  Command.fromJson(Map json)
      : id = json['id'] as String,
        status = json['status'] as int ,
        depart = json['depart'] as String,
        arrive = json['arrive'] as String,
        hdebut = json['hdebut'] as int,
        cout = json['cout'] as double,
    date_creation = DateTime.parse(json['date_creation']);

  Map toJson() {
    return {
      'id': id,
      'arrive': arrive,
      'depart': depart,
      'hdebut': hdebut,
      'cout': cout,
      'date_creation': date_creation,
    };
  }

  static Map<String, dynamic> toMap(Command command) => {
    'id': command.id,
    'arrive':  command.arrive,
    'depart':  command.depart,
    'hdebut':  command.hdebut,
    'cout':  command.cout,
    'date_creation':  command.date_creation,

      };


  Command.fill(
      {this.id,
      this.arrive, this.depart, this.hdebut, this.cout, this.date_creation});

}

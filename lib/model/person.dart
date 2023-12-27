class Person {
  String? id;
  String? publicName;

  Person({this.id, this.publicName});

  factory Person.fromJson(var json) {
    return Person(
      id: json['id'] != null ? '${json['id']}' : '',
      publicName: json['name'] != null ? json['name'] : '',
    );
  }
}

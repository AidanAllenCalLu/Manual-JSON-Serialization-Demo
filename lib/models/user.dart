class User {

  final String name;
  final String email;
  final int age;

  User(this.name, this.email, this.age);

  User.fromJson(Map<String, dynamic> json)
    : name = json['name'] as String,
    email = json['email'] as String,
    age = json['age'] as int;

  Map<String, dynamic> toJson() => {'name': name, 'email' : email, 'age': age};

}
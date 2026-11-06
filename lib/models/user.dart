
class User {
  final int? id;
  final String name;
  final String email;
  final int age;

  User(this.name, this.email, this.age, {this.id});

  // Convert incoming JSON into a User object.
  factory User.fromJson(Map<String, dynamic> json) {
    final name = json['name'] ??
        '${json['firstName']} ${json['lastName']}';

    return User(
      name as String,
      json['email'] as String,
      json['age'] as int,
      id: json['id'] as int?,
    );
  }

  // Convert User object into JSON.
  

  Map<String, dynamic> toJson() {
    // Separate the full name into first and last names.
    final nameParts = name.trim().split(RegExp(r'\s+'));

    final firstName = nameParts.first;
    final lastName = nameParts.length > 1
        ? nameParts.skip(1).join(' ')
        : '';

    return {
      if (id != null) 'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'age': age,
    };
  }

  
}

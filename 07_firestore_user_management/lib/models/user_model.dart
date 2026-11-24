/// Firestore User Model matching Udemy Section 20
class UserModel {
  final String id;
  final String name;
  final String city;
  final int salary;

  UserModel({
    required this.id,
    required this.name,
    required this.city,
    required this.salary,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      name: data['name'] as String? ?? '',
      city: data['city'] as String? ?? '',
      salary: data['salary'] is int
          ? data['salary'] as int
          : int.tryParse(data['salary']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'city': city,
    'salary': salary,
  };
}

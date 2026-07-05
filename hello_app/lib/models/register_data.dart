class RegisterData {
  final String studentId;
  final String name;
  final String surname;
  final String major;
  final String phone;

  const RegisterData({
    required this.studentId,
    required this.name,
    required this.surname,
    required this.major,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
        'studentId': studentId,
        'name': name,
        'surname': surname,
        'major': major,
        'phone': phone,
      };

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      studentId: json['studentId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      surname: json['surname']?.toString() ?? '',
      major: json['major']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
    );
  }
}

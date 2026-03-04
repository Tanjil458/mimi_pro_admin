class Employee {
  final int? id;
  final String employeeId; // e.g. EMP-20260304-153012
  final String name;
  final String phone;
  final String role; // DRIVER, HELPER, DSR
  final double salary;
  final String salaryType; // Daily / Monthly
  final String password;

  Employee({
    this.id,
    required this.employeeId,
    required this.name,
    required this.phone,
    required this.role,
    required this.salary,
    required this.salaryType,
    required this.password,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'employee_code': employeeId,
    'name': name,
    'phone': phone,
    'role': role,
    'salary': salary,
    'salary_type': salaryType,
    'password': password,
  };

  factory Employee.fromMap(Map<String, dynamic> map) => Employee(
    id: map['id'],
    employeeId: map['employee_code'] ?? '',
    name: map['name'],
    phone: map['phone'] ?? '',
    role: map['role'] ?? 'DRIVER',
    salary: (map['salary'] as num?)?.toDouble() ?? 0.0,
    salaryType: map['salary_type'] ?? 'Monthly',
    password: map['password'] ?? '',
  );

  Employee copyWith({
    int? id,
    String? employeeId,
    String? name,
    String? phone,
    String? role,
    double? salary,
    String? salaryType,
    String? password,
  }) => Employee(
    id: id ?? this.id,
    employeeId: employeeId ?? this.employeeId,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    role: role ?? this.role,
    salary: salary ?? this.salary,
    salaryType: salaryType ?? this.salaryType,
    password: password ?? this.password,
  );
}

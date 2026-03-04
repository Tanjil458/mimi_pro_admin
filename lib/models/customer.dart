class Customer {
  final int? id;
  final String customerId; // e.g. cus-20260304153012-001
  final String name;
  final String phone;
  final String address;
  final int? areaId;

  Customer({
    this.id,
    required this.customerId,
    required this.name,
    required this.phone,
    required this.address,
    this.areaId,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'customer_code': customerId,
    'name': name,
    'phone': phone,
    'address': address,
    'area_id': areaId,
  };

  factory Customer.fromMap(Map<String, dynamic> map) => Customer(
    id: map['id'],
    customerId: map['customer_code'] ?? '',
    name: map['name'],
    phone: map['phone'],
    address: map['address'],
    areaId: map['area_id'],
  );

  Customer copyWith({
    int? id,
    String? customerId,
    String? name,
    String? phone,
    String? address,
    int? areaId,
  }) => Customer(
    id: id ?? this.id,
    customerId: customerId ?? this.customerId,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    address: address ?? this.address,
    areaId: areaId ?? this.areaId,
  );
}

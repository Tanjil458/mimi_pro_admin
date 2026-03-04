class Order {
  final int? id;
  final int customerId;
  final String status; // pending, confirmed, delivered, cancelled
  final double total;
  final String createdAt;

  Order({
    this.id,
    required this.customerId,
    required this.status,
    required this.total,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'customer_id': customerId,
    'status': status,
    'total': total,
    'created_at': createdAt,
  };

  factory Order.fromMap(Map<String, dynamic> map) => Order(
    id: map['id'],
    customerId: map['customer_id'],
    status: map['status'],
    total: map['total'],
    createdAt: map['created_at'],
  );

  Order copyWith({
    int? id,
    int? customerId,
    String? status,
    double? total,
    String? createdAt,
  }) => Order(
    id: id ?? this.id,
    customerId: customerId ?? this.customerId,
    status: status ?? this.status,
    total: total ?? this.total,
    createdAt: createdAt ?? this.createdAt,
  );
}

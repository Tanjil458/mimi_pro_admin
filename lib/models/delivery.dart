class Delivery {
  final int? id;
  final int orderId;
  final int? employeeId;
  final String status; // assigned, on_the_way, delivered, failed
  final String? deliveryDate;

  Delivery({
    this.id,
    required this.orderId,
    this.employeeId,
    required this.status,
    this.deliveryDate,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'order_id': orderId,
    'employee_id': employeeId,
    'status': status,
    'delivery_date': deliveryDate,
  };

  factory Delivery.fromMap(Map<String, dynamic> map) => Delivery(
    id: map['id'],
    orderId: map['order_id'],
    employeeId: map['employee_id'],
    status: map['status'],
    deliveryDate: map['delivery_date'],
  );

  Delivery copyWith({
    int? id,
    int? orderId,
    int? employeeId,
    String? status,
    String? deliveryDate,
  }) => Delivery(
    id: id ?? this.id,
    orderId: orderId ?? this.orderId,
    employeeId: employeeId ?? this.employeeId,
    status: status ?? this.status,
    deliveryDate: deliveryDate ?? this.deliveryDate,
  );
}

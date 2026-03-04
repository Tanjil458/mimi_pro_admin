class Credit {
  final int? id;
  final int customerId;
  final double amount; // positive = credit given, negative = payment received
  final String date;
  final String? note;

  Credit({
    this.id,
    required this.customerId,
    required this.amount,
    required this.date,
    this.note,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'customer_id': customerId,
    'amount': amount,
    'date': date,
    'note': note,
  };

  factory Credit.fromMap(Map<String, dynamic> map) => Credit(
    id: map['id'],
    customerId: map['customer_id'],
    amount: map['amount'],
    date: map['date'],
    note: map['note'],
  );

  Credit copyWith({
    int? id,
    int? customerId,
    double? amount,
    String? date,
    String? note,
  }) => Credit(
    id: id ?? this.id,
    customerId: customerId ?? this.customerId,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    note: note ?? this.note,
  );
}

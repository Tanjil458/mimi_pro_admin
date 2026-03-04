class Product {
  final int? id;
  final String name;
  final double price;
  final int stock;
  final String? description;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.description,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'price': price,
    'stock': stock,
    'description': description,
  };

  factory Product.fromMap(Map<String, dynamic> map) => Product(
    id: map['id'],
    name: map['name'],
    price: map['price'],
    stock: map['stock'],
    description: map['description'],
  );

  Product copyWith({
    int? id,
    String? name,
    double? price,
    int? stock,
    String? description,
  }) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    price: price ?? this.price,
    stock: stock ?? this.stock,
    description: description ?? this.description,
  );
}

class Vehicle {
  final int id;
  final String name;
  final int capacity;
  final int startPrice;
  final int kmPrice;

  Vehicle({
    required this.id,
    required this.name,
    required this.capacity,
    required this.startPrice,
    required this.kmPrice,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: int.parse(json['id']),
      name: json['name'],
      capacity: int.parse(json['capacity']),
      startPrice: int.parse(json['start_price']),
      kmPrice: int.parse(json['km_price']),
    );
  }
}
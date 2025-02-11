class Car {
  final int id;
  final String brand;
  final String model;
  final int year;
  final int condition;

  Car({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.condition,
  });

  // Convert JSON Map to a Car object
  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
      condition: json['condition'],
    );
  }

  // Convert Car object to JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'year': year,
      'condition': condition,
    };
  }
}

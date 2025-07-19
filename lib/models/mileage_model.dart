class MileageModel {
  final String vehicleType;
  final double distance;
  final double fuelUsed;
  final double mileage;

  MileageModel({
    required this.vehicleType,
    required this.distance,
    required this.fuelUsed,
    required this.mileage,
  });

  Map<String, dynamic> toMap({bool useServerTimestamp = false}) {
    return {
      'vehicleType': vehicleType,
      'distance': distance,
      'fuelUsed': fuelUsed,
      'mileage': mileage,
    };
  }

  factory MileageModel.fromMap(Map<String, dynamic> map) {
    return MileageModel(
      vehicleType: map['vehicleType'],
      distance: (map['distance'] as num).toDouble(),
      fuelUsed: (map['fuelUsed'] as num).toDouble(),
      mileage: (map['mileage'] as num).toDouble(),
    );
  }
}

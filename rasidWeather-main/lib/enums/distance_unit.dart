

enum DistanceUnit {
  km,
  mi,
}

extension DistanceUnitExtension on DistanceUnit {
  String get units {
    switch (this) {
      case DistanceUnit.km:
        return 'km';

      case DistanceUnit.mi:
      return 'mi';
    }
  }

  String get getText {
    switch (this) {
      case DistanceUnit.km:
        return 'km';
      case DistanceUnit.mi:
      return 'mi';
    }
  }
}

DistanceUnit getDistanceUnit(
  String distanceUnit,
) {
  switch (distanceUnit) {
    case 'km':
      return DistanceUnit.km;

    case 'mi':
    default:
      return DistanceUnit.mi;
  }
}

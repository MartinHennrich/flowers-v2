import '../constants/enums.dart';

int soilMoistureToInt(SoilMoisture value) {
  switch (value) {
    case SoilMoisture.Soil0:
      return 0;
    case  SoilMoisture.Soil25:
      return 25;
    case  SoilMoisture.Soil50:
      return 50;
    case  SoilMoisture.Soil75:
      return 75;
    case SoilMoisture.Soil100:
      return 100;
    default:
      return 25;
  }
}

SoilMoisture intToSoilMoisture(int value) {
  switch (value) {
    case 0:
      return SoilMoisture.Soil0;
    case 25:
      return SoilMoisture.Soil25;
    case 50:
      return SoilMoisture.Soil50;
    case 75:
      return SoilMoisture.Soil75;
    case 100:
      return SoilMoisture.Soil100;
    default:
      return SoilMoisture.Soil25;
  }
}

// TODO: make this % based in the future
int postponeSoilMoistureToDays(SoilMoisture soilMoisture) {
  switch (soilMoisture) {
    case SoilMoisture.Soil25:
    case SoilMoisture.Soil0:
      return 1;
    case SoilMoisture.Soil50:
      return 1;
    case SoilMoisture.Soil75:
      return 2;
    case SoilMoisture.Soil100:
      return 3;
    default:
      return 0;
  }
}

// TODO: make this % based in the future
int soilMoistureToNextWaterDays(SoilMoisture soilMoisture) {
  switch (soilMoisture) {
    case SoilMoisture.Soil0:
      return -2;
    case SoilMoisture.Soil25:
      return -1;
    case SoilMoisture.Soil50:
      return 0;
    case SoilMoisture.Soil75:
      return 1;
    case SoilMoisture.Soil100:
      return 2;
    default:
      return 0;
  }
}


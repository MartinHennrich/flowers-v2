import '../constants/enums.dart';

int waterAmountToInt(WaterAmount value) {
  switch (value) {
    case WaterAmount.Small:
      return 0;
    case WaterAmount.Normal:
      return 1;
    case WaterAmount.Lots:
      return 2;
    default:
      return 1;
  }
}

WaterAmount intToWaterAmount(int value) {
  switch (value) {
    case 0:
      return WaterAmount.Small;
    case 1:
      return WaterAmount.Normal;
    case 2:
      return WaterAmount.Lots;
    default:
      return WaterAmount.Normal;
  }
}

// TODO: make this % based in the future
int waterAmountToNextWaterDays(WaterAmount waterAmount) {
  switch (waterAmount) {
    case WaterAmount.Small:
      return -1;
    case WaterAmount.Normal:
      return 0;
    case WaterAmount.Lots:
      return 1;
    default:
      return 0;
  }
}

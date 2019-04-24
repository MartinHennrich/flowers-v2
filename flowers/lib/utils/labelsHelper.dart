
import '../flower.dart';
import '../store.dart';
import './colors.dart';

List<Label> getAllUniqLabels() {
  List<Flower> flowers = AppStore.state.flowers;
  List<Label> allLabels = [];
  List<Label> uniqLabels = [];

  flowers.forEach((flower) {
    if (flower.labels != null) {
      allLabels.addAll(flower.labels);
    }
  });

  allLabels.forEach((label) {
    try {
      uniqLabels.firstWhere((uniqLabel) => uniqLabel.value == label.value);
    } catch (e) {
      uniqLabels.add(label);
    }
  });

  return uniqLabels;
}

List<Label> getAllUniqLabelsForFlower(List<Label> flowerLabels) {
  List<Label> allUniqLabels = getAllUniqLabels();

  return allUniqLabels.where((label) {
    try {
      flowerLabels.firstWhere((uniqLabel) => uniqLabel.value == label.value);
      return false;
    } catch (e) {
      return true;
    }
  }).toList();
}

Label createOrGetLabel(String value) {
  String formattedValue = value.trim();
  List<Label> allUniqLabels = getAllUniqLabels();

  return allUniqLabels.firstWhere(
    (uniqLabel) => uniqLabel.value == value,
    orElse: () {
      var color = getRandomLabelColor();
      return Label(
        value: formattedValue,
        color: color
      );
    }
  );
}

import 'package:flutter/material.dart';

import '../flower.dart';
import '../utils/flowerHelpers.dart';
import './flowerCard.dart';

class FlowersList extends StatelessWidget {
  final List<Flower> flowers;
  final bool disabled;
  final bool withHero;
  final bool withReminderBar;
  final Function(Flower flower) onPress;
  final Function(Flower flower) onLongPress;
  final List<String> selectedIds;

  FlowersList({
    this.flowers,
    this.onPress,
    this.disabled = false,
    this.withHero = false,
    this.withReminderBar = false,
    this.onLongPress,
    this.selectedIds = const [],
  });

  List<Widget> _getFlowersListWidgets(List<Flower> flowers, BuildContext context) {
    return flowers.map((flower) {
      return FlowerCard(
        flower: flower,
        onPress: onPress,
        disabled: disabled,
        withHero: withHero,
        isSelected: selectedIds.contains(flower.key),
        withReminderBar: withReminderBar,
        onLongPress: this.onLongPress,
      );
    }).toList();
  }

  List<Row> _buildFlowerRows(List<List<Widget>> pairedFlowers) {
    return pairedFlowers.map((flowerPair) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: flowerPair.cast<Widget>(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Row> flowersToWater = _buildFlowerRows(
      pairFlowers(
        _getFlowersListWidgets(
          this.flowers,
          context
        )
      )
    );

    return Container(
      child: Column(
        children: flowersToWater,
      )
    );
  }
}

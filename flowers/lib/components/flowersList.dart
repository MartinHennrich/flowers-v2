import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../flower.dart';
import '../constants/colors.dart';
import '../utils/flowerHelpers.dart';

import '../utils/colors.dart';

class FlowersList extends StatelessWidget {
  final List<Flower> flowers;
  final bool disabled;
  final Function(Flower flower) onPress;

  FlowersList({
    this.flowers,
    this.onPress,
    this.disabled = false,
  });

  LinearGradient _getColor(Flower flower) {

    if (disabled) {
      return BlueGradient;
    }

    return getColorBasedOnTime(flower.nextWaterTime);
  }

  List<Widget> _getFlowersListWidgets(List<Flower> flowers, BuildContext context) {
    return flowers.map((flower) {
      Color timeBasedColor = getColorBasedOnTime2(flower.nextWaterTime, flower.lastTimeWatered);
      Color _kKeyUmbraOpacity = timeBasedColor.withAlpha(51);
      Color _kKeyPenumbraOpacity = timeBasedColor.withAlpha(36);
      Color _kAmbientShadowOpacity =timeBasedColor.withAlpha(31);

      return GestureDetector(
        onTap: disabled ? null : () {
          onPress(flower);
        },
        child: Container(
          width: 144,
          height: 170,
          margin: EdgeInsets.fromLTRB(0, 16, 16, 0),
          decoration: BoxDecoration(
            color: Colors.black12,
            image: DecorationImage(
              image: CachedNetworkImageProvider(flower.imageUrl),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                height: 50,
                alignment: Alignment(-1.0, 0.0),
                padding: EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  gradient: _getColor(flower),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(8.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(offset: Offset(0.0, 3.0), blurRadius: 3.0, spreadRadius: -2.0, color: _kKeyUmbraOpacity),
                    BoxShadow(offset: Offset(0.0, 3.0), blurRadius: 4.0, spreadRadius: 0.0, color: _kKeyPenumbraOpacity),
                    BoxShadow(offset: Offset(0.0, 1.0), blurRadius: 8.0, spreadRadius: 0.0, color: _kAmbientShadowOpacity),
                  ],
                ),
                child: Text(
                  flower.name,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  )
                )
              ),
            ],
          )
        )
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

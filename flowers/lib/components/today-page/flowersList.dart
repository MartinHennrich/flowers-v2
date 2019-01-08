import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../flower.dart';
import '../../constants/colors.dart';
import '../../utils/flowerHelpers.dart';
import './water-dialog/waterDialog.dart';
import '../../utils/colors.dart';

class FlowersList extends StatelessWidget {
  final List<Flower> flowers;
  final bool disabled;

  FlowersList({
    this.flowers,
    this.disabled = false
  });

  List<Widget> _getFlowersListWidgets(List<Flower> flowers, BuildContext context) {
    return flowers.map((flower) {
      return GestureDetector(
        onTap: disabled ? null : () {
          print('watering');
          showDialog(
            context: context,
            builder: (_) => WaterDialog(flower: flower)
          );
        },
        child: Container(
          width: 160,
          height: 190,
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
                  gradient: disabled
                    ? BlueGradient
                    : getColorBasedOnTime(flower.nextWaterTime),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(8.0)),
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

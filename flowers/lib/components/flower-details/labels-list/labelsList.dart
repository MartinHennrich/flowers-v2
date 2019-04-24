import 'package:flutter/material.dart';

import '../../../presentation/customScrollColor.dart';
import '../../../flower.dart';

class LabelsList extends StatelessWidget {
  final List<Label> labels;
  final bool hasTitle;
  final Function(Label) onLabelPress;
  final List<Label> selected;

  LabelsList({
    this.labels,
    this.hasTitle = false,
    this.onLabelPress,
    this.selected = const []
  });


  Widget _hasTitle(Widget widget) {
    return hasTitle
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(40, 20, 0, 6),
              child:Text('LABELS',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black38,
                fontSize: 12
              ))
            ),
            widget
          ],
      )
      : widget;
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;
    List<Widget> chips = labels.map((label) {
      EdgeInsets padding = EdgeInsets.only(left: 12);

      if (index == 0) {
        padding = EdgeInsets.only(left: 20);
      } else if (index + 1 == labels.length) {
        padding = EdgeInsets.fromLTRB(12, 0, 20, 0);
      }
      bool isSelected = false;
      if (selected.length > 0) {
        var v = selected.firstWhere(
          (selectedLabel) => selectedLabel.value == label.value,
          orElse: () => null);
        if (v != null) {
          isSelected = true;
        }
      }

      index += 1;
      return Padding(
        padding: padding,
        child: onLabelPress != null
        ? InputChip(
          selected: isSelected,
          label: Text(label.value),
          backgroundColor: label.color,
          onPressed: () {
            onLabelPress(label);
          },
        )
        : Chip(
          label: Text(label.value),
          backgroundColor: label.color,
        ));
    }).toList();

    if (labels.length == 0) {
      return Container();
    }

    return _hasTitle(Container(
      height: onLabelPress != null ? 60 : 36 ,
      child: CustomScrollColor(
        axisDirection: AxisDirection.right,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: chips
        )
      )
    ));
  }
}

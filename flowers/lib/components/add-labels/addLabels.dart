import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

import '../../presentation/customScrollColor.dart';
import '../../utils/labelsHelper.dart';
import '../../flower.dart';
import '../../utils/firebase-redux.dart';
import '../../presentation/custom_icons_icons.dart';
import '../../utils/rewardAdHelpers.dart';
import '../../ad.dart';

class AddLabels extends StatefulWidget {
  final List<Label> allAvailable;
  final List<Label> activeLabels;
  final Flower flower;

  AddLabels({
    this.allAvailable,
    this.activeLabels,
    this.flower
  });

  @override
  AddLabelsState createState() {
    return AddLabelsState();
  }
}

class AddLabelsState extends State<AddLabels> {
  final _formKey = GlobalKey<FormState>();
  bool isUnlocked = false;
  List<Label> allAvailable;
  List<Label> activeLabels;

  @override
  void initState() {
    super.initState();

    allAvailable = widget.allAvailable;
    activeLabels = widget.activeLabels;
    isRewardUnlocked(labelRewardKey)
      .then((bool isUnlocked) {
        setState(() {
          this.isUnlocked = isUnlocked;
        });
      });
    RewardedVideoAd.instance.listener = (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.rewarded) {
        setState(() {
          this.isUnlocked = true;
        });
        setRewardLockStatus(labelRewardKey, DateTime.now().toIso8601String());
      }
    };
  }

  void _onCreateLable(String value) {
    if (!isUnlocked && widget.flower.labels.length > 0) {
      RewardedVideoAd.instance.load(
        adUnitId: rewardId,
        targetingInfo: targetingInfo
      )..then((_) {
        RewardedVideoAd.instance..show();
      });
    }

    Label label = createOrGetLabel(value.trim());

    Label hasLabel = widget.flower.labels.firstWhere(
      (flowerLabel) => flowerLabel.value == label.value,
      orElse: () => null
    );

    if (hasLabel != null) {
      return;
    }

    addLabel(widget.flower, label);
  }

  void _onRemoveFromFlower(Label label) {
    setState(() {
      widget.flower.removeLable(label);
      activeLabels = widget.flower.labels;
      allAvailable = getAllUniqLabelsForFlower(activeLabels);
    });
    removeLabel(widget.flower, label);
  }

  void _onAddAvailable(Label label) {
    addLabel(widget.flower, label);
    setState(() {
      activeLabels = widget.flower.labels;
      allAvailable = getAllUniqLabelsForFlower(activeLabels);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> avaiable = activeLabels.map((label) {
      return Chip(
        label: Text(label.value),
        backgroundColor: label.color,
        onDeleted: () {
          _onRemoveFromFlower(label);
        },
      );
    }).toList();

    List<Widget> allLabels = allAvailable.map((label) {
      return InputChip(
        label: Text(label.value),
        backgroundColor: label.color,
        onPressed: () {
          print('pressing anothre');
          _onAddAvailable(label);
        },
      );
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text('EDIT LABELS'),
        actions: <Widget>[

        ],
      ),
      body: CustomScrollColor(child: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Form(
            key: _formKey,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  isUnlocked
                  ? Container()
                  : Icon(
                    Icons.videocam,
                    size: 14,
                    color: Colors.black26,
                  ),
                  TextFormField(
                    maxLength: 24,
                    onFieldSubmitted: (String value) {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _formKey.currentState.reset();
                        _onCreateLable(value);
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'label name',
                      labelText: 'Create label',
                    ),
                    validator: (String value) {
                      if (value.length < 2) {
                        return 'Minimun of 2 chars';
                      }

                      if (value.length > 24) {
                        return 'Max of 14 chars';
                      }

                      return null;
                    },
                  ),
                ]
              )
            )
          ),

          Container(
            padding: EdgeInsets.only(top: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Active for "${widget.flower.name}"'),
                avaiable.length > 0
                  ? Wrap(
                    spacing: 16,
                    children: avaiable,
                  )
                  : Container(
                    alignment: Alignment(0, 0),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: <Widget>[
                        Icon(CustomIcons.emo_displeased, color: Colors.black26,),
                        Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Text('no active', style: TextStyle(
                            fontSize: 12,
                            color: Colors.black38
                          ),)
                        )
                      ],
                    )
                  )
              ],
            )
          ),
          Container(
            padding: EdgeInsets.only(top: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Active on other flowers'),
                avaiable.length > 0 || allLabels.length > 0
                  ? Wrap(
                    spacing: 16,
                    children: allLabels,
                  )
                  : Container(
                    alignment: Alignment(0, 0),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: <Widget>[
                        Icon(CustomIcons.emo_unhappy, color: Colors.black26,),
                        Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Text('no created labels', style: TextStyle(
                            fontSize: 12,
                            color: Colors.black38
                          ),)
                        )
                      ],
                    )
                  )
              ],
            )
          ),
        ],
      )
    ));
  }
}

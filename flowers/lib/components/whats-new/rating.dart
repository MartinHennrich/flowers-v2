import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../constants/colors.dart';
import '../gradientMaterialButton.dart';
import '../../utils/firebase.dart';

const List<String> emojis = [
  '😡',
  '🙁',
  '😐',
  '😃',
  '😍',
];

class Rating extends StatefulWidget {

  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  int currentRatingValue;

  void _onRate(int value) {
    setState(() {
      currentRatingValue = value;
    });
    try {
      database.addRating(value);
    } catch (e) {}
  }

  void _launchPlaystore() async {
    const url = 'https://play.google.com/store/apps/details?id=com.richardsoderman.flowers';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      }
    } catch (e) {
      print('could not load :(');
    }
  }

  _launchFeedback() async {
    const url = 'mailto:richard.soderman@gmail.com?subject=<subject>&body=<body>';
    try {
      if (await canLaunch(url)) {
        await launch(url);
      }
    } catch (e) {
      print('could not load mail to');
    }
  }

  @override
  Widget build(BuildContext context) {
    var emojiStyle = TextStyle(
      fontSize: 24
    );
    return Container(
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 0, 16),
            child: Text('Rate', style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            )),
          ),
          currentRatingValue == null
           ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child: Text('😡', style: emojiStyle),
                onTap: () { _onRate(0); },
              ),
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text('🙁', style: emojiStyle)),
                onTap: () { _onRate(1); },
              ),
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text('😐', style: emojiStyle)),
                onTap: () { _onRate(2); },
              ),
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text('😃', style: emojiStyle)),
                onTap: () { _onRate(3); },
              ),
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text('😍', style: emojiStyle)),
                onTap: () { _onRate(4); },
              ),
            ],
          )
          :  Container(
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text(emojis[currentRatingValue], style: TextStyle(
                  fontSize: 32
                )),
              ),

              GradientButton(
                width: 180,
                height: 40,
                buttonRadius: BorderRadius.all(Radius.circular(8)),
                gradient: GreenGradient,
                child: currentRatingValue > 2
                  ? Text('Rate on Google play',)
                  : Text('Send us feedback'),
                onPressed: () {
                  currentRatingValue > 2
                    ? _launchPlaystore()
                    : _launchFeedback();
                },
              )
          ],))

      ])
    );
  }
}

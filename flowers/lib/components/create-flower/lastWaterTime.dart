import 'package:flutter/material.dart';

import '../../constants/colors.dart';

enum LastWaterTimes {
  Today,
  Yesterday,
  Custom
}

class LastWaterTime extends StatelessWidget {
  final Function(DateTime) onSave;

  LastWaterTime({
    @required this.onSave
  });

  Widget _getGenericButton(Function onPressed, String text, LastWaterTimes activeValue, LastWaterTimes lastWaterTime, {ShapeBorder shape}) {
    return FlatButton(
      onPressed: () {
        onPressed();
      },
      color: activeValue == lastWaterTime ? SecondMainColor : Colors.black12,
      shape: shape,
      child: Text(text,
        style: TextStyle(
          color: activeValue == lastWaterTime ? Colors.white : Colors.black45
        )
      ),
    );
  }

  Widget _getYesterDay(FormFieldState<dynamic> lastWaterTimeForm) {
    return _getGenericButton(
      () {
        lastWaterTimeForm.setValue({
          'enum': LastWaterTimes.Yesterday,
          'time': DateTime.now().subtract(Duration(days: 1))
        });
        lastWaterTimeForm.setState(() {});
      },
      'Yesterday',
      lastWaterTimeForm.value['enum'],
      LastWaterTimes.Yesterday,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(20)))
    );
  }

  Widget _getToday(FormFieldState<dynamic> lastWaterTimeForm) {
    return _getGenericButton(
      () {
        lastWaterTimeForm.setValue({
          'enum': LastWaterTimes.Today,
          'time': DateTime.now()
        });
        lastWaterTimeForm.setState(() {});
      },
      'Today',
      lastWaterTimeForm.value['enum'],
      LastWaterTimes.Today,
    );
  }

  Widget _getCustom(FormFieldState<dynamic> lastWaterTimeForm, BuildContext context) {
    return FlatButton(
      onPressed: () async {
        DateTime time = DateTime.now();

        DateTime pickedTime = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(time.year, time.month, 1),
          lastDate: DateTime(time.year, time.month, 31),
        );

        if (pickedTime != null) {
          lastWaterTimeForm.setValue({
            'enum': LastWaterTimes.Custom,
            'time': pickedTime,
          });
          lastWaterTimeForm.setState(() {});
        }
      },
      color: lastWaterTimeForm.value['enum'] == LastWaterTimes.Custom ? SecondMainColor : Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(20))),
      child: lastWaterTimeForm.value['enum'] == LastWaterTimes.Custom
        ? Text('${lastWaterTimeForm.value['time'].month} / ${lastWaterTimeForm.value['time'].day}', style: TextStyle(color: Colors.white))
        : Text('Pick a date..', style: TextStyle(color: Colors.black45)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: {
        'enum': LastWaterTimes.Today,
        'time': DateTime.now()
      },
      onSaved: (form) {
        onSave(form['time']);
      },
      builder: (lastWaterTimeForm) {
        return Container(
          padding: EdgeInsets.only(top: 24),
          child: Column(
            children: <Widget>[
              Text('Last time watered?',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _getYesterDay(lastWaterTimeForm),
                  Container(
                    width: 4,
                  ),
                  _getToday(lastWaterTimeForm),
                  Container(
                    width: 4,
                  ),
                  _getCustom(lastWaterTimeForm, context),
                ],
              ),
            ],
          )
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

import '../../constants/colors.dart';

enum PickTimes {
  Morning,
  Evening,
  Custom
}

PickTimes dateTimPickTimes(DateTime time) {
  if (time.hour == 8 && time.minute == 0) {
    return PickTimes.Morning;
  }

  if (time.hour == 18 && time.minute == 0) {
    return PickTimes.Evening;
  }

  return PickTimes.Custom;
}

class PickTime extends StatelessWidget {
  final Function(Map<String, dynamic> value) onChange;
  final dynamic value;
  final Color color;

  PickTime({
    this.onChange,
    this.value,
    this.color = BlueMain,
  });

  Widget _getGenericButton(Function onPressed, String text, PickTimes activeValue, PickTimes PickTime, {
    ShapeBorder shape = const RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(0)))
  }) {
    return FlatButton(
      onPressed: () {
        onPressed();
      },
      color: activeValue == PickTime ? color : Colors.black12,
      shape: shape,
      child: Text(text,
        style: TextStyle(
          color: activeValue == PickTime ? Colors.white : Colors.black45
        )
      ),
    );
  }

  Widget _getEvening() {
    return _getGenericButton(
      () {
        onChange({
          'enum': PickTimes.Evening,
          'time': TimeOfDay(hour: 18, minute: 0)
        });
      },
      'Evening 18:00',
      value['enum'],
      PickTimes.Evening,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }

  Widget _getMorning() {
    return _getGenericButton(
      () {
        onChange({
          'enum': PickTimes.Morning,
          'time': TimeOfDay(hour: 8, minute: 0)
        });
      },
      'Morning 8:00',
      value['enum'],
      PickTimes.Morning,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }

  Widget _getCustom(BuildContext context) {
    String hour = '${
      value['time'].hour < 10
        ? '0${value['time'].hour}'
        : value['time'].hour
    }';

    String minute = '${
      value['time'].minute < 10
        ? '0${value['time'].minute}'
        : value['time'].minute
    }';

    return FlatButton(
      onPressed: () async {

        TimeOfDay pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: 8, minute: 0)
        );

        if (pickedTime != null) {
          onChange({
            'enum': PickTimes.Custom,
            'time': pickedTime,
          });
        }
      },
      color: value['enum'] == PickTimes.Custom ? color : Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      child: value['enum'] == PickTimes.Custom
        ? Text('$hour:$minute', style: TextStyle(color: Colors.white))
        : Text('Pick a time..', style: TextStyle(color: Colors.black45)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, 0),
      padding: EdgeInsets.only(top: 24),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text('Notification time?',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16
              )
            )
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _getMorning(),
              Container(
                width: 4,
              ),
              _getEvening(),
              Container(
                width: 4,
              ),
              _getCustom(context),
            ],
          ),
        ],
      )
    );
  }
}

class PickTimeForm extends StatelessWidget {
  final Function(DateTime) onSave;
  final Function(Map<String, dynamic>) onChange;
  final Map<String, dynamic> intialValue;
  final Color color;

  PickTimeForm({
    this.onSave,
    this.intialValue = const {
      'enum': PickTimes.Morning,
      'time': TimeOfDay(hour: 8, minute: 0)
    },
    this.onChange,
    this.color = BlueMain,
  });

  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: intialValue,
      onSaved: (form) {
        TimeOfDay time = form['time'];
        DateTime pickedTime = DateTime(2019, 1, 1, time.hour, time.minute);
        onSave(pickedTime);
      },
      builder: (pickTimeForm) {
        return PickTime(
          value: pickTimeForm.value,
          color: color,
          onChange: (Map<String, dynamic> value) {
            if (onChange != null) {
              onChange(value);
            }
            pickTimeForm.setValue(value);
            pickTimeForm.setState(() {});
          },
        );
      },
    );
  }
}

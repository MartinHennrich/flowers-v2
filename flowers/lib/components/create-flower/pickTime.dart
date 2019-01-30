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
  final Function(DateTime) onSave;
  final Map<String, dynamic> intialValue;

  PickTime({
    this.onSave,
    this.intialValue = const {
      'enum': PickTimes.Morning,
      'time': TimeOfDay(hour: 8, minute: 0)
    }
  });

  Widget _getGenericButton(Function onPressed, String text, PickTimes activeValue, PickTimes PickTime, {
    ShapeBorder shape = const RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(0)))
  }) {
    return FlatButton(
      onPressed: () {
        onPressed();
      },
      color: activeValue == PickTime ? BlueMain : Colors.black12,
      shape: shape,
      child: Text(text,
        style: TextStyle(
          color: activeValue == PickTime ? Colors.white : Colors.black45
        )
      ),
    );
  }

  Widget _getEvening(FormFieldState<dynamic> pickTimeForm) {
    return _getGenericButton(
      () {
        pickTimeForm.setValue({
          'enum': PickTimes.Evening,
          'time': TimeOfDay(hour: 18, minute: 0)
        });
        pickTimeForm.setState(() {});
      },
      'Evening 18:00',
      pickTimeForm.value['enum'],
      PickTimes.Evening,
      /* shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(20))) */
    );
  }

  Widget _getMorning(FormFieldState<dynamic> pickTimeForm) {
    return _getGenericButton(
      () {
        pickTimeForm.setValue({
          'enum': PickTimes.Morning,
          'time': TimeOfDay(hour: 8, minute: 0)
        });
        pickTimeForm.setState(() {});
      },
      'Morning 8:00',
      pickTimeForm.value['enum'],
      PickTimes.Morning,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(20)))
    );
  }

  Widget _getCustom(FormFieldState<dynamic> pickTimeForm, BuildContext context) {
    return FlatButton(
      onPressed: () async {

        TimeOfDay pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: 8, minute: 0)
        );

        if (pickedTime != null) {
          pickTimeForm.setValue({
            'enum': PickTimes.Custom,
            'time': pickedTime,
          });
          pickTimeForm.setState(() {});
        }
      },
      color: pickTimeForm.value['enum'] == PickTimes.Custom ? BlueMain : Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(20))),
      child: pickTimeForm.value['enum'] == PickTimes.Custom
        ? Text('${pickTimeForm.value['time'].hour}:${pickTimeForm.value['time'].minute}', style: TextStyle(color: Colors.white))
        : Text('Pick a time..', style: TextStyle(color: Colors.black45)),
    );
  }

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
        return Container(
          padding: EdgeInsets.only(top: 24),
          child: Column(
            children: <Widget>[
              Text('Notification time?',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _getMorning(pickTimeForm),
                  Container(
                    width: 4,
                  ),
                  _getEvening(pickTimeForm),
                  Container(
                    width: 4,
                  ),
                  _getCustom(pickTimeForm, context),
                ],
              ),
            ],
          )
        );
      },
    );
  }
}

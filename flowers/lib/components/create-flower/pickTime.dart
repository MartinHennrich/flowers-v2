import 'package:flutter/material.dart';

import '../../constants/colors.dart';

enum PickTimes {
  Morning,
  Evening,
  Custom
}

class PickTime extends StatelessWidget {
  final Function(DateTime) onSave;

  PickTime({
    @required this.onSave
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
          'time': TimeOfDay.fromDateTime(DateTime(2019, 1, 1, 18, 0))
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
          'time': TimeOfDay.fromDateTime(DateTime(2019, 1, 1, 8, 0))
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
          initialTime: TimeOfDay.fromDateTime(DateTime(2019, 1, 1, 8, 0))
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
      initialValue: {
        'enum': PickTimes.Morning,
        'time': TimeOfDay.fromDateTime(DateTime(2019, 1, 1, 8, 0))
      },
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

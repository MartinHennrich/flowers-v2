import 'package:flutter/material.dart';

import '../../constants/colors.dart';

enum LastActionTimes {
  Today,
  Yesterday,
  Custom
}

class LastActionTime extends StatelessWidget {
  final Function(DateTime) onSave;
  final String type;

  LastActionTime({
    @required this.onSave,
    this.type
  });

  Widget _getGenericButton(Function onPressed, String text, LastActionTimes activeValue, LastActionTimes lastActionTime, {
    ShapeBorder shape = const RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(0)))
  }) {
    return FlatButton(
      onPressed: () {
        onPressed();
      },
      color: activeValue == lastActionTime ? BlueMain : Colors.black12,
      shape: shape,
      child: Text(text,
        style: TextStyle(
          color: activeValue == lastActionTime ? Colors.white : Colors.black45
        )
      ),
    );
  }

  Widget _getYesterDay(FormFieldState<dynamic> lastActionTimeForm) {
    return _getGenericButton(
      () {
        lastActionTimeForm.setValue({
          'enum': LastActionTimes.Yesterday,
          'time': DateTime.now().subtract(Duration(days: 1))
        });
        lastActionTimeForm.setState(() {});
      },
      'Yesterday',
      lastActionTimeForm.value['enum'],
      LastActionTimes.Yesterday,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(left: Radius.circular(20)))
    );
  }

  Widget _getToday(FormFieldState<dynamic> lastActionTimeForm) {
    return _getGenericButton(
      () {
        lastActionTimeForm.setValue({
          'enum': LastActionTimes.Today,
          'time': DateTime.now()
        });
        lastActionTimeForm.setState(() {});
      },
      'Today',
      lastActionTimeForm.value['enum'],
      LastActionTimes.Today,
    );
  }

  Widget _getCustom(FormFieldState<dynamic> lastActionTimeForm, BuildContext context) {
    return FlatButton(
      onPressed: () async {
        DateTime time = DateTime.now();
        DateTime firstDate = time.subtract(Duration(days: 20));

        DateTime pickedTime = await showDatePicker(
          context: context,
          initialDate: DateTime.now().subtract(Duration(days: 2)),
          firstDate: DateTime(firstDate.year, firstDate.month, 1),
          lastDate: DateTime(time.year, time.month, time.day),
        );

        if (pickedTime != null) {
          lastActionTimeForm.setValue({
            'enum': LastActionTimes.Custom,
            'time': pickedTime,
          });
          lastActionTimeForm.setState(() {});
        }
      },
      color: lastActionTimeForm.value['enum'] == LastActionTimes.Custom ? BlueMain : Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(20))),
      child: lastActionTimeForm.value['enum'] == LastActionTimes.Custom
        ? Text('${lastActionTimeForm.value['time'].month} / ${lastActionTimeForm.value['time'].day}', style: TextStyle(color: Colors.white))
        : Text('Pick a date..', style: TextStyle(color: Colors.black45)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: {
        'enum': LastActionTimes.Today,
        'time': DateTime.now()
      },
      onSaved: (form) {
        onSave(form['time']);
      },
      builder: (lastActionTimeForm) {
        return Container(
          padding: EdgeInsets.only(top: 24),
          child: Column(
            children: <Widget>[
              Text('Last time ${this.type}?',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16
                )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _getYesterDay(lastActionTimeForm),
                  Container(
                    width: 4,
                  ),
                  _getToday(lastActionTimeForm),
                  Container(
                    width: 4,
                  ),
                  _getCustom(lastActionTimeForm, context),
                ],
              ),
            ],
          )
        );
      },
    );
  }
}

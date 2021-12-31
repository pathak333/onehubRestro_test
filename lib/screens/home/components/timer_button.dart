import 'package:flutter/material.dart';
import 'package:onehubrestro/utilities/colors.dart';
import 'package:onehubrestro/utilities/test_styles.dart';

class TimerButton extends StatefulWidget {
  const TimerButton({
    Key key, 
    this.initialTime,
    this.onIncrease,
    this.onChange, 
    this.onDecrease})
      : super(key: key);

  final int initialTime;
  final Function(int) onDecrease;
  final Function(int) onIncrease;
  final Function(int) onChange;

  @override
  _TimerButtonState createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> {

  int time;

  @override
  void initState() {
    time = widget.initialTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: grey),
          borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: [
          Expanded(
            flex: 20,
            child: InkWell(
              child: Center(
                  child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          border: Border(right: BorderSide(color: grey))),
                      alignment: Alignment.center,
                      child: Icon(Icons.remove, color: kSecondaryColor))),
              onTap: () {
                setState(() {
                  if(time > 0)
                  time--;
                });
                widget.onChange(time);
              },
            ),
          ),
          Expanded(
            flex: 80,
            child: Container(
              padding: EdgeInsets.all(15),
              child: Text('$time ${time == 1 ? 'Min' : 'Mins'}',
                  style: AppTextStyle.getPoppinsSemibold(),
                  textAlign: TextAlign.center),
            ),
          ),
          Expanded(
            flex: 20,
            child: InkWell(
              child: Center(
                  child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          border: Border(left: BorderSide(color: grey))),
                      alignment: Alignment.center,
                      child: Icon(Icons.add, color: kSecondaryColor))),
              onTap: () {
                setState(() {
                  if(time < 30)
                  time++;
                });
                widget.onChange(time);
              },
            ),
          )
        ],
      ),
    );
  }
}

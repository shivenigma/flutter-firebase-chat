import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final Color color;
  final Text label;
  final Function callback;
  ActionButton({this.color, this.label, this.callback});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: callback,
          minWidth: 200.0,
          height: 42.0,
          child: label,
        ),
      ),
    );
  }
}

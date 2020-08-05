import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button({@required this.icon, @required this.onPressed, this.color});

  final IconData icon;

  final VoidCallback onPressed;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints(),
      padding: EdgeInsets.zero,
      child: Icon(
        icon,
        size: 50,
        color: color,
      ),
      onPressed: onPressed,
    );
  }
}

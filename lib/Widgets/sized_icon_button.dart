import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

///Custom IconButton
///with a [VoidCallback]
///
///
class SizedIconButton extends StatelessWidget {
  ///[width] sets the size of the icon
  ///[icon] sets the icon
  /// [onPressed] is the callback
  const SizedIconButton({this.width, this.icon, this.onPressed});

  ///[width] sets the size of the icon
  final double width;

  ///[icon] sets the icon
  final IconData icon;

  /// [onPressed] is the callback
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextButton(
        onPressed: onPressed,
        child: Icon(
          icon,
          
          color: Colors.black,
        ),
      ),
    );
  }
}

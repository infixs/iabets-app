import 'package:flutter/material.dart';

class ButtonActivity extends StatelessWidget {
  final bool enabled;
  final List<Color> activeColors;
  final List<Color> inactiveColors;
  final Widget activityChild;
  final Widget inactivityChild;
  final void Function(bool)? onPressed;

  const ButtonActivity({
    Key? key,
    required this.activityChild,
    required this.inactivityChild,
    required this.enabled,
    required this.activeColors,
    required this.inactiveColors,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200),
          gradient: LinearGradient(
            colors: enabled ? activeColors : inactiveColors,
          ),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, offset: Offset(-1, 1), spreadRadius: 1)
          ]),
      child: ElevatedButton(
        onPressed: () {
          if (onPressed != null) onPressed!(!enabled);
        },
        style: ElevatedButton.styleFrom(
          elevation: 1,
          minimumSize: const Size(75, 75),
          padding: const EdgeInsets.all(0),
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: enabled ? activityChild : inactivityChild,
      ),
    );
  }
}

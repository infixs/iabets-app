import 'package:flutter/material.dart';

class CustomAppBarSettings extends StatelessWidget
    implements PreferredSizeWidget {
  final Widget child;
  final double height;

  const CustomAppBarSettings(
      {required this.child, this.height = kToolbarHeight, Key? key})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: preferredSize.height,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xffdb2134),
              Color(0xfff22c4d),
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomAppBarGalesPage extends StatelessWidget
    implements PreferredSizeWidget {
  final Widget child;
  final double height;

  const CustomAppBarGalesPage(
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
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: child,
      ),
    );
  }
}

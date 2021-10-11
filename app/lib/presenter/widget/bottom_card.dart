import 'package:flutter/material.dart';

class BottomCard extends StatelessWidget {
  final Widget child;

  const BottomCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: child,
    );
  }
}

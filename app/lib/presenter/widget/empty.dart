import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
  final String message;
  final Widget action;

  const Empty({
    Key? key,
    required this.message,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(message),
          const SizedBox(height: 16),
          action,
        ],
      ),
    );
  }
}

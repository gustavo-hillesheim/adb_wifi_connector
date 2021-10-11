import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'ADB WiFi',
            style: Theme.of(context).textTheme.headline1,
          ),
          Text(
            'Connector',
            style: Theme.of(context).textTheme.headline2,
          ),
        ],
      ),
    );
  }
}

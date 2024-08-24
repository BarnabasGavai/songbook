import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:songbookapp/logic/connectivity_service.dart';

class MyRouting extends StatelessWidget {
  const MyRouting({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityService>(
        builder: (context, internetNotifier, child) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}

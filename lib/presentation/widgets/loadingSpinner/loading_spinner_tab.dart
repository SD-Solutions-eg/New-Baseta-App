import 'package:flutter/material.dart';

class LoadingSpinnerTablet extends StatelessWidget {
  const LoadingSpinnerTablet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

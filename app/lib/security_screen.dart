import 'package:flutter/material.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Security'), // Add the title 'Security' to the app bar
      ),
      body: Center(
        child: Text('Security Screen Content'), // Add your screen content here
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'poll_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Enter Auto'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PollScreen()),
            );
          },
        ),
      ),
    );
  }
}
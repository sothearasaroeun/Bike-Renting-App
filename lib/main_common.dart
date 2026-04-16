import 'package:flutter/material.dart';
import 'ui/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bike Renting App',
      theme: AppTheme.theme,
      home: Scaffold(
        appBar: AppBar(title: Text('Bike Renting')),
        body: Center(child: Text('Welcome to the best app')),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pagination/pagination_screen.dart';

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const PaginationScreen(),
    );
  }
}

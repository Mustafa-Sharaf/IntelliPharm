
import 'package:flutter/material.dart';
import '../../Widgets/HomeAppBar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(height: MediaQuery.of(context).size.height * 0.12),
      body: Column(children: []),
    );
  }
}

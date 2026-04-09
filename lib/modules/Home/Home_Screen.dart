import 'package:flutter/material.dart';

import '../../Widgets/AppBarHome.dart';
import '../../Widgets/MenuHome.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xfff2f2f2),
      drawer: const DrawerHome(),
      appBar: AppbarHome(scaffoldKey:scaffoldKey ,),
      body:Column(
        children: [],
      )
    );
  }
}

import 'package:flutter/widgets.dart';

import 'home_page.dart';
import 'mobile_home_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1000) {
          return HomePage();
        } else {
          return MobileHome();
        }
      },
    );
  }
}

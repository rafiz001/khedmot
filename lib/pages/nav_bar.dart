import 'package:flutter/material.dart';
class NavBar extends StatefulWidget {
  NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
   int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
       child: NavigationBar(destinations: [
      NavigationDestination(icon: Icon(Icons.calculate_outlined), label: "পারসেন্ট"),
      NavigationDestination(icon: Icon(Icons.calendar_month_outlined), label: "মাসিক হিসাব"),
      
     ],
     height: 60,
     selectedIndex: currentIndex,
     onDestinationSelected: (value) {
       setState(() {
         currentIndex = value;
       });
     },),
    );
  }
}
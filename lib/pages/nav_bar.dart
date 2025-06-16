import 'package:flutter/material.dart';
import 'package:khedmot/data/valueNotifier.dart';
class NavBar extends StatelessWidget {
  NavBar({Key? key}) : super(key: key);

 @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: selectedPageNotifier, builder: (context, selectedPage, child) {
      return NavigationBar(destinations: [
      NavigationDestination(icon: Icon(Icons.calendar_month_outlined), label: "মাসিক হিসাব"),
      NavigationDestination(icon: Icon(Icons.calculate_outlined), label: "পারসেন্ট"),
      
     ],
     height: 60,
     selectedIndex: selectedPage,
     onDestinationSelected: (value) {
       selectedPageNotifier.value = value;
     },
    );
    },);
  }
}
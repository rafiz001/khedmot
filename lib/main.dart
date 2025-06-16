import 'package:flutter/material.dart';
import 'package:khedmot/data/valueNotifier.dart';
import 'package:khedmot/pages/months.dart';
import 'package:khedmot/pages/nav_bar.dart';
import 'package:khedmot/pages/persent.dart';
import 'package:khedmot/widgets/drawer_widget.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khedmot',
      theme: ThemeData(
        fontFamily: 'NikoshBAN',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 20.0)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        fontFamily: 'NikoshBAN',
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 20.0),
          labelLarge: TextStyle(fontSize: 20),
          //labelMedium: TextStyle(fontSize: 20),
          labelSmall: TextStyle(fontSize: 20),
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,

      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor:
              Theme.of(context).colorScheme.surfaceContainer,
          systemNavigationBarIconBrightness:
              Theme.of(context).brightness == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark,
          statusBarColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: const Text("খেদমত"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ValueListenableBuilder(
          valueListenable: selectedPageNotifier,
          builder: (BuildContext context, dynamic selectedPage, Widget? child) {
            return selectedPage == 0 ? Months() : Persent();
          },
        ),
      ),
      drawer: DrawerWidget(),
      bottomNavigationBar: NavBar(),
      extendBody: true,
    );
  }
}

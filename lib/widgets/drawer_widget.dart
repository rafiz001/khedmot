import 'package:flutter/material.dart';
import 'package:khedmot/data/valueNotifier.dart';

class DrawerWidget extends StatefulWidget {
  DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final TextEditingController percentNumberController = TextEditingController(
    text: "${percentNumberNotifier.value}%",
  );
  @override
  void dispose() {
    percentNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Text("সকল প্রশংসা একমাত্র আল্লাহ তায়া'লার জন্য"),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: percentNumberController,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'পারসেন্ট',
              ),
            ),
            SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                String percentString =
                    percentNumberController.text.split("%")[0];
                    percentNumberNotifier.value= int.parse(percentString);
                Navigator.pop(context);//closing drawer
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("$percentString% সেইভ হয়ে গেছে। ")));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.save), SizedBox(width: 10), Text("সেইভ")],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:khedmot/data/database_helper.dart';

class DrawerWidget extends StatefulWidget {
  DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController percentNumberController = TextEditingController(
    text: "---%",
  );

  @override
  void initState() {
    super.initState();
    _refreshUserList();
  }

  Future<void> _refreshUserList() async {
    final data = await _dbHelper.getPersent();
    setState(() {
      percentNumberController.value = TextEditingValue(text: "$data%");
    });
  }

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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
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
                    onPressed: () async {
                      String percentString =
                          percentNumberController.text.split("%")[0];

                      final confirm = await _dbHelper.updatePersent(
                        int.parse(percentString),
                      );
                      Navigator.pop(context); //closing drawer
                      if (confirm == 1) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("$percentString% সেইভ হয়ে গেছে। "),
                          ),
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save),
                        SizedBox(width: 10),
                        Text("সেইভ"),
                      ],
                    ),
                  ),

                  SizedBox(height: 100),
                  OutlinedButton(
                    onPressed: () {
                      //final directory = await getExternalStorageDirectory();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.download),
                        SizedBox(width: 10),
                        Text("ডাউনলোড ডেটা"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

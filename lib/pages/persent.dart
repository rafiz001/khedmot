import 'package:flutter/material.dart';
import 'package:khedmot/data/database_helper.dart';
import 'package:khedmot/data/valueNotifier.dart';

class Persent extends StatefulWidget {
  Persent({super.key});
  @override
  _PersentState createState() => _PersentState();
}

class _PersentState extends State<Persent> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  double theNumber = 0;
  double percent = 0.10;
  int percentInt = 0;
  @override
  void initState() {
    super.initState();
    _refreshUserList();
  }

  Future<void> _refreshUserList() async {
    final data = await _dbHelper.getPersent();
    setState(() {      
    percent = data / 100;
    percentInt = data;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            '$theNumber এর ${percentInt} % = ${theNumber * percent} ',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            '$theNumber + ${theNumber * percent} = ${theNumber + theNumber * percent}',
            style: TextStyle(fontSize: 20, color: Colors.green),
          ),
          Text(
            '$theNumber - ${theNumber * percent} = ${theNumber - theNumber * percent}',
            style: TextStyle(fontSize: 20, color: Colors.red),
          ),
          TextField(
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "নাম্বার লিখুন"),
            style: Theme.of(context).textTheme.bodyMedium,
            onChanged: (value) {
              setState(() {
                double? numberLocal = double.tryParse(value);
                theNumber = numberLocal ?? 0;
              });
            },
          ),
        ],
      ),
    );
  }
}

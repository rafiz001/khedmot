import 'package:flutter/material.dart';
import 'package:khedmot/data/valueNotifier.dart';

class Persent extends StatefulWidget {
  Persent({Key? key}) : super(key: key);
  @override
  _PersentState createState() => _PersentState();
}

class _PersentState extends State<Persent> {
  double theNumber = 0;
  double percent = percentNumberNotifier.value / 100;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            '$theNumber এর ${percentNumberNotifier.value} % = ${theNumber * percent} ',
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

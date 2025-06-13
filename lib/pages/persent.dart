import 'package:flutter/material.dart';


class Persent extends StatefulWidget {
  Persent({Key? key}) : super(key: key);
  
  @override
  _PersentState createState() => _PersentState();
}
class _PersentState extends State<Persent> {
double theNumber = 0 ;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('$theNumber এর 25 % = ${theNumber*0.25} ' , style: TextStyle(fontSize: 20),),
          TextField(
            autofocus: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "নাম্বার লিখুন"),
            onChanged: (value) {
              setState(() {
                double? numberLocal = double.tryParse(value);
                 theNumber = numberLocal??0;
              });
            },
          ),
        ],
      ),
    );
  }
}

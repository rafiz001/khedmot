import 'package:flutter/material.dart';
import 'package:khedmot/pages/sources.dart';

class Months extends StatefulWidget {
  Months({Key? key}) : super(key: key);

  @override
  _MonthsState createState() => _MonthsState();
}

class _MonthsState extends State<Months> {
  List<String> months = [
    "জানুয়ারি",
    "ফেব্রুয়ারি",
    "মার্চ",
    "এপ্রিল",
    "মে",
    "জুন",
    "জুলাই",
    "আগস্ট",
    "সেপটেম্বর",
    "অক্টোবর",
    "নভেম্বর",
    "ডিসেম্বর",
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Sources();
            },));
          },
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.source),
                SizedBox(width: 10),
                Text("উৎসসমুহ"),
              ],
            ),
          ),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            children:
                months
                    .map(
                      (month) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text('Alert!'),
                                      content: Text(month),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(
                                                context,
                                              ), // Close dialog
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(month, textAlign: TextAlign.center),
                                Text("000৳", textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }
}

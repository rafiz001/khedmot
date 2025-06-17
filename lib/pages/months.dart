import 'package:flutter/material.dart';
import 'package:khedmot/data/database_helper.dart';
import 'package:khedmot/pages/sources.dart';

class Months extends StatefulWidget {
  Months({Key? key}) : super(key: key);

  @override
  _MonthsState createState() => _MonthsState();
}

class _MonthsState extends State<Months> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<List<String>> months = [
    ["জানুয়ারি","jan_sum"],
    ["ফেব্রুয়ারি","feb_sum"],
    ["মার্চ","mar_sum"],
    ["এপ্রিল","apr_sum"],
    ["মে","may_sum"],
    ["জুন","jun_sum"],
    ["জুলাই","jul_sum"],
    ["আগস্ট","aug_sum"],
    ["সেপটেম্বর","sep_sum"],
    ["অক্টোবর","oct_sum"],
    ["নভেম্বর","nov_sum"],
    ["ডিসেম্বর","dec_sum"],
  ];
   List<Map<String, dynamic>> data = [
    {
      "jan_sum":"---",
      "feb_sum":"---",
      "mar_sum":"---",
      "apr_sum":"---",
      "may_sum":"---",
      "jun_sum":"---",
      "jul_sum":"---",
      "aug_sum":"---",
      "sep_sum":"---",
      "oct_sum":"---",
      "nov_sum":"---",
      "dec_sum":"---",
    },
  ];
  @override
  void initState() {
    super.initState();
    _refreshUserList();
  }

  Future<void> _refreshUserList() async {
    data = await _dbHelper.getSum();
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    _refreshUserList();
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
                List.generate( months.length,
                      (index) => Padding(
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
                            onTap: () { },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(months[index][0], textAlign: TextAlign.center),
                                Text("${data[0][months[index][1]]??"---"}৳", textAlign: TextAlign.center),
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

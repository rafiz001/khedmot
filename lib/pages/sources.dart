import 'package:flutter/material.dart';
import 'package:khedmot/data/database_helper.dart';
import 'package:khedmot/pages/edit_source.dart';

class Sources extends StatefulWidget {
  const Sources({super.key});

  @override
  State<Sources> createState() => _SourcesState();
}

class _SourcesState extends State<Sources> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> data = [
    {"name": "কোন উৎস নেই! ", "id": 0},
  ];
  @override
  void initState() {
    super.initState();
    _refreshUserList();
  }

  Future<void> _refreshUserList() async {
    data = await _dbHelper.getUsers();
    setState(() {
      // print(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    _refreshUserList();
    return Scaffold(
      appBar: AppBar(
        title: Text("উৎস সমুহ"),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: ListView.separated(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(
            tileColor: Theme.of(context).colorScheme.secondaryContainer,
            title: Text(data[index]["name"], style: TextStyle(fontSize: 20)),
            leading: Icon(Icons.school_outlined),
            trailing:
                (data[index]["active"]) == 1
                    ? Icon(Icons.done, color: Colors.green)
                    : Icon(Icons.close, color: Colors.red) ,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return EditSource(id: data[index]["id"]);
                  },
                ),
              );
            },
          );
        },
        separatorBuilder:
            (context, index) => const Divider(height: 1, color: Colors.grey),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final data = await _dbHelper.insertUser({
            "name": "মুসলিম ভাই",
            "active": 1,
            "jan": 0,
            "feb": 0,
            "mar": 0,
            "apr": 0,
            "may": 0,
            "jun": 0,
            "jul": 0,
            "aug": 0,
            "sep": 0,
            "oct": 0,
            "nov": 0,
            "dec": 0,
          });

          setState(() {
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    content: Text("নতুন এন্ট্রি যুক্ত হয়েছে।  "),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context), // Close dialog
                        child: const Text('আলহামদুলিল্লাহ!'),
                      ),
                    ],
                  ),
            );
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

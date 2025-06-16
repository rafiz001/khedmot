import 'package:flutter/material.dart';
import 'package:khedmot/pages/edit_source.dart';

class Sources extends StatelessWidget {
  const Sources({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("উৎস সমুহ"),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: ListView.separated(
        itemCount: 50,
        itemBuilder: (context, index) {
          return ListTile(
            tileColor: Theme.of(context).colorScheme.secondaryContainer,
            title: Text("রফিজ", style: TextStyle(fontSize: 20)),
            leading: Icon(Icons.school_outlined),
            onTap: () {
              
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return EditSource();
              },));
            },
          );
        },
        separatorBuilder:
            (context, index) => const Divider(height: 1, color: Colors.grey),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}

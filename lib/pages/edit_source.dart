import 'package:flutter/material.dart';

class EditSource extends StatefulWidget {
  const EditSource({super.key});

  @override
  State<EditSource> createState() => _EditSourceState();
}

class _EditSourceState extends State<EditSource> {
  List<String> inputs = [
    "উৎসের নাম",
    "উৎসের ID",
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
    "সক্রিয়",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("আব্দুল্লাহ"),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: inputs.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                SizedBox(height: 10),
                index <= 13
                    ? TextField(
                      enabled: index != 1,
                      keyboardType: TextInputType.number,
                      //controller: percentNumberController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: inputs[index],
                      ),
                    )
                    : Column(
                      children: [
                        ListTile(
                          title: Text(inputs[index]),
                          trailing: Switch(value: true, onChanged: (value) {}),
                        ),
                        SizedBox(height: 70,)
                      ],
                    )
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  content: Text("সেইভ তো হইলো ধরে নেন। "),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context), // Close dialog
                      child: const Text('আলহামদুলিল্লাহ!'),
                    ),
                  ],
                ),
          );
        },
        child: Icon(Icons.save),
      ),
    );
  }
}

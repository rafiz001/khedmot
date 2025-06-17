import 'package:flutter/material.dart';
import 'package:khedmot/data/database_helper.dart';

class EditSource extends StatefulWidget {
  const EditSource({super.key, required this.id});
  final int id;
  @override
  State<EditSource> createState() => _EditSourceState();
}

class _EditSourceState extends State<EditSource> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<List<String>> inputs = [
    ["উৎসের নাম", "name"],
    ["উৎসের ID", "id"],
    ["জানুয়ারি", "jan"],
    ["ফেব্রুয়ারি", "feb"],
    ["মার্চ", "mar"],
    ["এপ্রিল", "apr"],
    ["মে", "may"],
    ["জুন", "jun"],
    ["জুলাই", "jul"],
    ["আগস্ট", "aug"],
    ["সেপটেম্বর", "sep"],
    ["অক্টোবর", "oct"],
    ["নভেম্বর", "nov"],
    ["ডিসেম্বর", "dec"],
    ["সক্রিয়", "active"],
  ];
  List<TextEditingController> editor = List.generate(
    15,
    (index) => TextEditingController(),
  );
  bool active = false;
  Map<String, dynamic>? data;
  @override
  void initState() {
    super.initState();
    _refreshUserList();
  }

  Future<void> _refreshUserList() async {
    data = await _dbHelper.getUser(widget.id);
    setState(() {
      for (var i = 0; i < editor.length; i++) {
        String entry = inputs[i][1];
        editor[i].value = TextEditingValue(text: "${data?[entry]}");
      }
    });
    active = data?["active"] == 1 ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${data?["name"]}"),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        actions: [IconButton(onPressed: () {
                    showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  content: Text("আপনি কি সত্যি ডিলিট করতে চান? হিসাব গুলোও কিন্তু ডিলিট হয়ে যাবে! "),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context), // Close dialog
                      child: const Text('না, থাক!'),
                    ),
                    TextButton(
                      onPressed: ()  {
                        _dbHelper.deleteUser(widget.id);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('হ্যা, সরাতে চাই!'),
                    ),
                  ],
                ),
          );
        }, icon: Icon(Icons.delete, color: Colors.red),)],
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
                      controller: editor[index],
                      enabled: index != 1,
                      keyboardType:
                          index == 0
                              ? TextInputType.name
                              : TextInputType.number,
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: inputs[index][0],
                      ),
                    )
                    : Column(
                      children: [
                        ListTile(
                          title: Text(inputs[index][0]),
                          trailing: Switch(
                            value: active,
                            onChanged: (value) {
                              setState(() {
                                active = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 70),
                      ],
                    ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Map<String, dynamic> toBeSaved = {};
          for (var i = 0; i < editor.length; i++) {
            toBeSaved[inputs[i][1]] = editor[i].text;
          }

          toBeSaved["active"] = active ? 1 : 0;
          _dbHelper.updateUser(toBeSaved);

          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  content: Text("সেইভ হয়ে গেছে। "),
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

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Box box = Hive.box('furryindonesia');

  final TextEditingController nimController =
      TextEditingController();

  final TextEditingController namaController =
      TextEditingController();

  int? editIndex;

  void simpanData() {
    if (nimController.text.isEmpty ||
        namaController.text.isEmpty) {
      return;
    }

    box.add({
      "nim": nimController.text,
      "nama": namaController.text,
    });

    nimController.clear();
    namaController.clear();

    setState(() {});
  }

  void updateData() {
    box.putAt(editIndex!, {
      "nim": nimController.text,
      "nama": namaController.text,
    });

    editIndex = null;

    nimController.clear();
    namaController.clear();

    setState(() {});
  }

  void editData(int index) {
    var data = box.getAt(index);

    nimController.text = data["nim"];
    namaController.text = data["nama"];

    editIndex = index;

    setState(() {});
  }

  void hapusData(int index) {
    box.deleteAt(index);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CRUD Hive Mahasiswa"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nimController,
              decoration: const InputDecoration(
                labelText: "NIM",
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: "Nama",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                if (editIndex == null) {
                  simpanData();
                } else {
                  updateData();
                }
              },
              child: Text(
                editIndex == null
                    ? "Simpan"
                    : "Update",
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                  var data = box.getAt(index);

                  return Card(
                    child: ListTile(
                      title: Text(data["nama"]),
                      subtitle: Text(data["nim"]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon:
                                const Icon(Icons.edit),
                            onPressed: () {
                              editData(index);
                            },
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.delete),
                            onPressed: () {
                              hapusData(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
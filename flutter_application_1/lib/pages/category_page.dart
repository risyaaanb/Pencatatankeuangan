import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/pages/models/database.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isExpense = true;
  int type = 2;
  final AppDatabase database = AppDatabase();
  TextEditingController categoryNameController = TextEditingController();

  Future insert(String name, int type) async {
    DateTime now = DateTime.now();
    final row = await database.into(database.categories).insertReturning(
        CategoriesCompanion.insert(
            name: name, type: type, createdAt: now, updatedAt: now));
    print('MASUK :' + row.toString());
  }

  Future<List<Category>> getAllCategory(int type) async {
    return await database.getAllCategoryRepo(type);
  }

  void openDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Center(
                  child: Column(
                children: [
                  Text(
                    (isExpense) ? "Add Expense" : "Add Income",
                    style: GoogleFonts.montserrat(
                        fontSize: 18,
                        color: (isExpense) ? Colors.red : Colors.green),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: categoryNameController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: "Name"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        insert(categoryNameController.text, isExpense ? 2 : 1);
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                        setState(() {});
                      },
                      child: Text("Save"))
                ],
              )),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Switch(
              value: isExpense,
              onChanged: (bool value) {
                setState(() {
                  isExpense = value;
                  type = value ? 2 : 1;
                });
              },
              inactiveTrackColor: Colors.green[200],
              inactiveThumbColor: Colors.green,
              activeColor: Colors.red,
            ),
            IconButton(
                onPressed: () {
                  openDialog();
                },
                icon: Icon(Icons.add))
          ],
        ),
      ),
      FutureBuilder<List<Category>>(
          future: getAllCategory(type),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData) {
                if (snapshot.data!.length > 0) {
                  return Text("Ada Data :" + snapshot.data!.length.toString());
                } else {
                  return Center(
                    child: Text("No has data"),
                  );
                }
              } else {
                return Center(
                  child: Text("No has data"),
                );
              }
            }
          }),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          elevation: 10,
          child: ListTile(
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Tambahkan logika untuk menghapus item di sini
                  },
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Tambahkan logika untuk mengedit item di sini
                  },
                ),
              ],
            ),
            leading: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isExpense ? Icons.upload : Icons.download,
                color:
                    isExpense ? Colors.redAccent[400] : Colors.greenAccent[400],
              ),
            ),
            title: Text('Makan Makan'),
          ),
        ),
      )
    ]));
  }
}

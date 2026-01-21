import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final genreController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final imageController = TextEditingController();

  bool isBestSeller = false;
  bool loading = false;

  final Color maroon = const Color(0xFF800000);

  Future<void> addBook() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    await FirebaseFirestore.instance.collection("Products").add({
      "title": titleController.text.trim(),
      "author": authorController.text.trim(),
      "genre": genreController.text.trim(),
      "descripiton": descriptionController.text.trim(),
      "price": priceController.text.trim(),
      "coverimage": imageController.text.trim(),
      "isBestSeller": isBestSeller,
      "createdat": FieldValue.serverTimestamp(),
    });

    setState(() => loading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: maroon,

      appBar: AppBar(
        backgroundColor: maroon,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Add Book",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// White Form Container
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _field("Title", titleController),
                  _field("Author", authorController),
                  _field("Genre", genreController),
                  _field("Description", descriptionController, maxLines: 3),
                  _field("Price", priceController, isNumber: true),
                  _field("Cover Image URL", imageController),

                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      "Best Seller",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    activeThumbColor: maroon,
                    value: isBestSeller,
                    onChanged: (v) => setState(() => isBestSeller = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: loading ? null : addBook,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Add Book",
                        style: TextStyle(
                          color: Color.fromARGB(255, 147, 19, 10),
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController c, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        maxLines: maxLines,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (v) => v!.isEmpty ? "$label required" : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }
}

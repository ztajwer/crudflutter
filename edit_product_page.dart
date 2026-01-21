import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditProductPage extends StatefulWidget {
  final String id;
  final Map<String, dynamic> data;

  const EditProductPage({super.key, required this.id, required this.data});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController titleController;
  late TextEditingController authorController;
  late TextEditingController genreController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController imageController;

  bool isBestSeller = false;
  final Color maroon = const Color(0xFF800000);

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.data["title"]);
    authorController = TextEditingController(text: widget.data["author"]);
    genreController = TextEditingController(text: widget.data["genre"]);
    descriptionController =
        TextEditingController(text: widget.data["descripiton"]);
    priceController = TextEditingController(text: widget.data["price"]);
    imageController = TextEditingController(text: widget.data["coverimage"]);
    isBestSeller = widget.data["isBestSeller"];
  }

  Future<void> updateBook() async {
    await FirebaseFirestore.instance
        .collection("Products")
        .doc(widget.id)
        .update({
      "title": titleController.text,
      "author": authorController.text,
      "genre": genreController.text,
      "descripiton": descriptionController.text,
      "price": priceController.text,
      "coverimage": imageController.text,
      "isBestSeller": isBestSeller,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: maroon,

      appBar: AppBar(
        backgroundColor: maroon,
        elevation: 0,
        title: const Text(
          "Edit Book",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: ListView(
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
                _field("Price", priceController),
                _field("Image URL", imageController),

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
              onPressed: updateBook,
              child: const Text(
                "Update Book",
                style: TextStyle(
                  color: Color.fromARGB(255, 137, 14, 6),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController c, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: c,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }
}
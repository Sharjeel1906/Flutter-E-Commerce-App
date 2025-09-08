import 'dart:convert';
import 'package:ecommerce_app/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'category.dart';

class ShowCategorizedData extends StatefulWidget {
  final String title;
  final String category;

  const ShowCategorizedData({
    super.key,
    required this.title,
    required this.category,
  });

  @override
  State<ShowCategorizedData> createState() => _ShowCategorizedDataState();
}

class _ShowCategorizedDataState extends State<ShowCategorizedData> {
  bool isLoading = true;
  int _selectedIndex = 0;
  List<dynamic> _products = [];

  @override
  void initState() {
    super.initState();
    fetchData(widget.category);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Category()),
      );
    } else if (index == 1) {
      print("Favourite clicked");
    } else if (index == 2) {
      print("Cart clicked");
    }
  }

  Future<void> fetchData(String category) async {
    final response = await http.get(
        Uri.parse("https://dummyjson.com/products/category/$category?limit=200"),
    );
    if (response.statusCode == 200) {
      setState(() {
        _products = json.decode(response.body)["products"];
        isLoading = false;
      });
    } else {
      throw Exception("Failed to load products");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          widget.title.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        toolbarHeight: 60,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.6,
        ),
        itemBuilder: (context, index) {
          final product = _products[index];
          final categorized = product["category"];

          return Card(
            elevation: 5,
            shadowColor: Colors.teal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: Center(
                      child: Image.network(
                        product["thumbnail"],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          product["title"],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 7),
                        Text(
                          "\$${product['price']}",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Center(
                          child: Uihelper.custome_button(
                                () {},
                            "Add to Cart",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

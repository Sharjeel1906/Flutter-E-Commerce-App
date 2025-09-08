import 'dart:convert';
import 'package:ecommerce_app/show_catigorized_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<String> categoryList = [];
  bool isLoading = true; // 👈 add loading flag
  final Map<String, String> categoryThumbnails = {
    "beauty": "https://cdn-icons-png.flaticon.com/512/2921/2921822.png", // makeup palette
    "fragrances": "https://cdn-icons-png.flaticon.com/512/2921/2921823.png", // perfume bottle
    "furniture": "https://cdn-icons-png.flaticon.com/512/1048/1048953.png", // armchair
    "groceries": "https://cdn-icons-png.flaticon.com/512/3081/3081986.png", // grocery bag
    "home-decoration": "https://cdn-icons-png.flaticon.com/512/2907/2907762.png", // home decor
    "kitchen-accessories": "https://cdn-icons-png.flaticon.com/512/1046/1046750.png", // kitchen tools
    "laptops": "https://cdn-icons-png.flaticon.com/512/179/179309.png", // laptop
    "mens-shirts": "https://cdn-icons-png.flaticon.com/512/892/892458.png", // shirt
    "mens-shoes": "https://cdn-icons-png.flaticon.com/512/2921/2921832.png", // men's shoes
    "mens-watches": "https://cdn-icons-png.flaticon.com/512/2921/2921833.png", // men's watch
    "mobile-accessories": "https://cdn-icons-png.flaticon.com/512/1042/1042339.png", // headphones/phone accessories
    "motorcycle": "https://cdn-icons-png.flaticon.com/512/2921/2921839.png", // motorcycle
    "skin-care": "https://cdn-icons-png.flaticon.com/512/2921/2921824.png", // skincare cream
    "smartphones": "https://cdn-icons-png.flaticon.com/512/233/233326.png", // smartphone
    "sports-accessories": "https://cdn-icons-png.flaticon.com/512/1047/1047711.png", // sports ball
    "sunglasses": "https://cdn-icons-png.flaticon.com/512/2921/2921837.png", // sunglasses
    "tablets": "https://cdn-icons-png.flaticon.com/512/747/747933.png", // tablet
    "tops": "https://cdn-icons-png.flaticon.com/512/2921/2921828.png", // t-shirt
    "vehicle": "https://cdn-icons-png.flaticon.com/512/2921/2921838.png", // car/vehicle
    "womens-bags": "https://cdn-icons-png.flaticon.com/512/2921/2921835.png", // handbag
    "womens-dresses": "https://cdn-icons-png.flaticon.com/512/2921/2921829.png", // dress
    "womens-jewellery": "https://cdn-icons-png.flaticon.com/512/2921/2921836.png", // necklace
    "womens-shoes": "https://cdn-icons-png.flaticon.com/512/2921/2921830.png", // high heels
    "womens-watches": "https://cdn-icons-png.flaticon.com/512/2921/2921834.png", // women's watch
  };

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response = await http.get(
      Uri.parse("https://dummyjson.com/products/category-list"),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        categoryList = List<String>.from(jsonData);
        isLoading = false; // 👈 stop loading after data fetched
      });
    } else {
      throw Exception("Failed to load categories");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "🛍️ Categories",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.teal,
          centerTitle: true,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator()) // show spinner
            : GridView.builder(
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 5),
            itemCount: categoryList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:2,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
                mainAxisSpacing: 10
            ),
            itemBuilder: (context,index){
              final category = categoryList[index];
              final img = categoryThumbnails[category];
              return Card(
                elevation: 5,
                shadowColor: Colors.teal,
                child:Column(
                  children: [
                    Expanded(
                      flex: 7,
                      child : Center(
                        child: Image.network(img!,fit: BoxFit.cover,),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Expanded(
                      flex: 3,
                      child: GestureDetector(
                        child: Text(category.toUpperCase(),
                          style: TextStyle(fontSize: 18,
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context)=>ShowCategorizedData(title: category, category: category))
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            })
    );
  }
}

import 'dart:convert';
import 'package:ecommerce_app/cart.dart';
import 'package:ecommerce_app/category.dart';
import 'package:ecommerce_app/description.dart';
import 'package:ecommerce_app/login.dart';
import 'package:ecommerce_app/register.dart';
import 'package:ecommerce_app/show_catigorized_data.dart';
import 'package:ecommerce_app/show_fav.dart';
import 'package:ecommerce_app/splash.dart';
import 'package:ecommerce_app/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  TextEditingController search_cont = TextEditingController(text: "Search");

  List<dynamic> _products = [];
  List<dynamic> filtered_list = [];
  List<String> categories = [
    "All",
    "beauty",
    "fragrances",
    "furniture",
    "groceries",
    "home-decoration",
    "kitchen-accessories",
    "laptops",
    "mens-shirts",
    "mens-shoes",
    "mens-watches",
    "mobile-accessories",
    "motorcycle",
    "skin-care",
    "smartphones",
    "sports-accessories",
    "sunglasses",
    "tablets",
    "tops",
    "vehicle",
    "womens-bags",
    "womens-dresses",
    "womens-jewellery",
    "womens-shoes",
    "womens-watches",
  ];
  List<dynamic> reviews = [];

  bool _isLoading = true;

  Future<void> _fetchData() async {
    final response = await http.get(
      Uri.parse(
        "https://dummyjson.com/products?limit=200",
      ), // or more if API supports it,
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        _products = jsonData['products']; // directly use list of maps
        _isLoading = false;
        filtered_list = _products;
      });
    } else {
      throw Exception("Failed to load products");
    }
  }

  void _filtered_data(String query) {
    if (query.isEmpty) {
      filtered_list = _products;
    } else {
      setState(() {
        filtered_list = _products.where((product) {
          final title = product["title"].toString().toLowerCase();
          return title.contains(query.toLowerCase());
        }).toList();
      });
    }
  }


  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Category()),
      );
    } else if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: "Home")),
      );
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ShowFav()));
    } else if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Cart()));
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const Spacer(),

            // 👇 Conditional UI
            if (user == null) ...[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  ).then((_) => setState(() {})); // refresh after login
                },
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Register()),
                  ).then((_) => setState(() {})); // refresh after register
                },
                child: const Text(
                  "Register",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ] else ...[
              GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  setState(() {}); // refresh after logout
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ],
        ),
        centerTitle: true,
        toolbarHeight: 60,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 14),
        backgroundColor: Colors.teal,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category, size: 30),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, size: 30),
            label: "Favourite",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, size: 30),
            label: "Cart",
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: search_cont,
              decoration: InputDecoration(
                hintText: "Search",
                prefixIcon: Icon(Icons.search, size: 28, color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.teal, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.teal, width: 2),
                ),
              ),
              onChanged: (value) {
                _filtered_data(value);
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: categories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final category = categories[index];
                return TextButton(
                  onPressed: () {
                    if (index == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(title: "Home"),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowCategorizedData(
                            title: category,
                            category: category,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    // width: 75,
                    //height: 35,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.black)],
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          categories[index].toUpperCase(),
                          style: TextStyle(color: Colors.black),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 8,
            child: GridView.builder(
              padding: const EdgeInsets.all(8), // Added padding
              itemCount: filtered_list.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.6, // Adjusted aspect ratio for taller cards
              ),
              itemBuilder: (context, index){
                final product = filtered_list[index];
                return GestureDetector(
                  onTap: (){Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Description(
                        title: product["title"],
                        thumbnail: product["thumbnail"],
                        price: product["price"].toString(),
                        description: product["description"],
                        stock: product["stock"].toString(),
                        rating: product["rating"].toString(),
                        reviews: product["reviews"],
                      ),
                    ),
                  );
                  },
                  child: Card(
                    elevation: 5,
                    shadowColor: Colors.teal,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            // Image takes 60% of vertical space
                            flex: 6,
                            child: Center(
                              child: Image.network(
                                product["thumbnail"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            // Other elements take 40% of vertical space
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  product["title"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  "\$${product['price']}",
                                  style: const TextStyle(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5), // instead of Spacer()
                                Expanded(
                                  child: Center(
                                    child: Uihelper.custome_button(() {
                                      Uihelper.add_to_cart(
                                        context,
                                        product["title"],
                                        product["thumbnail"],
                                        product["price"].toString(),
                                      );
                                    }, "Add to Cart"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

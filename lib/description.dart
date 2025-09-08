import 'package:ecommerce_app/ui_helper.dart';
import 'package:flutter/material.dart';

class Description extends StatefulWidget {
  const Description({
    super.key,
    required this.title,
    required this.thumbnail,
    required this.price,
    required this.description,
    required this.rating,
    required this.stock,
    required this.reviews,
  });

  final String thumbnail;
  final String title;
  final String price;
  final String description;
  final String stock;
  final String rating;
  final List<dynamic> reviews;

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  bool fav = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Product Spotlite",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 20, left: 30, right: 30),
        child: Uihelper.custome_button(() {
          Uihelper.add_to_cart(
            context,
            widget.title,
            widget.thumbnail,
            widget.price,
          );
        }, "Add to Cart"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Card(
              elevation: 5,
              shadowColor: Colors.teal,
              child: Image.network(widget.thumbnail),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 5, top: 10),
                child: Text(
                  widget.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, top: 10),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      fav = !fav;
                      Uihelper.add_to_fav(
                        context,
                        widget.title,
                        widget.thumbnail,
                        widget.price,
                      );
                    });
                  },
                  icon: Icon(
                    fav ? Icons.favorite : Icons.favorite_border,
                    color: fav ? Colors.red : Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 5, top: 10),
            child: Text(
              "\$${widget.price}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Text(
              "Description",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20),
            child: Text(widget.description),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.teal, size: 24),
                const SizedBox(width: 8),
                const Text(
                  "Rating : ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  widget.rating,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Row(
              children: [
                const Icon(Icons.inventory, color: Colors.teal, size: 24,),
                const SizedBox(width: 8),
                const Text(
                  "Stock : ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  widget.stock,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 14),
            child: Text(
              "Reviews",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          ListView.builder(
            shrinkWrap: true, // 👈 allows ListView inside another ListView
            physics: NeverScrollableScrollPhysics(), // 👈 disables inner scroll
            itemCount: widget.reviews.length,
            itemBuilder: (context, index) {
              final review = widget.reviews[index];
              return Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
                child: Card(
                  child: ListTile(
                    leading: const Icon(Icons.person, color: Colors.teal),
                    title: Text("${review["reviewerName"]}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                    subtitle: Text("${review["comment"]}"),
                  ),
                ),
              );
            },
          ),

        ],
      ),
    );
  }
}

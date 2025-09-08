import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Uihelper{
  static Costom_text_feild(TextEditingController controller,String text,IconData icondata,bool toHide ) {
    return TextField(
      controller: controller,
      obscureText: toHide,
      decoration: InputDecoration(
          suffixIcon: Icon(icondata,size: 35,color: Colors.black,),

          label: Text(text,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Colors.teal,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: Colors.teal,
                width: 2,
              )
          )
      ),
    );
  }

  static custome_button(VoidCallback voidcallback, String text) {
    return SizedBox(
      height: 50,
      width: 165,
      child: ElevatedButton(
        onPressed: () {
          voidcallback();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.teal,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(8),
          // ),
          elevation: 5,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static custom_colored_box(BuildContext context, String text) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          " $text",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "OK",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
        ],
      ),
    );
  }


  static void add_to_cart(BuildContext context,String title, String thumbnail, String price) async {
    try {
      await FirebaseFirestore.instance.collection("Cart").add({
        "title": title,
        "thumbnail": thumbnail,
        "price": price,
        "quantity":1,
      });
      Uihelper.custom_colored_box(context, "Added to cart");
    } on FirebaseException catch (ex) {
      Uihelper.custom_colored_box(context, "❌ ${ex.code}");
    }
  }
  static void add_to_fav(BuildContext context,String title, String thumbnail, String price) async {
    try {
      await FirebaseFirestore.instance.collection("Fav").add({
        "title": title,
        "thumbnail": thumbnail,
        "price": price,
      });
      //Uihelper.custom_colored_box(context, "Added to cart");
    } on FirebaseException catch (ex) {
      Uihelper.custom_colored_box(context, "❌ ${ex.code}");
    }
  }
}
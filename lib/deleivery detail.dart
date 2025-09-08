import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/ui_helper.dart';
import 'package:flutter/material.dart';

class Delievrey extends StatefulWidget {
  const Delievrey({super.key});

  @override
  State<Delievrey> createState() => _DelievreyState();
}

class _DelievreyState extends State<Delievrey> {
  var name_cont = TextEditingController();
  var phone_cont = TextEditingController();
  var add_cont = TextEditingController();
  var email_cont = TextEditingController();

  bool isCOD = false;
  bool isOnline = false;

  void _selectCOD(bool? value) {
    setState(() {
      isCOD = value ?? false;
      if (isCOD) isOnline = false; // unselect Online
    });
  }

  void _selectOnline(bool? value) {
    setState(() {
      isOnline = value ?? false;
      if (isOnline) isCOD = false; // unselect COD
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Delivery Details",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                "Details",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Name
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Uihelper.Costom_text_feild(
                    name_cont, "Name", Icons.abc_outlined, false),
              ),

              // Phone
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Uihelper.Costom_text_feild(
                    phone_cont, "Phone No", Icons.phone, false),
              ),

              // Email
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Uihelper.Costom_text_feild(
                    email_cont, "Email", Icons.email, false),
              ),

              // Address
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Uihelper.Costom_text_feild(
                    add_cont, "Address", Icons.home, false),
              ),

              const SizedBox(height: 20),

              // Payment Options
              const Text(
                "Select Payment Method",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              CheckboxListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: const Text("Cash on Delivery"),
                ),
                value: isCOD,
                onChanged: _selectCOD,
              ),

              CheckboxListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: const Text("Online Payment"),
                ),
                value: isOnline,
                onChanged: _selectOnline,
              ),

              const SizedBox(height: 20),

              // Submit Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Uihelper.custome_button(() async {
                  if (!isCOD && !isOnline) {
                    Uihelper.custom_colored_box(
                        context, "Please select a payment method");
                    return;
                  }
                  try {
                    var Name= name_cont.text.toString();
                    var PhoneNo= phone_cont.text.toString();
                    var Address =  add_cont.text.toString();
                    var Email =  email_cont.text.toString();
                    await FirebaseFirestore.instance
                        .collection("Order_detail")
                        .add({
                      "Name": Name,
                      "Phone No": PhoneNo,
                      "Address": Address,
                      "Email": Email,
                      "Payment Method": isCOD
                          ? "Cash on Delivery"
                          : "Online Payment",
                      "Date": DateTime.now(),
                      "status":"pending",
                    });
                    if(isCOD && Name.isNotEmpty && Email.isNotEmpty &&  PhoneNo.isNotEmpty && Address.isNotEmpty ){
                      Uihelper.custom_colored_box(
                          context, "✨Successfully Submitted");
                    }else if(!isCOD || Name.isEmpty || Email.isEmpty || PhoneNo.isEmpty || Address.isEmpty ){
                      Uihelper.custom_colored_box(
                          context, "✨Please Fill All Required Fields");
                    }
                    else{
                      Uihelper.custom_colored_box(
                          context, "This feature will added soon ");
                    }

                  } on FirebaseException catch (ex) {
                    Uihelper.custom_colored_box(context, " ${ex.code}");
                  }
                }, "Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

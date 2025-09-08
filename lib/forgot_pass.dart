import 'package:ecommerce_app/ui_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  TextEditingController email_cont = TextEditingController();

  forgot_pass(String email) async {
    if (email.isEmpty) {
      return Uihelper.custom_colored_box(context, "All fields are required");
    } else {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        Uihelper.custom_colored_box(context, "Password Reset Email Sent!");
      } on FirebaseAuthException catch (ex) {
        return Uihelper.custom_colored_box(context, ex.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Forgot Password",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // 👈 Align upward
            children: [
              SizedBox(height: 90), // 👈 Adjust this value to move heading
              Text(
                "Forgot Password",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(height: 100),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Uihelper.Costom_text_feild(
                    email_cont, "Email", Icons.email, false),
              ),
              SizedBox(height: 40),
              Uihelper.custome_button(() {
                forgot_pass(email_cont.text.toString());
              }, "Get Email"),
            ],
          ),
        ),
      ),
    );
  }
}

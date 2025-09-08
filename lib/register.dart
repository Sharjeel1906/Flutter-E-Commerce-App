import 'package:ecommerce_app/login.dart';
import 'package:ecommerce_app/ui_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController email_cont  =TextEditingController();
  TextEditingController pass_cont  = TextEditingController();
  TextEditingController name_cont = TextEditingController();
  register(String email,String Password)async{
    if(email.isEmpty | Password.isEmpty){
      return Uihelper.custom_colored_box(context, "All fields are required");
    }else{
      try{
        UserCredential? userCredential;
        userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: Password);
        Uihelper.custom_colored_box(context, "✨Registered Successfully");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
      }on FirebaseAuthException catch(ex){
        return Uihelper.custom_colored_box(context, ex.code.toString());
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Sign Up",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Sign Up",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                SizedBox(height: 30,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child:Uihelper.Costom_text_feild(name_cont, "Name",Icons.abc, false) ,
                ),
                SizedBox(height: 30,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child:Uihelper.Costom_text_feild(email_cont, "Email",Icons.email, false) ,
                ),
                SizedBox(height: 30,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Uihelper.Costom_text_feild(pass_cont, "Password", Icons.lock, true),
                ),
                SizedBox(height: 30,),
                Uihelper.custome_button((){
                  register(email_cont.text.toString(), pass_cont.text.toString());
                }, "Sign Up"),
                SizedBox(height: 20,),
                TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));}, child:const Text("Already have an account? Sign In",style: TextStyle(fontSize: 18,color: Colors.blue),),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

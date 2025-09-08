import 'package:ecommerce_app/forgot_pass.dart';
import 'package:ecommerce_app/main.dart';
import 'package:ecommerce_app/register.dart';
import 'package:ecommerce_app/ui_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email_cont  =TextEditingController();
  TextEditingController pass_cont  = TextEditingController();
  login(String email,String Password)async{
    if(email.isEmpty || Password.isEmpty){
      return Uihelper.custom_colored_box(context, "All Fields are required");
    }else{
      UserCredential? userCredential;
      try{
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: Password);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage(title: "Home")));
      }on FirebaseAuthException catch(ex){
         return Uihelper.custom_colored_box(context, ex.code.toString());
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Sign In",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
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
                      Text("Login",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
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
                      Uihelper.custome_button((){login(email_cont.text.toString(), pass_cont.text.toString());}, "Login"),
                      SizedBox(height: 20,),
                      TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()));}, child:const Text("Don’t have an account? Sign Up",style: TextStyle(fontSize: 18,color: Colors.blue),),),
                      SizedBox(height: 10,),
                      TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPass()));}, child:const Text("Forgot Password",style: TextStyle(fontSize: 18,color: Colors.blue),),)
                    ],
                              ),
                ),
              ),
        ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sign_up_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signInUser(context) async {
    try
    {await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );}
        on FirebaseAuthException catch(e)
    {
      showDialog(context: context, builder:(context) =>
      AlertDialog(
        title: Text(e.code),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
              decoration:BoxDecoration(
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 100),
                    child: Image.asset('./lib/components/Images/ToDo_logo.png',
                    width: 200,),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
                    child: TextField(
                      decoration: InputDecoration(
                         enabledBorder: OutlineInputBorder(
                           borderSide: BorderSide(color: Colors.grey),
                         ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        hintText: 'Email'
                      ),
                      controller: emailController,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
                    child: TextField(
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          hintText: 'Password'
                      ),
                      controller: passwordController,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(width: 250,),
                      Text('Forgot Password?',
                      style: TextStyle(
                        // decoration: TextDecoration.underline,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold
                      ),),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: ElevatedButton(onPressed: (){
                      signInUser(context);
                    },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(120, 40)
                        ),
                        child: Text('Login')
                    ),
                  ),
                  SizedBox(height: 40,),
                  Text('Not a member yet?'),
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUp()));
                    },
                    child: Text('Sign Up',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),),
                  )
                ],
              )
            ),
        ),
      ),
    );
  }
}

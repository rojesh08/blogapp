import 'package:blogapp/components/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  String email = "", password = "";

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text('Create Account', style: TextStyle(color: Colors.white))
      ),
      body:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              const Text('Register', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Form(
                key:_formkey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder()
                      ),
                      onChanged: (String value){
                        email = value;
                      },
                      validator:(value){
                        return value!.isEmpty ? 'Enter Email' : null;
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: true,
                        decoration: const InputDecoration(
                            hintText: 'Password',
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder()
                        ),
                        onChanged: (String value){
                          password = value;
                        },
                        validator:(value){
                          return value!.isEmpty ? 'Enter Password' : null;
                        },
                      ),
                    ),

                    RoundButton(title: 'SignUp', onPress: ()async{
                      if(_formkey.currentState!.validate()){
                        try{
                          
                        final user = await _auth.createUserWithEmailAndPassword(email: email.toString().trim(),
                            password: password.toString().trim());

                        if (user!= null){
                          print('Success');
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Registration Successful'),
                                duration: Duration(seconds: 4),
                                backgroundColor: Colors.deepOrange,
                              )
                          );

                        }

                        }catch(e){
                          print(e.toString());
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Registration failed: $e'),
                              duration: Duration(seconds: 4),
                              backgroundColor: Colors.deepOrange,
                            ),
                          );
                        }

                      }

                    })



                  ],
                )
              ),
            )

          ],
        ),
      )
    );


  }
}

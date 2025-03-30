// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:login_ui/main.dart';
import 'package:login_ui/pages/forgot_password/forgot_password_Screen.dart';
import 'package:login_ui/pages/sign_up/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? phoneNumber;
  String? password;
  bool? remember = false;
  bool isHoveringForgotPassword = false;
  bool isHoveringTerms = false; // New variable for "Terms & Service" hover effect

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Login to your account",
                      style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: <Widget>[
                      inputFields(),
                      SizedBox(height: 10),
                      Row(children: [
                        Checkbox(
                          value: remember,
                          activeColor: Colors.blue,
                          onChanged: (value) {
                            setState(() {
                              remember = value;
                            });
                          },
                        ),
                        Text("Remember me"),
                        Spacer(),
                        MouseRegion(
                          onEnter: (_) => setState(() => isHoveringForgotPassword = true),
                          onExit: (_) => setState(() => isHoveringForgotPassword = false),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen(),
                              ),
                            ),
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isHoveringForgotPassword ? Colors.black : Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () {
                        final isValidForm = _formKey.currentState!.validate();
                        if (isValidForm) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      color: Colors.blue,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Don't have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupScreen()));
                        },
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                            fontSize: 15,
                          ),
                        )),
                  ],
                ),
                Column(
                  children: [
                    MouseRegion(
                      onEnter: (_) => setState(() => isHoveringTerms = true),
                      onExit: (_) => setState(() => isHoveringTerms = false),
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to your terms and service page
                          // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => TermsScreen()));
                        },
                        child: Text(
                          "Terms & Service",
                          style: TextStyle(
                            color: isHoveringTerms ? Colors.black : Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "© 2025 YourCompany. All rights reserved.",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget inputFields() {
    return Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(children: [
          //phone field
          TextFormField(
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: "Phone Number",
              border: OutlineInputBorder(),
            ),
            onSaved: (newValue) => phoneNumber = newValue,
            validator: (String? value) {
              final phoneNo = RegExp(r'^0(9)\d{8}$');
              if (value!.isEmpty) {
                return "Please Enter a valid number (ex. 0920 10 10 10)";
              } else if (phoneNo.hasMatch(value) == false) {
                return "";
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          //password field
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(),
            ),
            onSaved: (newValue) => password = newValue,
            validator: (value) {
              if (value!.isEmpty) {
                return "Please Enter your password";
              } else if (value.length < 8) {
                return "Password is too short";
              }
              return null;
            },
          ),
        ]));
  }
}

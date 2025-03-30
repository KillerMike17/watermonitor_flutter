import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_ui/constants.dart';

import '../login/login_screen.dart';

class ResetPasswordScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String? password;
  String? confirm_password;
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
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    "Reset Password",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Enter your new Password",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700], fontSize: 15),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            // icon: Icon(Icons.lock),
                            labelText: "New Password",
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (newValue) => password = newValue,
                          validator: (value) {
                            if (value != null) {
                              return "Please Enter your  password";
                            } else if (value != null && value.length < 8) {
                              return "Password is too short";
                            }
                            return null;
                          },
                          // return null;
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //confirm password field
                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            // icon: Icon(Icons.lock),
                            labelText: "Confirm Password ",
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (newValue) => confirm_password = newValue,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter your password";
                            } else if (password != value) {
                              return "Passwords don't match";
                            }
                            return null;
                          },
                        ),
                      ],
                    )),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    final isValidForm = _formKey.currentState!.validate();
                    if (isValidForm) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    }
                  },
                  color: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: const Text(
                    "Reset Password",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}

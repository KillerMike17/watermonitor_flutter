// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:login_ui/constants.dart';

import '../login/login_screen.dart';
import '../otp/otp_screen.dart';

class SignupScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String? firstName;
  String? email;
  String? password;
  String? confirm_password;
  bool remember = false;
  bool fromSignup = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Create an account, It's free ",
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  inputFields(),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              Container(
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
                          builder: (context) => otpScreen(
                              email: email.toString(),
                              fromSignup: fromSignup),
                        ),
                        (route) => false,
                      );
                    }
                  },
                  color: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Text(
                      " Login",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget inputFields() {
    return Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(children: [
          //name field
          TextFormField(
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              // icon: Icon(Icons.person),
              labelText: "Name",
              border: OutlineInputBorder(),
            ),
            onSaved: (newValue) => firstName = newValue,
            validator: (value) {
              if (value != null && value.length < 4) {
                return "Please Enter your name";
              } else {
                return null;
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          //phone field
          TextFormField(
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              // icon: Icon(Icons.phone_android),
              labelText: "Phone Number",
              border: OutlineInputBorder(),
            ),
            onSaved: (newValue) => email = newValue,
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
          SizedBox(
            height: 20,
          ),
          //password field
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              // icon: Icon(Icons.lock),
              labelText: "Password",
              border: OutlineInputBorder(),
            ),
            onChanged: (newValue) => password = newValue,
            validator: (value) {
              if (value!.isEmpty) {
                return "Please Enter your password";
              } else if (value.length < 6) {
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
        ]));
  }
}


// Widget inputName() {
//   return Form(
//       key: _formKey,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       child: TextFormField(
//         keyboardType: TextInputType.name,
//         decoration: const InputDecoration(
//           icon: Icon(Icons.person),
//           labelText: "Name",
//           border: OutlineInputBorder(),
//           // hintText: "Enter Your Name",
//         ),
//         onSaved: (newValue) => firstName = newValue,
//         validator: (value) {
//           if (value != null && value.length < 4) {
//             return "Enter Min 7 chars";
//           } else {
//             return null;
//           }
//         },
//       ));
// }

// Widget inputPhone() {
//   return Form(
//       key: _formKey,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       child: TextFormField(
//         keyboardType: TextInputType.phone,
//         decoration: const InputDecoration(
//           icon: Icon(Icons.phone_android),
//           labelText: "Phone Number",
//           border: OutlineInputBorder(),
//           // hintText: "Enter Your Phone Number",
//         ),
//         onSaved: (newValue) => email = newValue,
//         validator: (String? value) {
//           final phoneNo = RegExp(r'^0(9)\d{8}$');
//           if (value!.isEmpty) {
//             // addError(error: kPhoneNumberNullError);
//             return "";
//           } else if (phoneNo.hasMatch(value) == false) {
//             // addError(error: kPhoneNumberFormError);
//             return "";
//           }
//           return null;
//         },
//       ));
// }

// Widget inputPassword() {
//   return Form(
//       key: _formKey,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       child: TextFormField(
//         obscureText: true,
//         decoration: const InputDecoration(
//           icon: Icon(Icons.lock),
//           labelText: "Password",
//           border: OutlineInputBorder(),
//           // hintText: "Enter Your Password",
//         ),
//         onSaved: (newValue) => password = newValue,
//         validator: (value) {
//           if (value != null && value.length < 8) {
//             // addError(error: kPassNullError);
//             return "Password should be a min of 8 chars";
//           } else {
//             return null;
//           }
//         },
//       ));
// }

// Widget inputConfirmPassword() {
//   return Form(
//       key: _formKey,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       child: TextFormField(
//         obscureText: true,
//         decoration: const InputDecoration(
//           icon: Icon(Icons.lock),
//           labelText: "Confirm Password ",
//           border: OutlineInputBorder(),
//           // hintText: "Enter Your Password",
//         ),
//         onSaved: (newValue) => confirm_password = newValue,
//         validator: (value) {
//           if (value!.isEmpty) {
//             // addError(error: kPassNullError);
//             return "";
//           } else if (password != value) {
//             // addError(error: kShortPassError);
//             return "";
//           }
//           return null;
//         },
//       ));
// }

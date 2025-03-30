// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_ui/pages/forgot_password/reset_password.dart';
import 'package:login_ui/pages/login/login_screen.dart';

import '../../constants.dart'; 

class otpScreen extends StatelessWidget {
  final bool fromSignup;
  final String phoneNumber;
  const otpScreen(
      {Key? Key, required this.phoneNumber, required this.fromSignup})
      : super(key: Key);

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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    "Phone Verification",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.indigo),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Verification code has been sent to ${phoneNumber}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700], fontSize: 15),
                  ),
                ],
              ),
              Form(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 68,
                    width: 64,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      onSaved: (pin1) {},
                      style: Theme.of(context).textTheme.headlineMedium,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 68,
                    width: 64,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      onSaved: (pin2) {},
                      style: Theme.of(context).textTheme.displaySmall,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 68,
                    width: 64,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      onSaved: (pin3) {},
                      style: Theme.of(context).textTheme.displaySmall,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 68,
                    width: 64,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      onSaved: (pin4) {},
                      style: Theme.of(context).textTheme.displaySmall,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                ],
              )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width / 2,
                  height: 60,
                  onPressed: () {
                    if (fromSignup == true) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResetPasswordScreen()));
                    }
                  },
                  color: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    "Verify",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    "Did you recieve any code?",
                    style: TextStyle(color: Colors.grey[700], fontSize: 15),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        "Resend New Code",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              )
            ],
          ),
        ));
  }
}

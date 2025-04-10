import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:login_ui/main.dart';
import 'package:login_ui/pages/forgot_password/forgot_password_Screen.dart';
import 'package:login_ui/pages/sign_up/sign_up_screen.dart';
import 'package:login_ui/providers/auth_provider.dart';
import 'package:login_ui/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  String? email;
  String? password;
  bool? remember = false;
  bool isHoveringForgotPassword = false;
  bool isHoveringTerms = false;
  bool isLoading = false;

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
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[700]),
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
                              onEnter: (_) => setState(
                                  () => isHoveringForgotPassword = true),
                              onExit: (_) => setState(
                                  () => isHoveringForgotPassword = false),
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordScreen(),
                                  ),
                                ),
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isHoveringForgotPassword
                                        ? Colors.black
                                        : Colors.blue,
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
                          onPressed: isLoading ? null : _handleLogin,
                          color: Colors.blue,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
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
                          onEnter: (_) =>
                              setState(() => isHoveringTerms = true),
                          onExit: (_) =>
                              setState(() => isHoveringTerms = false),
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to terms and service page
                            },
                            child: Text(
                              "Terms & Service",
                              style: TextStyle(
                                color: isHoveringTerms
                                    ? Colors.black
                                    : Colors.blue,
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
                  ]),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Save form data
    _formKey.currentState!.save();

    setState(() => isLoading = true);

    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Call API
      final response = await _apiService.login(email!, password!);

      // Close loading dialog
      Navigator.of(context).pop();

      print(response.statusCode);

      // Handle successful login
      if (response.statusCode == 201) {
      // Get SharedPreferences instance
      final prefs = await SharedPreferences.getInstance();
      
      // Save authentication token
      if (response.data['authtoken']?['accessToken'] != null) {
        await prefs.setString('accessToken', response.data['authtoken']['accessToken']);
      }
      
      // Save user data
      if (response.data['user'] != null) {
        await prefs.setString('user', json.encode(response.data['user']));
      }
      
      // Save login state
      await prefs.setBool('isLoggedIn', true);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
          ),
        );

        // await Provider.of<AuthProvider>(context, listen: false).login(
        //   response.data['accessToken.authToken'],
        //   email!,
        // );

        // Navigate to home and clear all previous routes
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false,
        );
      } else {
        // Handle API errors (non-200 responses)
        final errorMessage = response.data['message'] ?? 'Login failed';
        throw Exception(errorMessage);
      }
    } on DioException catch (e) {
      // Close loading dialog if still open
      Navigator.of(context).pop();

      // Handle Dio-specific errors
      final errorMessage = ApiService.handleError(e);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      // Close loading dialog if still open
      Navigator.of(context).pop();

      // Handle generic errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget inputFields() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(children: [
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: "Email",
            border: OutlineInputBorder(),
          ),
          onSaved: (newValue) => email = newValue,
          validator: (String? value) {
            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
            if (value!.isEmpty) {
              return "Please Enter your email";
            } else if (!emailRegex.hasMatch(value)) {
              return "Please Enter a valid email";
            }
            return null;
          },
        ),
        SizedBox(height: 20),
        TextFormField(
          obscureText: true,
          decoration: const InputDecoration(
            labelText: "Password",
            border: OutlineInputBorder(),
            // suffixIcon: IconButton(
            //   icon: Icon(
            //     _obscurePassword ? Icons.visibility : Icons.visibility_off,
            //   ),
            //   onPressed: () {
            //     setState(() {
            //       _obscurePassword = !_obscurePassword;
            //     });
            //   },
            // ),
          ),
          onSaved: (newValue) => password = newValue,
          validator: (value) {
            if (value!.isEmpty) {
              return "Please Enter your password";
            } else if (value.length < 6) {
              return "Password is too short";
            }
            return null;
          },
        ),
      ]),
    );
  }
}

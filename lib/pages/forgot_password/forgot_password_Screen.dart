import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants.dart';
import '../otp/otp_screen.dart';
import '../../services/api_service.dart'; // Import your API service

class ForgotPasswordScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService(); // Create an instance of your API service
  String? email;
  bool fromSignup = false;
  bool isLoading = false; // Add loading state
  
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
          children: [
            Column(
              children: [
                const Text(
                  "Forgot Your Password?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Enter your email to reset your password",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700], fontSize: 15),
                ),
                const SizedBox(height: 20),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (newValue) => email = newValue,
                  validator: (String? value) {
                    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (value!.isEmpty) {
                      return "Please Enter Your Email";
                    } else if (!emailRegex.hasMatch(value)) {
                      return "Please Enter a valid email (ex. example@domain.com)";
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: MaterialButton(
                minWidth: double.infinity,
                height: 60,
                onPressed: isLoading ? null : () async { // Disable button when loading
                  final isValidForm = _formKey.currentState!.validate();
                  if (isValidForm) {
                    _formKey.currentState!.save();
                    
                    try {
                      // Set loading to true
                      isLoading = true;
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sending request...')),
                        );
                      }
                      
                      // Call the API
                      final response = await apiService.forgotPassword(
                        email: email!,
                      );
                      
                      // Handle successful response
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Password reset email sent!')),
                        );
                        
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => OtpScreen(
                              email: email.toString(),
                              fromSignup: fromSignup,
                            ),
                          ),
                          (route) => false,
                        );
                      }
                    } catch (e) {
                      // Handle error
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      }
                    } finally {
                      // Set loading to false when done
                      isLoading = false;
                    }
                  }
                },
                color: primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Send",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
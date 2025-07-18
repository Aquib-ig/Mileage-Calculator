import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:mileage_calculator/providers/auth_provider.dart';
import 'package:mileage_calculator/screens/app/home_screen.dart';
import 'package:mileage_calculator/widgets/app_button.dart';
import 'package:mileage_calculator/widgets/app_text_form_field.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = true;
  bool _isConfirmPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth = constraints.maxWidth > 600
                ? 500
                : double.infinity;

            return SingleChildScrollView(
              child: Center(
                child: Container(
                  width: maxWidth,
                  padding: const EdgeInsets.all(18.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Hello! Register to get started",
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 40),
                        Row(
                          children: [
                            Expanded(
                              child: AppTextFormField(
                                controller: _firstNameController,
                                hintText: "First name",
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "First name cannot be empty";
                                  }
                                  return null;
                                },
                                obscureText: false,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: AppTextFormField(
                                controller: _lastNameController,
                                hintText: "Last name",
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Last name cannot be empty";
                                  }
                                  return null;
                                },
                                obscureText: false,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        AppTextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          hintText: "Email",
                          prefixIcon: Icon(Icons.email_outlined),
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email cannot be empty";
                            } else if (!RegExp(
                              r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                            ).hasMatch(value)) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        AppTextFormField(
                          controller: _passwordController,
                          hintText: "Password",
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          obscureText: _isPasswordVisible,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        AppTextFormField(
                          controller: _confirmPasswordController,
                          hintText: "Confirm password",
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                          obscureText: _isConfirmPasswordVisible,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Confirm Password cannot be empty";
                            } else if (value != _passwordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              log("forgot button tapped!");
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Color(0xffee3a57),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 30),
                        AppButton(
                          onTap: authProvider.isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      await authProvider.signUp(
                                        _emailController.text.trim(),
                                        _passwordController.text.trim(),
                                        _firstNameController.text.trim(),
                                        _lastNameController.text.trim(),
                                      );
                                      log("Signup Successful!!");

                                      _emailController.clear();
                                      _passwordController.clear();
                                      _confirmPasswordController.clear();
                                      _firstNameController.clear();
                                      _lastNameController.clear();

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomeScreen(),
                                        ),
                                      );
                                    } catch (e) {
                                      log("Signup failed: $e");
                                    }
                                  }
                                },
                          child: authProvider.isLoading
                              ? SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,  
                                    color: Colors.white,
                                  ),
                                )
                              : Center(
                                  child: const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                        SizedBox(height: 30),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Or Sign in with",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(height: 10),
                        SignInButton(Buttons.GoogleDark, onPressed: () {}),

                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(fontSize: 16),
                            ),
                            GestureDetector(
                              onTap: () {
                                log("Sign up tapped");
                              },
                              child: Text(
                                " Sign up",
                                style: TextStyle(
                                  color: Color(0xffee3a57),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

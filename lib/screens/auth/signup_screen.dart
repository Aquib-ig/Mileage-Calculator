import 'dart:developer';

import 'package:flutter/material.dart';
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth > 600 ? 500 : double.infinity;
          double maxHeight = MediaQuery.of(context).size.height;

          return SingleChildScrollView(
            child: Container(
              width: maxWidth,
              height: maxHeight,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const Spacer(), // pushes form towards center
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Create an account",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Register to get you started!",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        Row(
                          children: [
                            Expanded(
                              child: AppTextFormField(
                                controller: _firstNameController,
                                hintText: "First name",
                                lableText: "First Name",
                                keyboardType: TextInputType.text,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? "First name cannot be empty"
                                    : null,
                                obscureText: false,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: AppTextFormField(
                                controller: _lastNameController,
                                hintText: "Last name",
                                lableText: "Last Name",
                                keyboardType: TextInputType.text,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? "Last name cannot be empty"
                                    : null,
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
                          lableText: "Email",
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
                          hintText: "Enter your password",
                          lableText: "Password",
                          prefixIcon: Icon(Icons.lock_outline),

                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
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
                          hintText: "Enter Confirm password",
                          lableText: "Confirm Password",
                          prefixIcon: Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
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
                        const SizedBox(height: 12),

                        const SizedBox(height: 20),

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

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => HomeScreen(),
                                        ),
                                      );
                                    } catch (e) {
                                      log("Signup failed: $e");
                                    }
                                  }
                                },
                          child: authProvider.isLoading
                              ? const SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Text(
                                "or",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: CircleAvatar(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.surface,
                                radius: 20,
                                child: Image.asset(
                                  height: 20,
                                  "assets/images/google_logo.png",
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {},
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.surface,
                                child: Image.asset(
                                  height: 24,
                                  "assets/images/facebook_logo.png",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

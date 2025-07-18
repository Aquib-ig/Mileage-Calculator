import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:mileage_calculator/providers/auth_provider.dart';
import 'package:mileage_calculator/screens/app/home_screen.dart';
import 'package:mileage_calculator/screens/auth/signup_screen.dart';
import 'package:mileage_calculator/widgets/app_button.dart';
import 'package:mileage_calculator/widgets/app_text_form_field.dart';
import 'package:provider/provider.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController _emailController = TextEditingController(
    text: "aquibak011@gmail.com",
  );
  final TextEditingController _passwordController = TextEditingController(
    text: "aquibak011",
  );
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "Welcome back! Glad to see you. Again!",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 50),
                      AppTextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        hintText: "Email",
                        prefixIcon: const Icon(Icons.email_outlined),
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
                      const SizedBox(height: 20),
                      AppTextFormField(
                        controller: _passwordController,
                        hintText: "Password",
                        prefixIcon: const Icon(Icons.lock_outline),
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
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            log("forgot button tapped!");
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      AppButton(
                        onTap: authProvider.isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    await authProvider.signIn(
                                      _emailController.text.trim(),
                                      _passwordController.text.trim(),
                                    );
                                    log("Login Successfull!!");
                                    _emailController.clear();
                                    _passwordController.clear();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const HomeScreen(),
                                      ),
                                    );
                                  } catch (e) {
                                    log("Login failed: $e");
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
                            : const Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    const Text(
                      "Or Sign in with",
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    SignInButton(Buttons.GoogleDark, onPressed: () {}),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            log("Sign up tapped");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(),
                              ),
                            );
                          },
                          child: const Text(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

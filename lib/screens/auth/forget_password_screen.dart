import 'package:flutter/material.dart';
import 'package:mileage_calculator/providers/auth_provider.dart';
import 'package:mileage_calculator/utils/show_app_snackbar.dart';
import 'package:mileage_calculator/widgets/app_button.dart';
import 'package:mileage_calculator/widgets/app_text_form_field.dart';
import 'package:provider/provider.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Forgot Password",
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 32),

                /// Email Text Field
                AppTextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: "Enter your email",
                  lableText: "Email",
                  prefixIcon: Icon(Icons.email_outlined),
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email cannot be empty";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                /// Submit Button
                AppButton(
                  child: Text(
                    "Submit",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        ).forgotPassword(_emailController.text.trim());

                        showAppSnackBar(
                          context,
                          message:
                              "Password reset link sent!, Please check your email",
                          backgroundColor: Colors.green,
                        );

                        _emailController.clear();
                        Navigator.pop(context);
                      } catch (e) {
                        showAppSnackBar(
                          context,
                          message: "Failed to reset the link ${e.toString()}",
                          backgroundColor: Colors.red,
                        );
                      }
                    }
                  },
                ),

                SizedBox(height: 16),

                GestureDetector(
                  onTap: () {
                    _emailController.clear();
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Back to Login",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

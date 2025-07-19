import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mileage_calculator/models/mileage_model.dart';
import 'package:mileage_calculator/widgets/app_button.dart';
import 'package:mileage_calculator/widgets/app_text_form_field.dart';

class MileageCounterScreen extends StatefulWidget {
  const MileageCounterScreen({super.key});

  @override
  State<MileageCounterScreen> createState() => _MileageCounterScreenState();
}

class _MileageCounterScreenState extends State<MileageCounterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _fuelController = TextEditingController();

  String _selectedVehicle = "Car";
  double? _calculatedMileage;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mileage Calculator")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedVehicle,
                items: ["Car", "Bike", "Bus"]
                    .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedVehicle = val!),
                decoration: const InputDecoration(
                  labelText: "Vehicle Type",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                controller: _distanceController,
                hintText: "Enter distance in km",
                lableText: "Distance (km)",
                keyboardType: TextInputType.number,
                obscureText: false,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Enter distance";
                  if (double.tryParse(v) == null || double.parse(v) <= 0) {
                    return "Invalid distance";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                controller: _fuelController,
                hintText: "Enter fuel used in litres",
                lableText: "Fuel Used (litres)",
                keyboardType: TextInputType.number,
                obscureText: false,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Enter fuel used";
                  if (double.tryParse(v) == null || double.parse(v) <= 0) {
                    return "Invalid fuel amount";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              AppButton(
                onTap: _isLoading
                    ? null
                    : () async {
                        if (!(_formKey.currentState?.validate() ?? false))
                          return;

                        setState(() {
                          _isLoading = true;
                        });

                        double distance = double.parse(
                          _distanceController.text.trim(),
                        );
                        double fuel = double.parse(_fuelController.text.trim());
                        double mileage = distance / fuel;

                        MileageModel record = MileageModel(
                          vehicleType: _selectedVehicle,
                          distance: distance,
                          fuelUsed: fuel,
                          mileage: mileage,
                        );

                        User? user = FirebaseAuth.instance.currentUser;
                        if (user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("User not logged in!"),
                            ),
                          );
                          setState(() => _isLoading = false);
                          return;
                        }

                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .collection('mileage_records')
                            .add({
                              ...record.toMap(),
                              'createdAt': FieldValue.serverTimestamp(),
                            });

                        setState(() {
                          _calculatedMileage = mileage;
                          _isLoading = false;
                        });
                      },
                child: _isLoading
                    ? const SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Calculate",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              if (_calculatedMileage != null) ...[
                const SizedBox(height: 30),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  color: Colors.blue.shade400,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "Your Mileage",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${_calculatedMileage!.toStringAsFixed(2)} km/litre",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

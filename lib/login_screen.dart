import 'package:flutter/material.dart';

import 'patient_form_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emdController = TextEditingController();
  final List<String> emdCodes = [
    "A12345",
    "B54321",
    "C67890",
    "D09876",
    "E24680",
    "A13579",
    "B11223",
    "C33211",
    "D55667",
    "E77665",
    "A88990",
    "B99088",
    "C22334",
    "D66778",
    "E44556",
    "A99887",
    "B77664",
    "C66555",
    "D11122",
    "E33344",
  ];

  void validateemd() {
    if (emdCodes.contains(_emdController.text.trim())) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PatientFormScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invalid emd Code! Try again.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("EMD Code Login")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emdController,
                decoration: InputDecoration(labelText: "Enter EMD Code"),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: validateemd, child: Text("Submit")),
            ],
          ),
        ),
      ),
    );
  }
}

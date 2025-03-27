import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'hospital_suggestion_screen.dart';

class PatientFormScreen extends StatefulWidget {
  @override
  _PatientFormScreenState createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends State<PatientFormScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String gender = "Male";
  String bloodGroup = "O+";
  final TextEditingController bpController = TextEditingController();
  final TextEditingController sugarController = TextEditingController();
  final TextEditingController issueController = TextEditingController();

  Future<void> saveData() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> patientData = {
        "name": nameController.text,
        "age": int.tryParse(ageController.text) ?? 0,
        "gender": gender,
        "bloodGroup": bloodGroup,
        "bloodPressure": bpController.text,
        "bloodSugar": sugarController.text,
        "medicalIssue": issueController.text,
        "timestamp": FieldValue.serverTimestamp(),
      };

      try {
        await _firestore.collection('patients').add(patientData);
        print("Patient data saved to Firestore.");

        // Navigate to the Hospital Suggestion screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    HospitalSuggestionScreen(issue: issueController.text),
          ),
        );
      } catch (e) {
        print("Error saving data to Firestore: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to save patient data. Please try again."),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Patient Form")),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Patient Name"),
                  validator:
                      (value) =>
                          value!.isEmpty ? "Please enter patient name" : null,
                ),
                TextFormField(
                  controller: ageController,
                  decoration: InputDecoration(labelText: "Age"),
                  keyboardType: TextInputType.number,
                  validator:
                      (value) => value!.isEmpty ? "Please enter age" : null,
                ),
                DropdownButtonFormField<String>(
                  value: gender,
                  items:
                      ["Male", "Female", "Other"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (value) => setState(() => gender = value!),
                  decoration: InputDecoration(labelText: "Gender"),
                ),
                DropdownButtonFormField<String>(
                  value: bloodGroup,
                  items:
                      ["O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-"]
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (value) => setState(() => bloodGroup = value!),
                  decoration: InputDecoration(labelText: "Blood Group"),
                ),
                TextFormField(
                  controller: bpController,
                  decoration: InputDecoration(labelText: "Blood Pressure"),
                  validator:
                      (value) =>
                          value!.isEmpty ? "Please enter blood pressure" : null,
                ),
                TextFormField(
                  controller: sugarController,
                  decoration: InputDecoration(labelText: "Blood Sugar Level"),
                  validator:
                      (value) =>
                          value!.isEmpty
                              ? "Please enter blood sugar level"
                              : null,
                ),
                TextFormField(
                  controller: issueController,
                  decoration: InputDecoration(labelText: "Medical Issue"),
                  validator:
                      (value) =>
                          value!.isEmpty ? "Please enter medical issue" : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(onPressed: saveData, child: Text("Submit")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

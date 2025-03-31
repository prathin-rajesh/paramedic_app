import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class ConfirmRouteScreen extends StatefulWidget {
  @override
  _ConfirmRouteScreenState createState() => _ConfirmRouteScreenState();
}

class _ConfirmRouteScreenState extends State<ConfirmRouteScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _currentLanguage = 'en'; // Default language
  Map<String, String> _localizedStrings = {}; // Stores translations

  @override
  void initState() {
    super.initState();
    _loadTranslations();
  }

  Future<void> _loadTranslations() async {
    try {
      String jsonString = await rootBundle.loadString(
        'assets/lang/$_currentLanguage.json',
      );
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      setState(() {
        _localizedStrings = jsonMap.map(
          (key, value) => MapEntry(key, value.toString()),
        );
      });
    } catch (e) {
      print("Error loading language file: $e");
    }
  }

  Future<DocumentSnapshot?> getLatestPatient() async {
    var querySnapshot =
        await _firestore
            .collection('patients')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();
    return querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first : null;
  }

  void _changeLanguage(String languageCode) {
    setState(() {
      _currentLanguage = languageCode;
      _loadTranslations(); // Reload translations for the selected language
    });
  }

  String _translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_translate("confirm_route"))),
      body: FutureBuilder<DocumentSnapshot?>(
        future: getLatestPatient(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text(_translate("no_patient_data")));
          }

          var patientData = snapshot.data!.data() as Map<String, dynamic>?;

          if (patientData == null) {
            return Center(child: Text(_translate("no_patient_data")));
          }

          return SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text(
                    _translate("confirm_route"),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),

                  // Language Selection Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _languageButton("English", "en"),
                      SizedBox(width: 10),
                      _languageButton("தமிழ்", "ta"),
                      SizedBox(width: 10),
                      _languageButton("മലയാളം", "ml"),
                    ],
                  ),

                  SizedBox(height: 20),
                  Card(
                    margin: EdgeInsets.all(16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _translate("patient_details"),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Divider(),
                          Text(
                            "${_translate("name")}: ${patientData['name'] ?? 'N/A'}",
                          ),
                          Text(
                            "${_translate("age")}: ${patientData['age'] ?? 'N/A'}",
                          ),
                          Text(
                            "${_translate("gender")}: ${patientData['gender'] ?? 'N/A'}",
                          ),
                          Text(
                            "${_translate("blood_group")}: ${patientData['bloodGroup'] ?? 'N/A'}",
                          ),
                          Text(
                            "${_translate("blood_pressure")}: ${patientData['bloodPressure'] ?? 'N/A'}",
                          ),
                          Text(
                            "${_translate("blood_sugar")}: ${patientData['bloodSugar'] ?? 'N/A'}",
                          ),
                          Text(
                            "${_translate("medical_issue")}: ${patientData['medicalIssue'] ?? 'N/A'}",
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _showConfirmationDialog(context);
                        },
                        child: Text(_translate("confirm")),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(_translate("cancel")),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _languageButton(String label, String languageCode) {
    bool isSelected = _currentLanguage == languageCode;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : null,
        foregroundColor: isSelected ? Colors.white : null,
      ),
      onPressed: () => _changeLanguage(languageCode),
      child: Text(label),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(_translate("confirm")),
          content: Text(_translate("confirmed_message")),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Close the dialog
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

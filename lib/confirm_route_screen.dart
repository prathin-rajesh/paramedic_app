import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConfirmRouteScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot?> getLatestPatient() async {
    var querySnapshot =
        await _firestore
            .collection('patients')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();
    return querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Confirm Ambulance Route")),
      body: FutureBuilder<DocumentSnapshot?>(
        future: getLatestPatient(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("No patient data available."));
          }

          var patientData = snapshot.data!.data() as Map<String, dynamic>?;

          if (patientData == null) {
            return Center(child: Text("Error retrieving patient data."));
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Confirm Ambulance Route?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                          "Patient Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(),
                        Text("Name: ${patientData['name']}"),
                        Text("Age: ${patientData['age']}"),
                        Text("⚥ Gender: ${patientData['gender']}"),
                        Text("🩸 Blood Group: ${patientData['bloodGroup']}"),
                        Text("Blood Pressure: ${patientData['bloodPressure']}"),
                        Text("Blood Sugar: ${patientData['bloodSugar']}"),
                        Text(
                          "🩺 Medical Issue: ${patientData['medicalIssue']}",
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
                      child: Text("Yes"),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("No"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmed"),
          content: Text("Ambulance Route Confirmed Successfully."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
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

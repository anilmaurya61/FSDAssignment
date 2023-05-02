import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/Provider_ragistration.dart';

class SubmittedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registrationFormProvider =
        Provider.of<RegistrationFormProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Submitted'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: FutureBuilder(
        future: registrationFormProvider.fetchFormData(
          registrationFormProvider.formData.email as String,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          }
          final formData = registrationFormProvider.formData;
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Name:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '${formData.firstName} ${formData.lastName}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey[700],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Date of Birth:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '${formData.dateOfBirth}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey[700],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Email:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '${formData.email}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey[700],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Phone Number:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '${formData.phoneNumber}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey[700],
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: PDFView(
                    filePath: formData.cvUrl,
                    onError: (error) {
                      print(error.toString());
                    },
                    onPageError: (page, error) {
                      print('$page: ${error.toString()}');
                    },
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final url = Uri.parse(formData.cvUrl!);
                        await launch(url.toString());
                      } catch (e) {
                        print('Error launching URL: $e');
                      }
                    },
                    child: Text('View CV'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueGrey[800],
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

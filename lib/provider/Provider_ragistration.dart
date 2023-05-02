import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import '../modal/modal_ragistration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationFormProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  late RegistrationFormData _formData;

  RegistrationFormData get formData => _formData;

  Future<void> submitFormData(
    String firstName,
    String lastName,
    DateTime dateOfBirth,
    String email,
    String phoneNumber,
    String cvFilePath,
  ) async {
    // Upload CV file to Firebase Storage
    final cvRef = _storage.ref().child('cvs').child('$email.pdf');
    await cvRef.putFile(File(cvFilePath)).whenComplete(() async {
      final cvUrl = await cvRef.getDownloadURL();
      // Save form data to Firebase Firestore
      await _firestore.collection('registrations').doc(email).set({
        'firstName': firstName,
        'lastName': lastName,
        'dateOfBirth': dateOfBirth.toIso8601String(),
        'email': email,
        'phoneNumber': phoneNumber,
        'cvUrl': cvUrl,
      });
      _formData = RegistrationFormData(
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dateOfBirth,
        email: email,
        phoneNumber: phoneNumber,
      );
      notifyListeners();
    }
    );
  }

  Future<void> fetchFormData(String email) async {
    final snapshot =
        await _firestore.collection('registrations').doc(email).get();
    if (snapshot.exists) {
      final data = snapshot.data();
      _formData = RegistrationFormData(
        firstName: data!['firstName'],
        lastName: data['lastName'],
        dateOfBirth: DateTime.parse(data['dateOfBirth']),
        email: data['email'],
        phoneNumber: data['phoneNumber'],
        cvUrl: data['cvUrl'],
      );
      notifyListeners();
    }
  }
}

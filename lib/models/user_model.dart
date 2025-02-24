import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String fullName;
  String email;
  String password;
  String? phoneNumber;
  String? address;

  UserModel({
    required this.fullName,
    required this.email,
    required this.password,
    this.phoneNumber,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      fullName: map['name'],
      email: map['email'],
      password: '',
      phoneNumber: map['phoneNumber'],
    );
  }
  factory UserModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return UserModel(
      fullName: data?['name'],
      email: data?['email'],
      password: '',
      phoneNumber: data?['phoneNumber'],
    );
  }
}

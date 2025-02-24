import 'package:cloud_firestore/cloud_firestore.dart';

class GovernorateModel {
  final String id;
  final String name;
  final String description;
  final String image;

  const GovernorateModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  factory GovernorateModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return GovernorateModel(
      id: data?['id'],
      name: data?['name'],
      description: data?['description'],
      image: data?['image'],
    );
  }
}

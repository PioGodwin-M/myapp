import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/app/core/enums/role.dart';

class AppUser {
  final String uid;
  final String? email;
  final String? displayName;
  final Role role;

  AppUser({
    required this.uid,
    this.email,
    this.displayName,
    required this.role,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      role: Role.values.firstWhere((e) => e.toString() == data['role']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'role': role.toString(),
    };
  }
}

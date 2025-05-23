import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';

class FirestoreDataSource {
  final FirebaseFirestore _firestore;

  FirestoreDataSource(this._firestore);

  Future<void> saveUserData(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set({
      'username': user.username,
      'email': user.email,
      'is_verified': user.isVerified,
      'updated_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<UserModel?> getUserData(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists) return null;
    
    return UserModel.fromJson({
      'id': doc.id,
      ...doc.data()!,
    });
  }
}
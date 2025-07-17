import 'package:cloud_firestore/cloud_firestore.dart';

class CommentService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future<void> addComment (String postId, String userId, String text) async{
    try{
      final commentBatch = _firebaseFirestore.batch();
      final commentRef = _firebaseFirestore.collection('comments').doc();
      commentBatch.set(commentRef, {
        'postId', postId,
        'userId', _firebaseFirestore.collection('user-profiles').doc(userId),
        'text', text,
        'createdAt', Timestamp.now(),
        'updatedAt', Timestamp.now(),
      });
    } catch(error){
      
    }
  }
}

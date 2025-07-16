import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/home/media.dart';

class Comment {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String avatar;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;

  Comment ({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Comment.fromFirestore(DocumentSnapshot firestorePostDoc, DocumentSnapshot firestoreUserProfileDoc){

    Map<String, dynamic> firestorePostData = firestorePostDoc.data() as Map<String, dynamic>;
    Map<String, dynamic> firestoreUserProfileData = firestoreUserProfileDoc.data() as Map<String, dynamic>;

    return Comment(
      id: firestorePostDoc.id,
      userName: firestoreUserProfileData['userName'],
      postId: '',
      userId: '',
      avatar: firestoreUserProfileData['avatar'],
      text: '',
      createdAt: (firestorePostData['createdAt'] as Timestamp).toDate(),
      updatedAt: (firestorePostData['updatedAt'] as Timestamp).toDate(),
    );
  }
}

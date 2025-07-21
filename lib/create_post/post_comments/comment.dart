import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String avatar;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;

  //Constructor:
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

  factory Comment.fromFirestore(
      DocumentSnapshot firestoreCommentDoc,
      DocumentSnapshot firestoreUserProfileDoc){

    Map<String, dynamic> firestoreCommentData = firestoreCommentDoc.data() as Map<String, dynamic>;
    Map<String, dynamic> firestoreUserProfileData = firestoreUserProfileDoc.data() as Map<String, dynamic>;

    return Comment(
      id: firestoreCommentDoc.id,
      userName: firestoreUserProfileData['userName'],
      postId: firestoreCommentData['postId'],
      userId: firestoreUserProfileDoc.id,
      avatar: firestoreUserProfileData['userAvatar'],
      text: firestoreCommentData['text'],
      createdAt: (firestoreCommentData['createdAt'] as Timestamp).toDate(),
      updatedAt: (firestoreCommentData['updatedAt'] as Timestamp).toDate(),
    );
  }
}

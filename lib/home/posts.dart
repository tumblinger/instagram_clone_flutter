import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/home/media.dart';

class Posts {
  final String userName;
  final String avatar;
  final List <Media> media;
  final String caption;
  final int likes;
  final int shares;
  final int comments;
  final DateTime createdAt;
  final DateTime updatedAt;

  Posts ({
    required this.userName,
    required this.avatar,
    required this.media,
    required this.caption,
    required this.likes,
    required this.shares,
    required this.comments,
    required this.createdAt,
    required this.updatedAt,
});

  factory Posts.fromFirestore(DocumentSnapshot firestorePostDoc, DocumentSnapshot firestoreUserProfileDoc){

    Map<String, dynamic> firestorePostData = firestorePostDoc.data() as Map<String, dynamic>;
    Map<String, dynamic> firestoreUserProfileData = firestoreUserProfileDoc.data() as Map<String, dynamic>;

    return Posts(
        userName: firestoreUserProfileData['userName'],
        avatar: firestoreUserProfileData['avatar'],
        media: firestorePostData['media'],
        caption: firestorePostData['caption'],
        likes: firestorePostData['likes'],
        shares: firestorePostData['shares'],
        comments: firestorePostData['comments'],
        createdAt: firestorePostData['createdAt'],
        updatedAt: firestorePostData['updatedAt']
    );
  }
}

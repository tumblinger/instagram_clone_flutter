import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/home/media.dart';

class Posts {
  final String id;
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
    required this.id,
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

    List<Media> media = (firestorePostData['media'] as List)
        .map((media) => Media.fromMap(media as Map<String, dynamic>))
        .toList();

    return Posts(
        id: firestorePostDoc.id,
        userName: firestoreUserProfileData['userName'],
        avatar: firestoreUserProfileData['avatar'],
        media: media,
        caption: firestorePostData['caption'],
        likes: firestorePostData['likes'],
        shares: firestorePostData['shares'],
        comments: firestorePostData['comments'],
        createdAt: (firestorePostData['createdAt'] as Timestamp).toDate(),
        updatedAt: (firestorePostData['updatedAt'] as Timestamp).toDate(),
    );
  }
}

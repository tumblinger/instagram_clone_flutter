import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/create_post/posts.dart';

class PostsService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<List<Posts>> getPosts(){
    return
        _firebaseFirestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots().asyncMap((snapshot) async {
          List<Posts> posts = [];
          for(
            QueryDocumentSnapshot<Map<String, dynamic>> firestorePostDoc in snapshot.docs)
          {
            DocumentReference userProfileRef = firestorePostDoc['createdby'];
            DocumentSnapshot firestoreUserProfileDoc = await userProfileRef.get();
            posts.add(Posts.fromFirestore(firestorePostDoc, firestoreUserProfileDoc));
          }
          return posts;
    });
  }

  Stream<List<Posts>> getPostsByUserId(String userId){
    // final userRef = _firebaseFirestore.collection('user-profiles').doc(userId);
    return
      _firebaseFirestore
          .collection('posts')
          // .orderBy('createdAt', descending: true)
          .snapshots()   
          .asyncMap((snapshot) async {
        List<Posts> posts = [];
        final filteredDocs = snapshot.docs.where((doc){
          final createdby = doc.data()['createdby'];
          if(createdby is DocumentReference){
            return createdby.id == userId;
          } else if (createdby is String){
            return createdby == userId;
          }
          return false;
        }).toList();
        print('Filtered posts count: ${filteredDocs.length}');

        for(var doc in filteredDocs){
          DocumentReference userProfileRef = doc['createdby'];
          DocumentSnapshot userProfileDoc;
          if(userProfileRef is DocumentReference) {
            userProfileDoc = await userProfileRef.get();
          } else {
            userProfileDoc = await _firebaseFirestore.collection('user-profiles').doc(userId).get();
          }
          posts.add(Posts.fromFirestore(doc, userProfileDoc));
        }
        return posts;
      });
  }

  Future <void> updatePost(String postId, Map<String, dynamic> updateData) async{
    try{
      final dataToUpdate = Map<String, dynamic>.from(updateData);
      dataToUpdate['updatedAt'] = Timestamp.now();
      await _firebaseFirestore.collection('posts').doc(postId).update(dataToUpdate);
    }
    catch(error){
      return;
    }
  }

  Future<void>incrementLikes(String postId) async{
    await updatePost(postId, {
      'likes': FieldValue.increment(1)
    });
  }
  Future<void>incrementComments(String postId) async{
    await updatePost(postId, {
      'comments': FieldValue.increment(1)
    });
  }
  Future<void>incrementShares(String postId) async{
    await updatePost(postId, {
      'shares': FieldValue.increment(1)
    });
  }
}

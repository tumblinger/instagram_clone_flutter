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
  
  Future <void> updatePost(String postId, Map<String, dynamic> updateData) async{
    try{
      final dataToUpdate = Map<String, dynamic>.from(updateData);
      dataToUpdate['updatedAt'] = Timestamp.now();
      await _firebaseFirestore.collection('posts').doc(postId).update(dataToUpdate);
    } 
    catch(error){
      print('Error updating post: $error');
      return;
    }
  }
}

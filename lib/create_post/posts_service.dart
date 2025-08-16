import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone/create_post/posts.dart';

class PostsService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

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
    return
      _firebaseFirestore
          .collection('posts')
          .snapshots() 
          .asyncMap((snapshot) async {
            for(var doc in snapshot.docs){
              print('Post id: ${doc.id}, createdby: ${doc.data()['createdby']}');
            }
        List<Posts> posts = [];
            //Filter the docs:
        final filteredDocs = snapshot.docs.where((doc){
          final createdby = doc.data()['createdby'];
          if(createdby is DocumentReference){
            return createdby.id == userId;
          } else if (createdby is String){
            return createdby == userId;
          }
          return false;
        }).toList();

      
        for(var doc in filteredDocs){
          DocumentReference userProfileRef = doc['createdby'];
          DocumentSnapshot userProfileDoc;

          if(userProfileRef is DocumentReference) {
            userProfileDoc = await userProfileRef.get(); //call get() right away
          } else { // if userProfileRef is String
            // build the link/ref first and then call get():
            userProfileDoc = await _firebaseFirestore.collection('user-profiles').doc(userId).get();
          }
          posts.add(Posts.fromFirestore(doc, userProfileDoc));
        }
        return posts;
      });
  }

  Future<void> uploadPostMedia(NewPostMedia newPostMedia) async {
    try{

    } catch(error) {
      return null;
    }
  }

  Future<void> createPost(String userId, List<NewPostMedia> newPostMedia, String caption) async {
    final userRef = _firebaseFirestore.collection('user-profiles').doc(userId);
    final postData = CreatePost(
        createdBy: userRef,
        media: newPostMedia,
        caption: caption,
        likes: 0,
        shares: 0,
        comments: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()
    );
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

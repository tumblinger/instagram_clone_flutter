import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone/create_post/posts.dart';
import 'package:instagram_clone/home/media.dart';
import 'package:uuid/uuid.dart';

class PostsService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance; 
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance; 

  final uuid = Uuid();

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
            userProfileDoc = await userProfileRef.get(); 
          } else { // if userProfileRef is String
           
            userProfileDoc = await _firebaseFirestore.collection('user-profiles').doc(userId).get();
          }
          posts.add(Posts.fromFirestore(doc, userProfileDoc));
        }
        return posts;
      });
  }

  Future<Media?> _uploadPostMedia(NewPostMedia newPostMedia) async {
    try{
      final String newPostMediaFileExt = newPostMedia.file.path.split('.').last.toLowerCase();
      final String newPostMediaFileName = '${uuid.v4()}.$newPostMediaFileExt'; 
      final newPostMediaRef = _firebaseStorage.ref().child('post-media').child(newPostMediaFileName);

      final TaskSnapshot newPostMediaUploadSnapshot = await newPostMediaRef.putFile(newPostMedia.file);
      final String newPostMediaFileUrl = await newPostMediaUploadSnapshot.ref.getDownloadURL();

      return Media(
          value: newPostMediaFileUrl,
          type: newPostMedia.mediaTypes
      );

    } catch(error) {
      return null;
    }
  }

  Future<void> createPost(String userId, String caption, List <NewPostMedia> newPostMediaList) async {
    
    final List<Media?> newMediaList = await Future.wait(
      newPostMediaList.map((newPostMedia) => _uploadPostMedia(newPostMedia))
    );
    final nonNullNewMediaList = newMediaList.whereType<Media>().toList();
    final userRef = _firebaseFirestore.collection('user-profiles').doc(userId);

    final postData = CreatePost(
        createdBy: userRef,
        media: newPostMediaList,
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

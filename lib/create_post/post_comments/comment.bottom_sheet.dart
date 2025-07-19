import 'package:flutter/material.dart';
import 'package:instagram_clone/create_post/post_comments/comment.service.dart';
import 'package:instagram_clone/create_post/posts.dart';
import 'package:provider/provider.dart';

import '../../user_profile/user_profile_provider.dart';

class CommentBottomSheet extends StatefulWidget {
  final Posts posts;
  const CommentBottomSheet({super.key, required this.posts});

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final CommentService commentService = CommentService();
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose(){
    super.dispose();
    _commentController.dispose();
  }

  Future<void> _submitComment(String userId) async{
    String comment = _commentController.text.trim();
    if(comment.isEmpty) return;

    setState(() {
      _isSubmitting = true;
    });

    try{
      await commentService.addComment(widget.posts.id, userId, comment);

      if(mounted){
        _commentController.clear();
      }
    } catch(error){
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error while posting comment')));
      }
      print(error);
    }
    finally{
      if(mounted){
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<MyAuthProvider>().userProfile;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Comments', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(children: [
              if(userProfile?.avatar != null)
                CircleAvatar(
                    backgroundImage: NetworkImage(userProfile!.avatar),),
                SizedBox(width: 10,),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(100)
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Add a comment...',
                              border: InputBorder.none
                              ),
                              ),
                        ),
                        IconButton(onPressed: (){}, icon: Icon(Icons.send))
                      ],
                    ),
                  ),
                )

            ],)

          ],
        ),
      ),
    );
  }
}



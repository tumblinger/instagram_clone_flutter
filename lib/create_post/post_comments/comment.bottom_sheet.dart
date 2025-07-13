import 'package:flutter/material.dart';
import 'package:instagram_clone/user_profile/user_profile_model.dart';
import 'package:provider/provider.dart';

import '../../user_profile/user_profile_provider.dart';

class CommentBottomSheet extends StatefulWidget {
  const CommentBottomSheet({super.key});

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<MyAuthProvider>().userProfile;
    print('!!!!!!!!!!!!!!!!!!!!!!!!!!!! userProfile: $userProfile');
    return Container(
      height: MediaQuery.of(context).size.height*0.75,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          SizedBox(
            height: 8),
          Text('Comments', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),

          Row(children: [

            if(userProfile?.avatar != null)
              SizedBox(
                width: 28.0,
                child: CircleAvatar(
                    backgroundImage: NetworkImage(userProfile!.avatar)),
              ),


          ],)

        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:instagram_clone/user_profile/user_profile_components/user_profile_text_field.dart';
import 'package:instagram_clone/user_profile/user_profile_model.dart';
import 'package:instagram_clone/user_profile/user_profile_provider.dart';
import 'package:provider/provider.dart';

import '../components/app_bottom_navigation_bar.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

  // TextField controllers:
  final  TextEditingController _firstNameController = TextEditingController();
  final  TextEditingController _lastNameController = TextEditingController();
  final  TextEditingController _userNameController = TextEditingController();
  final  TextEditingController _websiteController = TextEditingController();
  final  TextEditingController _bioController = TextEditingController();
  final  TextEditingController _emailController = TextEditingController();
  final  TextEditingController _phoneController = TextEditingController();
  final  TextEditingController _genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final UserProfileModel? userProfile = context.watch<MyAuthProvider>().userProfile;

    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
            onPressed: () => print('cancel'), child: Text('Back')
        ),
        leadingWidth: 68,
        title: Text('User Profile', style:  TextStyle(fontSize: 16),),
        actions: [
          TextButton(onPressed: () => print('done'), child: Text('Done', style: TextStyle(fontWeight: FontWeight.bold),))
        ],
      ),
      body: SafeArea(child:
        SingleChildScrollView(
          child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            if(userProfile == null)
              Center( child: CircularProgressIndicator()),
            if(userProfile != null)
            Column(
              children: [
                // Profile avatar:
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(userProfile.avatar),
                        ),
                      ),
                      TextButton(
                          onPressed: ()=> print('Change profile photo'),
                          child: Text('Change profile photo', style: TextStyle(fontWeight: FontWeight.bold))
                      )
                    ],
                  ),
                ),
                Divider(height: 2, thickness: 1, color: Colors.black26,),
                // Profile Info inputs:
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserProfileTextField(label: 'First Name', controller: _firstNameController,),
                      UserProfileTextField(label: 'Last Name', controller: _lastNameController,),
                      UserProfileTextField(label: 'Username', controller: _userNameController,),
                      UserProfileTextField(label: 'Website', controller: _websiteController,),
                      UserProfileTextField(label: 'Bio', controller: _bioController,),
                      
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Text('Private Information', style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                      UserProfileTextField(label: 'Email', controller: _emailController,),
                      UserProfileTextField(label: 'Phone', controller: _phoneController,),
                      UserProfileTextField(label: 'Gender', controller: _genderController,),
                    ],
                  ),
                )
              ],
            ),
          ],),
                ),
        )
      ),
        bottomNavigationBar:  AppBottomNavigationBar(currentIndex: 4)
    );
  }
}

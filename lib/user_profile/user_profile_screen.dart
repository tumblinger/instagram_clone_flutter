import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/user_profile/user_profile_components/user_profile_gender_input.dart';
import 'package:instagram_clone/user_profile/user_profile_components/user_profile_text_field.dart';
import 'package:instagram_clone/user_profile/user_profile_enums.dart';
import 'package:instagram_clone/user_profile/user_profile_model.dart';
import 'package:instagram_clone/user_profile/user_profile_provider.dart';
import 'package:instagram_clone/user_profile/user_profile_service.dart';
import 'package:provider/provider.dart';

import '../components/app_bottom_navigation_bar.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final UserProfileService _userProfileService = UserProfileService();
  late UserProfileModel? _userProfile;
  final ImagePicker _profileImagePicker = ImagePicker(); 
  bool _updatingProfile = false;

  // TextField controllers:
  final  TextEditingController _firstNameController = TextEditingController();
  final  TextEditingController _userNameController = TextEditingController();
  final  TextEditingController _websiteController = TextEditingController();
  final  TextEditingController _bioController = TextEditingController();
  final  TextEditingController _emailController = TextEditingController();
  final  TextEditingController _phoneController = TextEditingController();
  Gender? _selectedGender;
  File? _pickedProfileImageFile;

  @override
  void initState() {
    final UserProfileModel? userProfile = context.read<MyAuthProvider>().userProfile;
    if(userProfile != null) {
      _userProfile = userProfile;
      _firstNameController.text = userProfile.firstName ?? '';
      _userNameController.text = userProfile.userName;
      _websiteController.text = userProfile.website ?? '';
      _bioController.text = userProfile.bio ?? '';
      _emailController.text = userProfile.email;
      _phoneController.text = userProfile.phoneNumber ?? '';
      _selectedGender = userProfile.gender;
    }
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _userNameController.dispose();
    _websiteController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }



  Future<void> _uploadProfilePhoto() async{
    try{
      final XFile? pickedProfileImage = await _profileImagePicker.pickImage(source: ImageSource.gallery);
      if(pickedProfileImage == null) return;

      setState(() {
        _pickedProfileImageFile = File(pickedProfileImage.path) ;
      });

      }
     catch (error){
      print(error);
    }
  }

  Future<void> _updateProfile() async {
    if(_userProfile ==null){
      return;
    }
    
    setState(() {
      _updatingProfile = true;
    });
    
    final userProfileToUpdate = _userProfile?.copyWith(
      firstName: _firstNameController.text,
      userName: _userNameController.text,
      bio: _bioController.text,
      website: _websiteController.text,
      phoneNumber: _phoneController.text,
      gender: _selectedGender,
      updatedAt: DateTime.now()
    );

    UserProfileModel? updatedUserProfile = await _userProfileService.updateUserProfile(userProfileToUpdate!, _pickedProfileImageFile);

    if(updatedUserProfile != null){
      MyAuthProvider myAuthProvider = MyAuthProvider();
      myAuthProvider.setUserProfile(updatedUserProfile);
    }

    setState(() {
      _updatingProfile = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
            onPressed: () => print('cancel'), child: Text('Back')
        ),
        leadingWidth: 68,
        title: Text('User Profile', style:  TextStyle(fontSize: 16),),
        actions: [
          TextButton(onPressed: _updateProfile, child: _updatingProfile ? CircularProgressIndicator(): Text('Done', style: TextStyle(fontWeight: FontWeight.bold),))
        ],
      ),
      body: SafeArea(child:
        SingleChildScrollView(
          child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Column(children: [
            if(_userProfile == null)
              Center( child: CircularProgressIndicator()),
            if(_userProfile != null)
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
                          backgroundImage: _pickedProfileImageFile != null
                              ? FileImage(_pickedProfileImageFile!)
                              : NetworkImage(_userProfile!.avatar),
                        ),
                      ),
                      TextButton(
                          onPressed: _uploadProfilePhoto,
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
                      UserProfileTextField(label: 'First Name', controller: _firstNameController, placeholder: 'Enter first name',),
                      UserProfileTextField(label: 'Username', controller: _userNameController, placeholder: 'Enter username'),
                      UserProfileTextField(label: 'Website', controller: _websiteController, placeholder: 'Enter website www.website.com', keyboardType: TextInputType.url),
                      UserProfileTextField(label: 'Bio', controller: _bioController, placeholder: 'Enter your bio'),
                      
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Text('Private Information', style: TextStyle(fontWeight: FontWeight.bold),),
                      ),
                      UserProfileTextField(label: 'Email', controller: _emailController, enabled: false,),
                      UserProfileTextField(label: 'Phone', controller: _phoneController, placeholder: 'Enter phone number', keyboardType: TextInputType.phone,),
                      UserProfileGenderInput(selectedGender: _selectedGender, onChanged: (gender) {
                        setState(() {
                          _selectedGender = gender;
                        });
                      }),
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

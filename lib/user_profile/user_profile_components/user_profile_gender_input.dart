import 'package:flutter/material.dart';
import '../user_profile_enums.dart';

class UserProfileGenderInput extends StatelessWidget {
  final Gender? selectedGender;
  final Function(Gender)? onChanged;

  const UserProfileGenderInput({super.key, this.selectedGender, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
            ListTile(
              title: Text('Female'),
              leading: Radio<Gender>(
                value: Gender.female,
                groupValue: selectedGender,
                onChanged: (Gender? currentSelectedGender) {
                  if(onChanged != null && currentSelectedGender != null){
                    onChanged!(currentSelectedGender);
                  }
                },
              ),
            ),
          ListTile(
            title: Text('Male'),
            leading: Radio<Gender>(
              value: Gender.male,
              groupValue: selectedGender,
              onChanged: (Gender? currentSelectedGender) {
                if(onChanged != null && currentSelectedGender != null){
                  onChanged!(currentSelectedGender);
                }
              },
            ),
          ),
         ],
      );
  }
}

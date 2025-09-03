import 'package:flutter/material.dart';
import '../user_profile_enums.dart';

class UserProfileGenderInput extends StatelessWidget {
  final Gender? selectedGender;
  final Function(Gender)? onChanged;

  const UserProfileGenderInput({super.key, this.selectedGender, this.onChanged});

  void _handleGenderSelection(Gender? currentSelectedGender){
      if(onChanged != null && currentSelectedGender != null){
        onChanged!(currentSelectedGender);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text('Gender',),
        ),
        Expanded(
          child: Row(
              children: [
                  Expanded(
                    child: ListTile(
                      title: Text('Female'),
                      horizontalTitleGap: 0,
                      dense: true,
                      leading: Radio<Gender>(
                        value: Gender.female,
                        groupValue: selectedGender,
                        onChanged: _handleGenderSelection,
                      ),
                    ),
                  ),
                Expanded(
                  child: ListTile(
                    title: Text('Male'),
                    horizontalTitleGap: 0,
                    dense: true,
                    leading: Radio<Gender>(
                      value: Gender.male,
                      groupValue: selectedGender,
                      onChanged: _handleGenderSelection,
                    ),
                  ),
                ),
               ],
            ),
        ),
      ],
    );
  }
}

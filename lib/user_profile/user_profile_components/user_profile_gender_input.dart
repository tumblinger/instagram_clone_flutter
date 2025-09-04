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

    Widget radioButtonGender(String label, Gender value){
      return Expanded(
        child: ListTile(
          title: Text(label),
          horizontalTitleGap: 0,
          dense: true,
          contentPadding: EdgeInsets.all(0),
          leading: Radio<Gender>(
            value: value,
            groupValue: selectedGender,
            onChanged: _handleGenderSelection,
          ),
        ),
      );
    }

    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text('Gender',),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
              children: [
                radioButtonGender('female', Gender.female),
                radioButtonGender('male', Gender.male),

               ],
            ),
        ),
      ],
    );
  }
}


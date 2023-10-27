import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  ValueNotifier<String> gender;
  CustomCheckbox(this.gender, {super.key});

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Row(
      children: [
        Text(
          "남",
          style: TextStyle(fontSize: 30),
        ),
        Checkbox(
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.resolveWith(getColor),
          value: isChecked,
          onChanged: (bool? value) {
            if (value!) {
              widget.gender.value = "남";
            } else {
              widget.gender.value = "여";
            }

            print("클릭 체크박스 : $value");
            setState(() {
              isChecked = value!;
            });
          },
        ),
      ],
    );
  }
}

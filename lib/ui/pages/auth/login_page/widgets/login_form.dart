import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/move.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/_core/utils/validator_util.dart';
import 'package:flutter_blog/data/dtos/user_request.dart';
import 'package:flutter_blog/data/stores/session_store.dart';
import 'package:flutter_blog/ui/pages/auth/login_page/widgets/custom_checkbox.dart';
import 'package:flutter_blog/ui/widgets/custom_auth_text_form_field.dart';
import 'package:flutter_blog/ui/widgets/custom_elavated_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Ref를 사용하려면 StatelessWidget에서 ConsumerWidget으로 변경하여야 한다.
class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();

  final username = TextEditingController();

  final password = TextEditingController();

  ValueNotifier<String> gender = ValueNotifier("여");

  void submit(WidgetRef ref) {
    if (formKey.currentState!.validate()) {
      print(username.text);
      print(password.text);
      print(gender.value);
      LoginReqDTO reqDTO = LoginReqDTO(username: username.text, password: password.text);
      ref.read(sessionProvider).login(reqDTO);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomAuthTextFormField(
            text: "Username",
            obscureText: false,
            funValidator: validateUsername(),
            controller: username,
          ),
          const SizedBox(height: mediumGap),
          CustomAuthTextFormField(
            text: "Password",
            obscureText: true,
            funValidator: validatePassword(),
            controller: password,
          ),
          const SizedBox(height: largeGap)
        ],
      ),
    );
  }
}

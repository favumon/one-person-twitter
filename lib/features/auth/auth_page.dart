import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:one_person_twitter/features/auth/auth_page_controller.dart';

class AuthPage extends StatelessWidget {
  final AuthPageController _authPageController = Get.put(AuthPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() => _authPageController.isBusy.value
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _authPageController.formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          child: const Text(
                            'Sign in with email and password',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextFormField(
                          initialValue: 'twitteruser@gmail.com',
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (String value) {
                            if (value.isEmpty) return 'Please enter email';
                            return null;
                          },
                          onSaved: (value) => _authPageController.email = value,
                        ),
                        TextFormField(
                          initialValue: 'password',
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          validator: (String value) {
                            if (value.isEmpty) return 'Please enter passord';
                            return null;
                          },
                          onSaved: (value) =>
                              _authPageController.password = value,
                          obscureText: true,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            alignment: Alignment.center,
                            child: ElevatedButton.icon(
                                onPressed: _authPageController.emailSignIn,
                                icon: FaIcon(FontAwesomeIcons.envelope),
                                label: Text('Sign In or Register'))),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Text('Or'),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: SignInButton(
                            Buttons.Google,
                            text: 'Sign In using Google',
                            onPressed: _authPageController.signinWithGoogle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ))));
  }
}

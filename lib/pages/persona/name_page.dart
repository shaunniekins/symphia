// name_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:symphia/controller/user_controller.dart';
import 'package:symphia/pages/persona/birthday_page.dart';

class NamePage extends StatefulWidget {
  const NamePage({super.key});

  @override
  _NamePageState createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController =
      TextEditingController(text: Get.find<UserController>().name.value);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 16, 30, 16),
          child: Column(
            children: <Widget>[
              const Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Call me',
                    style: TextStyle(fontSize: 50.0),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'First Name or Nickname',
                          helperText: 'This is what Symphia will call you.',
                          helperStyle: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey,
                          ),
                        ),
                        style: const TextStyle(fontSize: 25.0),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          } else if (value.length < 2) {
                            return 'Name must be at least 2 characters';
                          } else if (value.length > 10) {
                            return 'Name must be less than 10 characters';
                          } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                            return 'Name must contain only alphabetic characters';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _formKey.currentState?.validate();
                        },
                        onSaved: (value) {
                          Get.find<UserController>().saveName(value!);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Container(
                  height: 50.0,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.purple,
                        Colors.deepPurple,
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          Get.to(() => const BirthdayPage());
                        }
                      },
                      child: const Center(
                        child: Text(
                          'CONTINUE',
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

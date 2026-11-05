
import 'package:flutter/material.dart';

class UserForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController ageController;
  final VoidCallback onCreateUser;

  const UserForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.ageController,
    required this.onCreateUser,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 16),

        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 16),

        TextField(
          controller: ageController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            labelText: 'Age',
            hintText: 'Enter a number (e.g. 23)',
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: onCreateUser,
          child: const Text('Create User'),
        ),
      ],
    );
  }
}

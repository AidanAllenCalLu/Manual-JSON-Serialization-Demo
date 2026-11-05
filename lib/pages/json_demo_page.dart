
import 'dart:convert';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../widgets/user_form.dart';
import '../widgets/result_card.dart';

class JsonDemoPage extends StatefulWidget {
  const JsonDemoPage({super.key});

  @override
  State<JsonDemoPage> createState() => _JsonDemoPageState();
}

class _JsonDemoPageState extends State<JsonDemoPage> {
  // Text field controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();

  // Result information
  String result = '';
  String jsonOutput = '';
  bool hasError = false;

  // Handle JSON serialization
  void createUser() {
    try {
      // Get information entered by the user
      final name = nameController.text;
      final email = emailController.text;
      final ageText = ageController.text;

      // Create JSON data
      final incomingJson = jsonEncode({
        'name': name,
        'email': email,
        'age': int.tryParse(ageText) ?? ageText,
      });

      // Decode JSON into a Map
      final userMap =
          jsonDecode(incomingJson) as Map<String, dynamic>;

      // Convert Map into a User object
      final user = User.fromJson(userMap);

      // Convert User object back into JSON
      final encodedJson = jsonEncode(user);

      setState(() {
        hasError = false;

        result =
            'User successfully created!\n\n'
            'Name: ${user.name}\n'
            'Email: ${user.email}\n'
            'Age: ${user.age}';

        jsonOutput = encodedJson;
      });
    } catch (e) {
      // Handle serialization errors
      setState(() {
        hasError = true;
        result = 'JSON Serialization Failed!\n\n$e';
        jsonOutput = '';
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual JSON Serialization'),
        backgroundColor:
            Theme.of(context).colorScheme.inversePrimary,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Create a User',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Enter user information to test JSON serialization.',
            ),

            const SizedBox(height: 24),

            // User input widget
            UserForm(
              nameController: nameController,
              emailController: emailController,
              ageController: ageController,
              onCreateUser: createUser,
            ),

            const SizedBox(height: 24),

            // Display serialization results
            ResultCard(
              result: result,
              jsonOutput: jsonOutput,
              hasError: hasError,
            ),
          ],
        ),
      ),
    );
  }
}

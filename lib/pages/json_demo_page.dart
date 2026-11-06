
import 'dart:convert';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../widgets/user_form.dart';
import '../widgets/result_card.dart';
import '../services/user_service.dart';

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

  // API service
  final UserService userService = UserService();

  // API result information
  String apiMessage = '';
  bool isLoading = false;

  // Manual JSON result information
  String result = '';
  String jsonOutput = '';
  bool hasError = false;

  // Handle manual JSON serialization
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
      setState(() {
        hasError = true;
        result = 'JSON Serialization Failed!\n\n$e';
        jsonOutput = '';
      });
    }
  }

  // Retrieve user data from DummyJSON
  Future<void> fetchUserFromApi() async {
    setState(() {
      isLoading = true;
      apiMessage = 'Retrieving user from API...';
    });

    try {
      final user = await userService.fetchUser();

      if (!mounted) return;

      setState(() {
        nameController.text = user.name;
        emailController.text = user.email;
        ageController.text = user.age.toString();

        apiMessage =
            'Successfully retrieved user!\n\n'
            'ID: ${user.id}\n'
            'Name: ${user.name}\n'
            'Email: ${user.email}\n'
            'Age: ${user.age}';

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        apiMessage = 'API Error: $e';
        isLoading = false;
      });
    }
  }

  // Send user data to DummyJSON
  Future<void> sendUserToApi() async {
    try {
      final age = int.tryParse(ageController.text);

      if (nameController.text.trim().isEmpty ||
          emailController.text.trim().isEmpty ||
          age == null) {
        setState(() {
          apiMessage =
              'Please enter a name, email, and valid numeric age.';
        });
        return;
      }

      setState(() {
        isLoading = true;
        apiMessage = 'Sending user to API...';
      });

      final user = User(
        nameController.text.trim(),
        emailController.text.trim(),
        age,
      );

      final response = await userService.createUser(user);

      if (!mounted) return;

      setState(() {
        apiMessage =
            'Successfully sent user!\n\n'
            'Server Response:\n'
            '${const JsonEncoder.withIndent('  ').convert(response)}';

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        apiMessage = 'API Error: $e';
        isLoading = false;
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
            // MANUAL JSON SECTION
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

            UserForm(
              nameController: nameController,
              emailController: emailController,
              ageController: ageController,
              onCreateUser: createUser,
            ),

            const SizedBox(height: 24),

            ResultCard(
              result: result,
              jsonOutput: jsonOutput,
              hasError: hasError,
            ),

            const SizedBox(height: 32),

            const Divider(),

            const SizedBox(height: 16),

            // WEB API SECTION
            const Text(
              'Web API Integration',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Retrieve user information from DummyJSON '
              'or send your own user data to the API.',
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed:
                  isLoading ? null : fetchUserFromApi,
              icon: const Icon(Icons.download),
              label: const Text('Fetch User from API'),
            ),

            const SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed:
                  isLoading ? null : sendUserToApi,
              icon: const Icon(Icons.upload),
              label: const Text('Send User to API'),
            ),

            const SizedBox(height: 16),

            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),

            if (apiMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SelectableText(
                  apiMessage,
                  style: const TextStyle(
                    color: Colors.black87,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

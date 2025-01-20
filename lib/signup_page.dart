// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:io';
import 'package:fitness_buddy_app/buddy_finder_page.dart';
import 'package:fitness_buddy_app/group_organiser_page.dart';
import 'package:fitness_buddy_app/login_page.dart';
import 'package:fitness_buddy_app/on_board_buddy.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String selectedRole = 'buddy'; // Default selection
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> signup() async {
    final url = Uri.parse('http://192.168.29.189:8000/auth/api/signup/');
    try {
      final response = await http.post(
        url,
        body: {
          'username': _usernameController.text,
          'password1': _passwordController.text,
          'password2': _passwordController.text,
          'email': _emailController.text,
          'role': selectedRole,
        },
      );
      if (response.statusCode == 201) {
        // Parse the response to extract required user data
        final responseData = jsonDecode(response.body);
        final int userId =
            responseData['id'] ?? 0; // Use 0 as fallback for missing id
        final String username = responseData['username'] ?? 'Unknown';
        final File? profilePicture = _selectedImage;
        final String email = responseData['email'] ?? '';

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup successful!')),
        );

        // Navigate to the appropriate page based on the selected role
        if (selectedRole == 'buddy') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OnboardBuddyScreen(
                userId: userId,
                username: username,
                email: email,
              ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GroupOrganizerPage(
                username: username,
              ),
            ),
          );
        }
      } else {
        final errors = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: ${errors.toString()}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  // Widget _buildProfilePicturePicker() {
  //   return Center(
  //     child: Column(
  //       children: [
  //         const Text(
  //           'Profile Picture',
  //           style: TextStyle(color: Colors.white, fontSize: 16),
  //         ),
  //         const SizedBox(height: 10),
  //         GestureDetector(
  //           onTap: _pickImage,
  //           child: CircleAvatar(
  //             radius: 50,
  //             backgroundImage:
  //                 _selectedImage != null ? FileImage(_selectedImage!) : null,
  //             child: _selectedImage == null
  //                 ? const Icon(Icons.camera_alt, size: 30, color: Colors.grey)
  //                 : null,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildProfilePicturePicker() {
    return Center(
      child: Column(
        children: [
          const Text(
            'Profile Picture',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: _selectedImage != null
                  ? FileImage(_selectedImage!)
                  : AssetImage('assets/default.jpg') as ImageProvider,
              child: _selectedImage == null
                  ? const Icon(Icons.camera_alt, size: 30, color: Colors.grey)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Role',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildRoleCard('buddy', 'Workout Buddy', Icons.fitness_center),
            _buildRoleCard('organizer', 'Organizer', Icons.group),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleCard(String role, String label, IconData icon) {
    bool isSelected = selectedRole == role;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = role;
        });
      },
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF28B67E) : Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Color(0xFF28B67E) : Colors.grey,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Color(0xFF28B67E).withOpacity(0.4),
                blurRadius: 8,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Signup'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(height: 20),
              const Text(
                'Create an Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              _buildProfilePicturePicker(),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _usernameController,
                label: 'Username',
                icon: Icons.person,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _passwordController,
                label: 'Password',
                icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              _buildRoleSelection(),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: const Text(
                    "Have a Account , login",
                    style: TextStyle(color: Color(0xFF28B67E)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await signup(); // Attempt signup, but don't block navigation
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => selectedRole == 'buddy'
                    //         ? OnboardBuddyScreen(userId: null, username: '', profilePicture: '', email: '',)
                    //         : GroupOrganizerPage(),
                    //   ),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    backgroundColor: const Color(0xFF28B67E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF28B67E)),
        filled: true,
        fillColor: Colors.grey[850],
        labelStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

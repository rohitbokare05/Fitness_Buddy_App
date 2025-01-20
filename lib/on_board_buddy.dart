import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'buddy_finder_page.dart'; // Assuming you have BuddyFinderPage in your app

class OnboardBuddyScreen extends StatefulWidget {
  // const OnboardBuddyScreen({super.key});
  final int userId;
  final String username;
  final String email;
  const OnboardBuddyScreen({
    super.key,
    required this.userId,
    required this.username,
    required this.email,
  });
  @override
  _OnboardBuddyScreenState createState() => _OnboardBuddyScreenState();
}

class _OnboardBuddyScreenState extends State<OnboardBuddyScreen> {
  final TextEditingController _fitnessGoalsController = TextEditingController();
  final TextEditingController _workoutPreferencesController =
      TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();
  Future<void> saveBuddyDetails() async {
    final url =
        Uri.parse('http://192.168.29.189:8000/auth/api/fitness-details/');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json'
        }, // Ensure the server knows it's JSON
        body: jsonEncode({
          'user': {
            'username': widget.username,
          },
          'fitness_goals': _fitnessGoalsController.text,
          'workout_preferences': _workoutPreferencesController.text,
          'availability': _availabilityController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Buddy details saved successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save details: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BuddyFinderPage()),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
  }) {
    return TextField(
      controller: controller,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Onboard as Workout Buddy',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 40), // Space at the top
              const Text(
                'Tell Us About Yourself',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40), // Space before the first field
              _buildTextField(
                controller: _fitnessGoalsController,
                label: 'Fitness Goals',
                icon: Icons.flag,
              ),
              const SizedBox(height: 30), // Space between fields
              _buildTextField(
                controller: _workoutPreferencesController,
                label: 'Workout Preferences',
                icon: Icons.fitness_center,
              ),
              const SizedBox(height: 30), // Space between fields
              _buildTextField(
                controller: _availabilityController,
                label: 'Availability',
                icon: Icons.calendar_today,
              ),
              const SizedBox(height: 50), // Space before the button
              ElevatedButton(
                onPressed: saveBuddyDetails,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  backgroundColor: Color(0xFF28B67E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Save and Proceed',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 40), // Space after the button
            ],
          ),
        ),
      ),
    );
  }
}

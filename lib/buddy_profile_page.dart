import 'package:flutter/material.dart';

class BuddyProfilePage extends StatelessWidget {
  final Map<String, String> buddyDetails;

  BuddyProfilePage({required this.buddyDetails});

  @override
  Widget build(BuildContext context) {
    final String name = buddyDetails['name'] ?? 'Unknown';
    final String profilePicture =
        buddyDetails['profilePicture'] ?? 'assets/default_avatar.png';
    final String fitnessGoals = buddyDetails['fitnessGoals'] ?? 'Not specified';
    final String bio = buddyDetails['bio'] ?? 'No bio available';
    final String fitnessHistory = buddyDetails['fitnessHistory'] ?? '';
    final String phone = buddyDetails['phone'] ?? 'Not provided';
    final String email = buddyDetails['email'] ?? 'Not provided';

    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      appBar: AppBar(
        title: Text(
          '$name\'s Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black, // Dark theme app bar
        iconTheme: IconThemeData(color: Color(0xFF28B67E)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture and Name
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(profilePicture),
                  ),
                  SizedBox(height: 8),
                  Text(
                    name,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Personal Information
            _sectionTitle('Personal Information'),
            Text('Fitness Goals: $fitnessGoals',
                style: TextStyle(color: Colors.grey[300])),
            SizedBox(height: 8),
            Text('Bio: $bio', style: TextStyle(color: Colors.grey[300])),
            SizedBox(height: 16),

            // Fitness History
            _sectionTitle('Fitness History'),
            SizedBox(height: 8),
            if (fitnessHistory.isNotEmpty)
              ...fitnessHistory.split(';').map((activity) => ListTile(
                    leading: Icon(Icons.check_circle, color: Color(0xFF28B67E)),
                    title:
                        Text(activity, style: TextStyle(color: Colors.white)),
                  ))
            else
              Text('No fitness history available.',
                  style: TextStyle(color: Colors.grey[300])),
            SizedBox(height: 16),

            // Contact Details
            _sectionTitle('Contact Details'),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, color: Color(0xFF28B67E)),
                SizedBox(width: 8),
                Text(phone, style: TextStyle(color: Colors.grey[300])),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.email, color: Color(0xFF28B67E)),
                SizedBox(width: 8),
                Text(email, style: TextStyle(color: Colors.grey[300])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF28B67E)),
    );
  }
}

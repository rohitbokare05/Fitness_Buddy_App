import 'package:flutter/material.dart';

class FriendsListPage extends StatelessWidget {
  final List<Map<String, String>> friends;

  FriendsListPage({required this.friends});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends List'),
      ),
      body: friends.isEmpty
          ? Center(
              child: Text(
                'No friends added yet!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(friend['name']![0]),
                    ),
                    title: Text(friend['name']!),
                    subtitle: Text(
                        '${friend['activity']} • ${friend['skill']} • ${friend['location']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.info),
                          onPressed: () {
                            // Navigate to detailed friend info page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FriendInfoPage(
                                  friendDetails: {
                                    'name': friend['name']!,
                                    'profilePicture':
                                        'assets/default_avatar.png',
                                    'fitnessGoals': 'Lose weight, Build muscle',
                                    'bio':
                                        'Passionate about fitness and outdoor activities!',
                                    'fitnessHistory':
                                        'Completed a 10k run;Joined Yoga classes',
                                    'phone': '123-456-7890',
                                    'email': 'friend@example.com',
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Logic to remove friend
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// Dummy FriendInfoPage for demonstration
class FriendInfoPage extends StatelessWidget {
  final Map<String, String> friendDetails;

  FriendInfoPage({required this.friendDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(friendDetails['name']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(friendDetails['profilePicture']!),
            ),
            SizedBox(height: 16),
            Text(
              'Name: ${friendDetails['name']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Bio: ${friendDetails['bio']}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Fitness Goals: ${friendDetails['fitnessGoals']}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Fitness History: ${friendDetails['fitnessHistory']}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Phone: ${friendDetails['phone']}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Email: ${friendDetails['email']}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class GroupPage extends StatelessWidget {
  final String groupId;
  GroupPage({required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      appBar: AppBar(
        title: Text('Group Details'),
        backgroundColor: Colors.black, // Dark theme AppBar
        iconTheme: IconThemeData(color: Color(0xFF28B67E)), // Teal icons
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: FutureBuilder(
        future: fetchGroupDetails(groupId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: Color(0xFF28B67E)));
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }
          final groupData = snapshot.data as Map<String, dynamic>;
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Group Details
                Text(
                  'Group: ${groupData['name']}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF28B67E),
                  ),
                ),
                SizedBox(height: 10),
                _infoText('Activity: ${groupData['activity_type']}'),
                _infoText('Schedule: ${groupData['schedule']}'),
                _infoText('Location: ${groupData['location']}'),
                SizedBox(height: 20),
                _infoText('Description: ${groupData['description']}'),
                SizedBox(height: 20),
                Divider(color: Colors.grey[700]),

                // Members Section
                Text(
                  'Members',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF28B67E),
                  ),
                ),
                SizedBox(height: 10),
                _buildMemberList(groupData['members']),
                SizedBox(height: 20),
                Divider(color: Colors.grey[700]),

                // Organizer Contact
                Text(
                  'Organizer Contact',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF28B67E),
                  ),
                ),
                SizedBox(height: 10),
                _infoText('Name: ${groupData['organizer_name']}'),
                _infoText('Contact: ${groupData['organizer_contact']}'),
                SizedBox(height: 20),

                // Join Request Button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF28B67E),
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      sendJoinRequest(groupId);
                    },
                    child: Text(
                      'Send Join Request',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> fetchGroupDetails(String groupId) async {
    await Future.delayed(Duration(seconds: 2)); // Simulate delay
    return {
      'name': 'Morning Yoga Group',
      'activity_type': 'Yoga',
      'schedule': 'Mon-Wed-Fri 7 AM',
      'location': 'Park near College',
      'description': 'A group for yoga enthusiasts.',
      'members': [
        {'name': 'John Doe', 'profile_pic': 'https://via.placeholder.com/150'},
        {'name': 'Jane Doe', 'profile_pic': 'https://via.placeholder.com/150'},
      ],
      'organizer_name': 'Alice Smith',
      'organizer_contact': 'alice.smith@example.com',
    };
  }

  Widget _infoText(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.grey[300], fontSize: 16),
    );
  }

  Widget _buildMemberList(List members) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: members.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(members[index]['profile_pic']),
          ),
          title: Text(
            members[index]['name'],
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  void sendJoinRequest(String groupId) {
    print('Join request sent for group: $groupId');
  }
}

import 'package:flutter/material.dart';
import 'package:fitness_buddy_app/add_group.dart';
import 'package:fitness_buddy_app/group_details_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GroupOrganizerPage extends StatefulWidget {
  final String username;
  const GroupOrganizerPage({super.key, required this.username});

  @override
  // ignore: library_private_types_in_public_api
  _GroupOrganizerPageState createState() => _GroupOrganizerPageState();
}

class _GroupOrganizerPageState extends State<GroupOrganizerPage> {
  String filterProximity = 'All';
  String filterAvailability = 'All';
  bool isLoading = true;
  String errorMessage = '';
  List<Map<String, String>> fitnessGroups = [];
  List<Map<String, String>> groups = [];
  String loggedInUserName = 'Allice';
  @override
  void initState() {
    super.initState();
    fetchFitnessGroups();
    fetchCreatedGroups();
  }

  // Mock data for fitness groups
  final List<Map<String, String>> joinRequests = [
    {
      'name': 'Alice',
      'group': 'Morning Runners',
      'message': 'Looking forward to joining!'
    },
    {
      'name': 'Bob',
      'group': 'Yoga Lovers',
      'message': 'Excited to participate!'
    },
    // Add more data...
  ];

  void _addGroup(Map<String, String> newGroup) {
    setState(() {
      fitnessGroups.add(newGroup);
    });
  }

  // Filters the groups based on proximity and availability
  List<Map<String, String>> filterGroups() {
    return fitnessGroups.where((group) {
      final matchesProximity =
          filterProximity == 'All' || group['location'] == filterProximity;
      return matchesProximity; // Add availability logic if needed
    }).toList();
  }

  void fetchFitnessGroups() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.29.189:8000/auth/api/fitness-groups/'),
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);

        // Debugging: Print the data to verify structure
        print('Fitness Groups API Response: $data');

        setState(() {
          fitnessGroups = data.map<Map<String, String>>((item) {
            // Extracting details from API structure
            return {
              'name': item['name'] ?? 'Unknown', // Organizer as name
              'activity':
                  item['activity_type'] ?? 'Not specified', // Activity type
              'location': item['location'] ?? 'Not specified', // Group location
              'details': item['schedule'] ?? 'Not specified', // Group schedule
            };
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to load fitness groups: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred while fetching fitness groups: $e';
        isLoading = false;
      });
    }
  }

  void fetchCreatedGroups() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.29.189:8000/auth/api/fitness-groups/'),
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);

        // Debugging: Print the data to verify structure
        print('Fitness Groups API Response: $data');

        setState(() {
          // Filter groups where the organizer name matches the logged-in user
          groups = data
              .where((item) =>
                  item['organizer'] ==
                  loggedInUserName) // Filter by organizer name
              .map<Map<String, String>>((item) {
            return {
              'name': item['name'] ?? 'Unknown', // Group name
              'activity':
                  item['activity_type'] ?? 'Not specified', // Activity type
              'location': item['location'] ?? 'Not specified', // Group location
              'details': item['schedule'] ?? 'Not specified', // Group schedule
            };
          }).toList();

          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to load created groups: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred while fetching created groups: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0xFF28B67E),
        title: Text('Group Organizer', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filters Section
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     DropdownButton<String>(
            //       dropdownColor: Colors.grey[850],
            //       value: filterProximity,
            //       items: ['All', 'Park', 'Studio', 'Gym']
            //           .map((e) => DropdownMenuItem<String>(
            //                 value: e,
            //                 child:
            //                     Text(e, style: TextStyle(color: Colors.white)),
            //               ))
            //           .toList(),
            //       onChanged: (value) =>
            //           setState(() => filterProximity = value!),
            //     ),
            //     DropdownButton<String>(
            //       dropdownColor: Colors.grey[850],
            //       value: filterAvailability,
            //       items: ['All', 'Morning', 'Evening']
            //           .map((e) => DropdownMenuItem<String>(
            //                 value: e,
            //                 child:
            //                     Text(e, style: TextStyle(color: Colors.white)),
            //               ))
            //           .toList(),
            //       onChanged: (value) =>
            //           setState(() => filterAvailability = value!),
            //     ),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // First Dropdown
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[950],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white54, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.place,
                          color: Colors.white70), // Add location icon
                      SizedBox(width: 8),
                      DropdownButton<String>(
                        dropdownColor: Colors.grey[850],
                        underline: SizedBox(), // Remove default underline
                        value: filterProximity,
                        items: [
                          DropdownMenuItem(
                            value: 'All',
                            child: Row(
                              children: [
                                Icon(Icons.all_inclusive,
                                    color: Colors.white70),
                                SizedBox(width: 8),
                                Text('All',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Park',
                            child: Row(
                              children: [
                                Icon(Icons.park, color: Colors.white70),
                                SizedBox(width: 8),
                                Text('Park',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Studio',
                            child: Row(
                              children: [
                                Icon(Icons.videocam, color: Colors.white70),
                                SizedBox(width: 8),
                                Text('Studio',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Gym',
                            child: Row(
                              children: [
                                Icon(Icons.fitness_center,
                                    color: Colors.white70),
                                SizedBox(width: 8),
                                Text('Gym',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => filterProximity = value!),
                        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                // Second Dropdown
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[950],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white54, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.schedule,
                          color: Colors.white70), // Add clock icon
                      SizedBox(width: 8),
                      DropdownButton<String>(
                        dropdownColor: Colors.grey[850],
                        underline: SizedBox(), // Remove default underline
                        value: filterAvailability,
                        items: [
                          DropdownMenuItem(
                            value: 'All',
                            child: Row(
                              children: [
                                Icon(Icons.all_inclusive,
                                    color: Colors.white70),
                                SizedBox(width: 8),
                                Text('All',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Morning',
                            child: Row(
                              children: [
                                Icon(Icons.wb_sunny, color: Colors.white70),
                                SizedBox(width: 8),
                                Text('Morning',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Evening',
                            child: Row(
                              children: [
                                Icon(Icons.nights_stay, color: Colors.white70),
                                SizedBox(width: 8),
                                Text('Evening',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => filterAvailability = value!),
                        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            // Tab Section
            DefaultTabController(
              length: 3,
              child: Expanded(
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Color(0xFF28B67E),
                      unselectedLabelColor: Colors.white,
                      indicatorColor: Color(0xFF28B67E),
                      tabs: [
                        Tab(text: 'Manage Groups'),
                        Tab(text: 'Join Requests'),
                        Tab(
                          text: 'Created Groups',
                        )
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Manage Groups Tab
                          ListView(
                            children: filterGroups()
                                .map((group) => Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Card(
                                        color: Colors.grey[850],
                                        child: ListTile(
                                          title: Text(
                                            group['name']!,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          subtitle: Text(
                                            '${group['activity']} • ${group['schedule']} • ${group['location']}',
                                            style: TextStyle(
                                                color: Colors.white70),
                                          ),
                                          trailing: Icon(Icons.edit,
                                              color: Color(0xFF28B67E)),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => GroupPage(
                                                    groupId:
                                                        'group_id_1'), // Pass the groupId
                                              ),
                                            );
                                            // Navigate to group details for editing
                                          },
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                          // Join Requests Tab
                          ListView(
                            children: joinRequests
                                .map((request) => Card(
                                      color: Colors.grey[850],
                                      child: ListTile(
                                        title: Text(
                                          '${request['name']} wants to join',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        subtitle: Text(
                                          'Group: ${request['group']}\nMessage: ${request['message']}',
                                          style:
                                              TextStyle(color: Colors.white70),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.check,
                                                  color: Colors.green),
                                              onPressed: () {
                                                // Approve join request
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.close,
                                                  color: Colors.red),
                                              onPressed: () {
                                                // Reject join request
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                          //Created Groups
                          ListView(
                            children: groups
                                .map((group) => Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Card(
                                        color: Colors.grey[850],
                                        child: ListTile(
                                          title: Text(
                                            group['name']!,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          subtitle: Text(
                                            '${group['activity']} • ${group['schedule']} • ${group['location']}',
                                            style: TextStyle(
                                                color: Colors.white70),
                                          ),
                                          trailing: Icon(Icons.edit,
                                              color: Color(0xFF28B67E)),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => GroupPage(
                                                    groupId:
                                                        'group_id_1'), // Pass the groupId
                                              ),
                                            );
                                            // Navigate to group details for editing
                                          },
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF28B67E),
        onPressed: () async {
          final newGroup = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddGroupPage(),
            ),
          );

          if (newGroup != null) {
            _addGroup(newGroup);
          }
          // Navigate to create a new group page
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

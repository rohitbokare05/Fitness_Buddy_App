import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fitness_buddy_app/buddy_profile_page.dart';
import 'package:fitness_buddy_app/group_details_page.dart';

class BuddyFinderPage extends StatefulWidget {
  @override
  _BuddyFinderPageState createState() => _BuddyFinderPageState();
}

class _BuddyFinderPageState extends State<BuddyFinderPage> {
  String filterActivity = 'All';
  String filterSkill = 'All';
  String filterLocation = 'All';

  bool isLoading = true;
  String errorMessage = '';

  List<Map<String, String>> workoutBuddies = [];
  List<Map<String, String>> fitnessGroups = [];

  @override
  void initState() {
    super.initState();
    fetchFitnessDetails();
    fetchFitnessGroups();
  }

  // Fetch fitness details from API
  void fetchFitnessDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.29.189:8000/auth/api/fitness-details/'),
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);

        // Debugging: Print the data to verify structure
        print('API Response: $data');

        setState(() {
          workoutBuddies = data.map<Map<String, String>>((item) {
            // Extracting details from nested structure
            return {
              'name': item['user']['username'] ??
                  'Unknown', // Username from nested user
              'activity': item['workout_preferences'] ??
                  'Not specified', // Workout preferences
              'skill': item['fitness_goals'] ??
                  'Not specified', // Fitness goals (mapped as skill)
              'location': item['availability'] ??
                  'Not specified', // Availability mapped as location
            };
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
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
              'name': item['organizer'] ?? 'Unknown', // Organizer as name
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

  List<Map<String, String>> friendsList = [];

  List<Map<String, String>> filterBuddies() {
    return workoutBuddies.where((item) {
      final matchesActivity =
          filterActivity == 'All' || item['activity'] == filterActivity;
      final matchesSkill = filterSkill == 'All' || item['skill'] == filterSkill;
      final matchesLocation =
          filterLocation == 'All' || item['location'] == filterLocation;
      return matchesActivity && matchesSkill && matchesLocation;
    }).toList();
  }

  List<Map<String, String>> filterGroups() {
    return fitnessGroups.where((item) {
      final matchesActivity =
          filterActivity == 'All' || item['activity'] == filterActivity;
      final matchesLocation =
          filterLocation == 'All' || item['location'] == filterLocation;
      return matchesActivity && matchesLocation;
    }).toList();
  }

  void addFriend(Map<String, String> friend) {
    setState(() {
      if (!friendsList.contains(friend)) {
        friendsList.add(friend);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${friend['name']} added as a friend!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${friend['name']} is already your friend!')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Buddy Finder',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 50.0),
            child: IconButton(
              icon: const Icon(Icons.people, color: Color(0xFF28B67E)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FriendsListPage(friends: friendsList),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filters Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black, // Darker background for contrast
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromARGB(255, 16, 16, 16).withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4), // Creates a subtle elevation
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Filters",
                    style: TextStyle(
                      color: Color(0xFF28B67E),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Activity Dropdown
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Activity",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 5),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Color(0xFF28B67E), width: 1),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: DropdownButton<String>(
                                  value: filterActivity,
                                  dropdownColor: Colors.grey[850],
                                  underline: Container(),
                                  icon: const Icon(Icons.sports,
                                      color: Color(0xFF28B67E)),
                                  style: const TextStyle(color: Colors.white),
                                  isExpanded: true,
                                  items: ['All', 'Yoga', 'Running', 'Gym']
                                      .map((e) => DropdownMenuItem<String>(
                                            value: e,
                                            child: Text(e),
                                          ))
                                      .toList(),
                                  onChanged: (value) =>
                                      setState(() => filterActivity = value!),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Skill Dropdown
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Skill Level",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 5),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Color(0xFF28B67E), width: 1),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: DropdownButton<String>(
                                  value: filterSkill,
                                  dropdownColor: Colors.grey[850],
                                  underline: Container(),
                                  icon: const Icon(Icons.bar_chart,
                                      color: Color(0xFF28B67E)),
                                  style: const TextStyle(color: Colors.white),
                                  isExpanded: true,
                                  items: [
                                    'All',
                                    'Beginner',
                                    'Intermediate',
                                    'Advanced'
                                  ]
                                      .map((e) => DropdownMenuItem<String>(
                                            value: e,
                                            child: Text(e),
                                          ))
                                      .toList(),
                                  onChanged: (value) =>
                                      setState(() => filterSkill = value!),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Location Dropdown
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Location",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 5),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Color(0xFF28B67E), width: 1),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: DropdownButton<String>(
                                  value: filterLocation,
                                  dropdownColor: Colors.grey[850],
                                  underline: Container(),
                                  icon: const Icon(Icons.location_on,
                                      color: Color(0xFF28B67E)),
                                  style: const TextStyle(color: Colors.white),
                                  isExpanded: true,
                                  items: [
                                    'All',
                                    'Downtown',
                                    'Suburbs',
                                    'City Center',
                                    'Park',
                                    'Studio'
                                  ]
                                      .map((e) => DropdownMenuItem<String>(
                                            value: e,
                                            child: Text(e),
                                          ))
                                      .toList(),
                                  onChanged: (value) =>
                                      setState(() => filterLocation = value!),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Tabs Section
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    indicatorColor: Color(0xFF28B67E),
                    tabs: const [
                      Tab(
                        text: 'Recommended Buddies',
                      ),
                      Tab(text: 'Available Groups'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: TabBarView(
                      children: [
                        // Recommended Buddies Tab
                        ListView(
                          children: filterBuddies()
                              .map((buddy) => Card(
                                    color:
                                        const Color.fromARGB(255, 34, 39, 43),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Color(0xFF28B67E),
                                        child: Text(
                                          buddy['name']![0],
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                      title: Text(
                                        buddy['name']!,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        '${buddy['activity']} • ${buddy['skill']} • ${buddy['location']}',
                                        style: const TextStyle(
                                            color: Colors.white70),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.info,
                                                color: Color(0xFF28B67E)),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BuddyProfilePage(
                                                    buddyDetails: {
                                                      'name': buddy['name']!,
                                                      'profilePicture':
                                                          'assets/default_avatar.png',
                                                      'fitnessGoals':
                                                          'Lose weight, Build muscle',
                                                      'bio':
                                                          'Passionate about fitness and outdoor activities!',
                                                      'fitnessHistory':
                                                          'Completed a 10k run;Joined Yoga classes',
                                                      'phone': '123-456-7890',
                                                      'email':
                                                          'buddy@example.com',
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.person_add,
                                                color: Color(0xFF28B67E)),
                                            onPressed: () => addFriend(buddy),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                        // Available Groups Tab
                        ListView(
                          children: filterGroups()
                              .map((group) => Card(
                                    color: Colors.grey[850],
                                    child: ListTile(
                                      leading: const Icon(Icons.group,
                                          color: Color(0xFF28B67E)),
                                      title: Text(
                                        group['name']!,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        '${group['activity']} • ${group['location']}\n${group['details']}',
                                        style: const TextStyle(
                                            color: Colors.white70),
                                      ),
                                      trailing: const Icon(Icons.info,
                                          color: Color(0xFF28B67E)),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => GroupPage(
                                                groupId: 'group_id_1'),
                                          ),
                                        );
                                      },
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
          ],
        ),
      ),
    );
  }
}

class FriendsListPage extends StatelessWidget {
  final List<Map<String, String>> friends;

  const FriendsListPage({required this.friends});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Friends List',
          style: TextStyle(color: Color(0xFF28B67E)),
        ),
      ),
      body: friends.isEmpty
          ? const Center(
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
                  color: Colors.grey[850],
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFF28B67E),
                      child: Text(
                        friend['name']![0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      friend['name']!,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      '${friend['activity']} • ${friend['skill']} • ${friend['location']}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

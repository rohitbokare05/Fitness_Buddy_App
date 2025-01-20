import 'package:flutter/material.dart';

class AddGroupPage extends StatefulWidget {
  @override
  _AddGroupPageState createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String activity = '';
  String location = '';
  String details = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Navigator.pop(context, {
        'name': name,
        'activity': activity,
        'location': location,
        'details': details,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0xFF28B67E),
        title: const Text(
          'Add New Group',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Group Name',
                  style: TextStyle(color: Color(0xFF28B67E), fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Enter group name',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a group name'
                      : null,
                  onSaved: (value) => name = value!,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Activity',
                  style: TextStyle(color: Color(0xFF28B67E), fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Enter activity',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter an activity'
                      : null,
                  onSaved: (value) => activity = value!,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Location',
                  style: TextStyle(color: Color(0xFF28B67E), fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Enter location',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a location'
                      : null,
                  onSaved: (value) => location = value!,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Details',
                  style: TextStyle(color: Color(0xFF28B67E), fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Enter additional details',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                  onSaved: (value) => details = value ?? '',
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF28B67E),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32.0,
                        vertical: 12.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: _submitForm,
                    child: const Text(
                      'Add Group',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

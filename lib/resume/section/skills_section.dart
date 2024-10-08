// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, unnecessary_to_list_in_spreads

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../colors/color.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/skill.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  _SkillsSectionState createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  final List<Skill> _skills = [];
  final TextEditingController _skillNameController = TextEditingController();
  final TextEditingController _skillLevelController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _fetchSkills(); // Fetch existing skills when the widget initializes
  }

  @override
  void dispose() {
    _skillNameController.dispose();
    _skillLevelController.dispose();
    super.dispose();
  }

  void _fetchSkills() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      String userId = user.uid;
      DocumentSnapshot userDoc =
          await _firestore.collection('user_resume').doc(userId).get();

      if (userDoc.exists && userDoc.data() != null) {
        List<dynamic> skillsData = userDoc['skills'] ?? [];
        setState(() {
          _skills.clear();
          _skills.addAll(skillsData.map((skill) => Skill(
                name: skill['name'] ?? "",
                level: skill['level'] ?? "",
              )));
        });
      }
    }
  }

  void _addSkill() {
    if (_skillNameController.text.isNotEmpty &&
        _skillLevelController.text.isNotEmpty) {
      if (_editingIndex != null) {
        // Update existing skill
        setState(() {
          _skills[_editingIndex!] = Skill(
            name: _skillNameController.text,
            level: _skillLevelController.text,
          );
          _editingIndex = null; // Reset editing index
        });
      } else {
        // Add new skill
        setState(() {
          _skills.add(Skill(
            name: _skillNameController.text,
            level: _skillLevelController.text,
          ));
        });
      }
      _skillNameController.clear();
      _skillLevelController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in both fields')),
      );
    }
  }

  void _removeSkill(int index) {
    setState(() {
      _skills.removeAt(index);
    });
  }

  void _editSkill(int index) {
    Skill skill = _skills[index];
    _skillNameController.text = skill.name;
    _skillLevelController.text = skill.level;
    setState(() {
      _editingIndex = index; // Set editing index
    });
  }

  void _saveSkills() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      String userId = user.uid; // Use the current user's ID
      List<Map<String, dynamic>> skillsData = _skills.map((skill) {
        return {
          'name': skill.name ?? "",
          'level': skill.level ?? "",
        };
      }).toList();

      try {
        // Update the 'skills' array in the user's document in 'user_resume'
        await _firestore.collection('user_resume').doc(userId).update({
          'skills': skillsData,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Skills saved successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save skills: $e')),
        );
      }
    } else {
      // Handle the case when the user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please log in to save skills')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Skills',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildTextField(_skillNameController, 'Skill Name'),
          const SizedBox(height: 10),
          _buildTextField(_skillLevelController, 'Skill Level'),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _addSkill,
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.backgroundColor
                    // Background color
                    // Text color
                    ),
                child: Text(
                  _editingIndex != null ? 'Update Skill' : 'Add Skill',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _saveSkills,
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.backgroundColor
                    // Background color
                    // Text color
                    ),
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Added Skills:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ..._skills.asMap().entries.map((entry) {
            int index = entry.key;
            Skill skill = entry.value;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: Text('${skill.name} (${skill.level})'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editSkill(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeSkill(index),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {Function()? onTap, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      maxLines: maxLines,
      onTap: onTap,
    );
  }
}

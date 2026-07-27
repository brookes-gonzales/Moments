import 'package:flutter/material.dart';
import 'moment_entry.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() {
    return _AddEntryScreenState();
  }
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  TextEditingController textBox = TextEditingController();

  String mood = 'Happy';

  List<String> moods = [
    'Happy',
    'Calm',
    'Sad',
    'Anxious',
    'Grateful',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: moodColor(mood),
      appBar: AppBar(
        title: const Text('Moment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              child: TextField(
                controller: textBox,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Write about your day...',
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: mood,
                  isExpanded: true,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  dropdownColor: Colors.white,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  items: moods.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Container(
                        color: Colors.transparent,
                        child: Text(item),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      mood = value!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                MomentEntry entry = MomentEntry(
                  textBox.text,
                  mood,
                  DateTime.now(),
                );

                Navigator.pop(context, entry);
              },
            ),
          ],
        ),
      ),
    );
  }
}
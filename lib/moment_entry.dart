import 'package:flutter/material.dart';

class MomentEntry {
  String text;
  String mood;
  DateTime date;

  MomentEntry(this.text, this.mood, this.date);
}

Color moodColor(String mood) {
  if (mood == 'Happy') {
    return Colors.yellow.shade300;
  } else if (mood == 'Calm') {
    return Colors.purple.shade200; // 🔁 changed to purple
  } else if (mood == 'Sad') {
    return Colors.blue.shade200; // 🔁 changed to blue
  } else if (mood == 'Anxious') {
    return Colors.orange.shade200;
  } else {
    return Colors.green.shade200;
  }
}
import 'package:flutter/material.dart';
import 'moment_entry.dart';
import 'add_entry_screen.dart';
import 'detail_screen.dart';
import 'dart:ui';
import 'dart:math';
import 'dart:async';

class Dot {
  double top;
  double left;
  double size;
  Color color;
  double moveTop;
  double moveLeft;

  Dot(
    this.top,
    this.left,
    this.size,
    this.color,
    this.moveTop,
    this.moveLeft,
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  List<MomentEntry> entries = [];
  List<Dot> dots = [];

  Random random = Random();
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(milliseconds: 30),
      (timer) {
        moveDots();
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String getDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  void addDot(String mood) {
    double size = random.nextDouble() * 80 + 140;
    double top = random.nextDouble() * 500;
    double left = random.nextDouble() * 300;

    double moveTop = random.nextDouble() * 0.8 + 0.3;
    double moveLeft = random.nextDouble() * 0.8 + 0.3;

    if (random.nextBool()) {
      moveTop = moveTop * -1;
    }

    if (random.nextBool()) {
      moveLeft = moveLeft * -1;
    }

    dots.add(
      Dot(
        top,
        left,
        size,
        moodColor(mood).withOpacity(0.7),
        moveTop,
        moveLeft,
      ),
    );
  }

  void moveDots() {
    if (mounted == false) {
      return;
    }

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    setState(() {
      for (int i = 0; i < dots.length; i++) {
        dots[i].top = dots[i].top + dots[i].moveTop;
        dots[i].left = dots[i].left + dots[i].moveLeft;

        if (dots[i].top <= 0) {
          dots[i].moveTop = dots[i].moveTop * -1;
        }

        if (dots[i].top + dots[i].size >= screenHeight) {
          dots[i].moveTop = dots[i].moveTop * -1;
        }

        if (dots[i].left <= 0) {
          dots[i].moveLeft = dots[i].moveLeft * -1;
        }

        if (dots[i].left + dots[i].size >= screenWidth) {
          dots[i].moveLeft = dots[i].moveLeft * -1;
        }
      }
    });
  }

  Widget buildDot(Dot dot) {
    return Positioned(
      top: dot.top,
      left: dot.left,
      child: Container(
        height: dot.size,
        width: dot.size,
        decoration: BoxDecoration(
          color: dot.color,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.75),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: dot.color.withOpacity(0.35),
              blurRadius: 18,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget glassCard(MomentEntry entry, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: moodColor(entry.mood).withOpacity(0.55),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.8),
                    width: 1.8,
                  ),
                ),
                child: ListTile(
                  title: Text(
                    entry.mood,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    '${getDate(entry.date)}\n${entry.text}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          entry: entry,
                          deleteEntry: () {
                            setState(() {
                              entries.removeAt(index);

                              if (index < dots.length) {
                                dots.removeAt(index);
                              }
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 45,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.5),
                        Colors.white.withOpacity(0.05),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEntryList() {
    if (entries.isEmpty) {
      return const Center(
        child: Text(
          'No moments yet.\nTap + to add one.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          return glassCard(entries[index], index);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE8D8FF),
        foregroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
        onPressed: () async {
          MomentEntry? newEntry = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEntryScreen(),
            ),
          );

          if (newEntry != null) {
            setState(() {
              entries.add(newEntry);
              addDot(newEntry.mood);
            });
          }
        },
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFEAF6FF),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          ...dots.map((dot) => buildDot(dot)).toList(),

          SafeArea(
            child: Column(
              children: [
                Container(
                  height: 70,
                  alignment: Alignment.center,
                  child: const Text(
                    'Moments',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: buildEntryList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
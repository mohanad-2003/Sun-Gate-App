import 'package:flutter/material.dart';

class HomeAppBarSection extends StatelessWidget {
  final String userName;
  final String imagePath;

  const HomeAppBarSection({
    super.key,
    required this.userName,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white24,
            child: Image(image: AssetImage(imagePath)),
          ),
          const SizedBox(height: 26),
          Text(
            'Hi, $userName !',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Have You\nquestion today ?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              height: 1.4,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

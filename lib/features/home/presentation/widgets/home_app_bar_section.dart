import 'package:flutter/material.dart';

class HomeAppBarSection extends StatelessWidget {
  final String userName;
  final String? imageUrl;

  const HomeAppBarSection({super.key, required this.userName, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _HomeUserAvatar(imageUrl: imageUrl),
          const SizedBox(height: 26),
          Text(
            'Hi, $userName !',
            style: const TextStyle(
              //   color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          const Text(
            'Have You\nquestion today ?',
            style: TextStyle(
              //   color: Colors.white,
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

class _HomeUserAvatar extends StatelessWidget {
  final String? imageUrl;

  const _HomeUserAvatar({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    if (hasImage) {
      return CircleAvatar(
        radius: 24,
        // backgroundColor: Colors.white24,
        backgroundImage: NetworkImage(imageUrl!),
        onBackgroundImageError: (_, _) {},
        child: null,
      );
    }

    return const CircleAvatar(
      radius: 24,
      backgroundColor: Colors.white24,
      child: Icon(Icons.person, size: 28),
    );
  }
}

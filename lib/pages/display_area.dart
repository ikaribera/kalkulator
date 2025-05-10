import 'package:flutter/material.dart';

class DisplayArea extends StatelessWidget {
  final String text;

  const DisplayArea({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      padding: const EdgeInsets.all(24),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

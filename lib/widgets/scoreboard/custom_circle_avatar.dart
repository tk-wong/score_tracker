import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  final String name;
  final _radius = 20;
  const CustomCircleAvatar({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final avatarText = name.isNotEmpty ? name.characters.first : '?';

    // set duration to 0 to prevent background flickering when changing theme
    final animatedDuration = Duration.zero;
    return AnimatedContainer(
      duration: animatedDuration,
      curve: Curves.easeInOut,
      width: _radius * 2,
      height: _radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.primaryContainer,
      ),
      alignment: Alignment.center,
      child: AnimatedDefaultTextStyle(
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: _radius * 0.8,
          color: colorScheme.onPrimaryContainer,
        ),
        duration: animatedDuration,
        child: Text(avatarText),
      ),
    );
  }
}

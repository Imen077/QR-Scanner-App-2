import 'package:flutter/material.dart';
import 'package:ikutan/core/themes.dart';

class EventTile extends StatelessWidget {
  const EventTile({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: AppThemes.border),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.network(
                  'https://source.unsplash.com/random/800x600',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withAlpha(50),
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.error, size: 24),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Random Events',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(width: 8),
                Text('2024-51-12'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
